# 图片插入指南

当用户提供图片并要求插入到 spec/prd 中时，按以下流程处理。

---

## 判断图片来源

```
用户提供的图片
├─ 是 URL（http/https 开头）→ 直接使用，跳到「插入位置」
└─ 是本地路径 → PicGo 上传 → 拿 URL → 跳到「插入位置」
```

---

## PicGo 上传（本地图片）

### 上传命令

PicGo 桌面端需开启 Server（PicGo 设置 → 设置Server → 开启）。默认 `127.0.0.1:36677`。

```bash
curl -s -X POST http://127.0.0.1:36677/upload \
  -F "list=@/absolute/path/to/image.png"
```

成功时返回 JSON 数组，取第一个元素即 URL：

```json
["https://your-cdn.com/abc123.png"]
```

### 上传失败处理

- `curl: (7) Failed to connect` → 提示："PicGo Server 未响应，请确认 PicGo 已开启且 Server 设置已启用（默认端口 36677）"
- PicGo 返回错误 JSON → 展示原始错误信息
- 不静默吞错

---

## 插入位置

图片作为原型图插入，位置 = 需求点的原型区域。

### spec.md 中的写法

```
**原型**：截图
  ![描述](URL)
```

`**原型**` 字段标注为"截图"，下面跟图片 markdown。如果用户给了图片描述/alt text 就用，否则用需求标题。

### prd.html 中的写法

原型嵌入区用 `<img>` 替代手绘 HTML 原型：

```html
<div class="proto-embed">
  <div class="proto-content" id="proto-sec-N">
    <img src="URL" alt="描述" style="max-width:100%;border-radius:8px;border:1px solid var(--border);" />
  </div>
</div>
```

图片样式：最大宽度 100%，圆角 8px，边框与原型卡片一致。

### 多张图片

用户给多张图时，按描述/顺序排列，`<img>` 之间用 `gap` 分隔：

```html
<div class="proto-embed">
  <div class="proto-content" id="proto-sec-N">
    <div style="display:flex;flex-direction:column;gap:16px;">
      <img src="URL1" alt="描述1" style="max-width:100%;border-radius:8px;border:1px solid var(--border);" />
      <img src="URL2" alt="描述2" style="max-width:100%;border-radius:8px;border:1px solid var(--border);" />
    </div>
  </div>
</div>
```

spec.md 中多张图逐行写：

```
**原型**：截图
  ![描述1](URL1)
  ![描述2](URL2)
```

---

## 剪贴板图片

用户可能直接粘贴图片（非文件路径）。此时先写入临时文件再上传：

```bash
# 图片数据已由用户提供，写入临时文件
# 上传后清理临时文件
curl -s -X POST http://127.0.0.1:36677/upload \
  -F "list=@/tmp/lm-prd-upload-$(date +%s).png"
```

---

## 与手绘原型的共存

同一需求点可能既有截图又有手绘原型（如截图展示现有页面 + 手绘标注修改点）。此时：

- spec: `**原型**：截图 + 需要（在原有基础上修改：…）`
- prd: proto-embed 内截图 `<img>` 在前，手绘原型 HTML 在后，各用注释分隔
