# 原型绘制规范

原型直接绘制在 prd.html 内，不独立成文件。只画 spec 已定义的。spec 没有的状态/文案/标签一律不画。

原型照常绘制，该有颜色有颜色，该有样式有样式。spec/PRD 正文不写 UI 设计细节，但原型不受此限制。

---

## 基本原则

- **截图优先**：用户提供图片作为原型时，直接用 `<img>` 嵌入截图，不再手绘 HTML 原型。多图时垂直排列。详见 `image-insert-guide.md`
- **代码驱动，忠实还原**：无截图时，先 grep + Read 完整原文件，然后复刻字段名、字段顺序、控件类型、布局结构、文案措辞、交互模式。视觉细节合理近似即可。如用户提供了 UI 资料优先参考
- **优先 Ant Design + frontend-design**：前端使用 Ant Design 5。优先用其组件 + `frontend-design:frontend-design` skill。两者都无法满足才手写
- HTML + CSS 内联于 prd.html，无外部依赖
- 只画新增/修改后的可见状态，不画 Before
- 每个 section 内同一需求点只有 1 个状态时，省略 `.section-title`；有多个变体时用 `state-label-inner` 区分变体/触发条件即可。原型中不写位置和触发场景（在 PRD 正文中以 blockquote 分行呈现）

---

## 改动标注

非全新页面/弹窗/模块时，整块复刻 + `.changed` 标注改动点。

| 改动类型 | 做法 |
|----------|------|
| 列表加一列 | 复刻整个表格，新增列用 `.changed` |
| 筛选区加筛选项 | 复刻整个筛选行，新增项用 `.changed` |
| 某处加按钮/文案变化 | 复刻该区域，变化用 `.changed` |
| 全新页面/弹窗/模块 | 直接画，不需要 `.changed` |

---

## 原型结构

```html
<div class="proto-embed">
  <div class="proto-content" id="proto-sec-N">
    <!-- section-title 仅在有多个独立变体且需要区分上下文时使用；单一状态省略 -->
    <!-- <div class="section-title">N. 模块名</div> -->
    <div class="state-grid">
      <div class="state-block">
        <span class="state-label-inner">变体标题 / 触发条件</span>
        <!-- 内容 -->
      </div>
    </div>
  </div>
</div>
```

原型中不写位置和触发场景（在 PRD 正文中以 blockquote 分行呈现）。

---

## 截图原型

spec 标注 `**原型**：截图` 时，proto-embed 内用 `<img>` 替代手绘 HTML：

```html
<div class="proto-embed">
  <div class="proto-content" id="proto-sec-N">
    <img src="URL" alt="描述" style="max-width:100%;border-radius:8px;border:1px solid var(--border);" />
  </div>
</div>
```

多张图时垂直排列，`gap:16px`。样式统一：`max-width:100%; border-radius:8px; border:1px solid var(--border)`。

---

## 布局规则

**默认 `cols-1`。仅在用户明确要求并排对比、且内容宽度足够时才用 `cols-2`。**

| 内容类型 | 布局 | state-grid class |
|----------|------|------|
| 整页表单/确认页/列表 | 单列（默认） | `cols-1`（minmax(0,740px)） |
| 弹窗/卡片并排（用户明确要求且宽度够） | 并排 | `cols-2`（1fr 1fr） |
| 小卡片 | 一行多个 | `cols-2`（auto-fill, minmax(356px, 1fr)） |
| 简单变体（仅文案/颜色不同） | 画一个 + 文字说明 | — |
| 单个 block | 单列 | `cols-1` |

- 宽度不够时：左右改上下（`cols-2` → `cols-1`）
- 状态全量平铺，不用 Tab。每个 state-block 左上角 `.state-label-inner`

---

## 样式约定

- 主色：`#04b8cc`，灰底：`#f7f8fa`
- 字体：`'Noto Sans SC','PingFang SC','Microsoft YaHei'` + 系统字体栈
- 主文字 `#1e1e1e`，次要 `#6b7280`，辅助 `#9ca3af`
- 卡片圆角 `var(--radius)` = 8px，按钮圆角 6px

---

## 常见 HTML 片段

### 改动标注
```html
<select class="changed" style="padding:4px 8px;border:1px solid #d9d9d9;border-radius:4px;">
  <option>All</option>
</select>
<th class="changed">New Column</th>
<span class="changed">Changed Text</span>
```

### 只读字段
```html
<div class="form-group">
  <span class="form-label">Field Label</span>
  <div class="form-readonly">Value</div>
</div>
```

### 确认弹窗
```html
<div class="confirm-overlay">
  <div class="confirm-box">
    <div class="confirm-title">Confirm Title</div>
    <div class="confirm-body">...</div>
    <div class="confirm-ft">
      <button class="btn btn-sm">Cancel</button>
      <button class="btn btn-sm btn-primary">Confirm</button>
    </div>
  </div>
</div>
```

---
