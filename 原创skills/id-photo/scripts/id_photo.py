#!/usr/bin/env python3
"""证件照生成工具 - 将普通照片裁切为标准证件照尺寸"""
import argparse
import os
import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("需要安装 Pillow: pip install Pillow")
    sys.exit(1)

# 标准证件照尺寸 (宽px, 高px) @ 300 DPI
STANDARD_SIZES = {
    "1寸":   (295, 413),
    "大1寸":  (390, 567),
    "小2寸":  (413, 531),
    "2寸":   (413, 579),
    "3寸":   (649, 991),
}


def crop_to_aspect_ratio(img, target_w, target_h):
    """以图片中心为锚点裁切至目标宽高比，优先裁切宽度（左右）"""
    src_w, src_h = img.size
    target_ratio = target_w / target_h
    src_ratio = src_w / src_h

    if abs(src_ratio - target_ratio) < 0.001:
        return img

    if src_ratio > target_ratio:
        # 源图比目标宽 → 裁切左右
        new_w = int(src_h * target_ratio)
        left = (src_w - new_w) // 2
        return img.crop((left, 0, left + new_w, src_h))
    else:
        # 源图比目标窄 → 裁切上下
        new_h = int(src_w / target_ratio)
        top = (src_h - new_h) // 2
        return img.crop((0, top, src_w, top + new_h))


def resize_to_target(img, target_w, target_h):
    """缩放至目标像素尺寸"""
    return img.resize((target_w, target_h), Image.LANCZOS)


def save_with_size_limit(img, output_path, max_size_bytes, fmt="JPEG"):
    """保存图片，通过二分查找质量参数控制文件大小"""
    ext = os.path.splitext(output_path)[1].lower()

    if ext == ".png":
        for level in range(1, 10):
            img.save(output_path, format="PNG", compress_level=level)
            if os.path.getsize(output_path) <= max_size_bytes:
                return True
        return False

    # JPEG: 先试最高质量
    img.save(output_path, format=fmt, quality=95, subsampling=0)
    if os.path.getsize(output_path) <= max_size_bytes:
        return True

    # 二分查找最佳质量
    low, high = 10, 94
    best_path = None

    while low <= high:
        mid = (low + high) // 2
        tmp = output_path + ".tmp.jpg"
        img.save(tmp, format=fmt, quality=mid, subsampling=0)
        sz = os.path.getsize(tmp)

        if sz <= max_size_bytes:
            best_path = tmp
            low = mid + 1
        else:
            high = mid - 1
            os.remove(tmp) if os.path.exists(tmp) else None

    if best_path and os.path.exists(best_path):
        os.replace(best_path, output_path)
        return True

    # 最低质量兜底
    img.save(output_path, format=fmt, quality=10)
    return os.path.getsize(output_path) <= max_size_bytes


def process(input_path, size_name=None, width_px=None, height_px=None,
            max_size_mb=1, output_format="jpg", output_dir=None):
    """处理证件照：裁切 → 缩放 → 压缩保存"""
    img = Image.open(input_path)

    # 确定目标尺寸
    if size_name and size_name in STANDARD_SIZES:
        target_w, target_h = STANDARD_SIZES[size_name]
    elif width_px and height_px:
        target_w, target_h = width_px, height_px
    else:
        print(f"错误: 未知尺寸 '{size_name}'")
        print(f"可选: {', '.join(STANDARD_SIZES.keys())}，或用 --width/--height 指定像素")
        sys.exit(1)

    # RGBA/P/LA → RGB 白底
    if img.mode != "RGB":
        bg = Image.new("RGB", img.size, (255, 255, 255))
        if img.mode in ("RGBA", "LA", "PA"):
            img = img.convert("RGBA")
            bg.paste(img, mask=img.split()[-1])
        else:
            img = img.convert("RGB")
            bg.paste(img)
        img = bg

    # 裁切至目标宽高比（中心锚点，优先裁宽度）
    img = crop_to_aspect_ratio(img, target_w, target_h)

    # 缩放至目标像素
    img = resize_to_target(img, target_w, target_h)

    # 输出路径
    src = Path(input_path)
    out_dir = Path(output_dir) if output_dir else src.parent
    suffix = size_name if size_name else f"{target_w}x{target_h}"
    ext = f".{output_format.lower().replace('jpeg', 'jpg')}"
    output_path = out_dir / f"{src.stem}_{suffix}{ext}"

    # 保存
    max_bytes = int(max_size_mb * 1024 * 1024)
    fmt = "JPEG" if ext in (".jpg", ".jpeg") else "PNG"
    save_with_size_limit(img, str(output_path), max_bytes, fmt)

    actual_kb = os.path.getsize(output_path) / 1024
    print(f"输出: {output_path}")
    print(f"像素: {target_w}×{target_h}px")
    print(f"大小: {actual_kb:.0f}KB / {max_size_mb}MB")
    return str(output_path)


if __name__ == "__main__":
    p = argparse.ArgumentParser(description="证件照生成工具")
    p.add_argument("input", help="输入图片路径")
    p.add_argument("--size", help="标准尺寸: 1寸/大1寸/小2寸/2寸/3寸")
    p.add_argument("--width", type=int, help="自定义宽度(px)")
    p.add_argument("--height", type=int, help="自定义高度(px)")
    p.add_argument("--max-size", type=float, default=1, help="最大文件大小(MB), 默认1")
    p.add_argument("--format", default="jpg", help="输出格式 (jpg/png), 默认jpg")
    p.add_argument("--output-dir", help="输出目录, 默认与原图同目录")
    args = p.parse_args()

    process(args.input, args.size, args.width, args.height,
            args.max_size, args.format, args.output_dir)
