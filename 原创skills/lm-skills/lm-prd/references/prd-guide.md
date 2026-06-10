# prd.html 需求规格生成指南

将 spec.md 转为自包含 Wiki 风格 HTML，原型直接内联绘制。

---

## 生成步骤

1. 确认 spec.md 已完成
2. Read `references/css-template.css`，将完整 CSS 嵌入 `<style>` 标签
3. 将 spec.md 每个 section 映射为正文 HTML
4. 按 `references/prototype-guide.md` 规范绘制原型，嵌入到对应需求点下方。spec 标注 `**原型**：截图` 时用 `<img>` 嵌入截图，不需要手绘
5. spec 有 Mermaid → PRD 原样复制；spec 无 Mermaid → 不新增
6. 构建侧边栏 TOC
7. 统一自检 spec + prd（见 SKILL.md 步骤 3）

---

## 基本原则

- **单文件自包含**：仅依赖 mermaid CDN，其余全部内联
- **Wiki 布局**：左侧固定侧边栏（280px）+ 右侧正文滚动区
- **内容来源**：spec.md 是正文唯一来源，原型嵌入到对应需求点下方
- **正文与 spec 逐句一致**：需求List 每行、section 标题、位置、触发场景、核心逻辑逐句 = spec 原文。详见 `../lm-shared/constraints.md`
- **原型以 spec 为唯一来源**：spec 没有的 UI 元素一律不画。详见 `../lm-shared/constraints.md`

---

## 页面架构

```
┌──────────────┬──────────────────────────────────────┐
│  Sidebar     │  Main Content                        │
│  (fixed      │                                      │
│   280px)     │  Hero (h1 + subtitle)                │
│              │                                      │
│  Logo        │  ## 一、综述                           │
│  Meta        │  ## 二、平台端                         │
│  Nav         │  ## 三、Portal 端                      │
│  Footer      │  ... (原型嵌入需求点下方)              │
│              │                                      │
└──────────────┴──────────────────────────────────────┘
```

---

## 侧边栏规范

- 宽度 280px，固定定位，左侧，背景 `#f8f9fa`
- Header：Logo（"LinkMed 需求规格"）+ 需求名称（`.sidebar-title`）+ 日期（`.sidebar-meta` 只写日期，如 `2026-05-29`）

```html
<div class="sidebar-header">
  <div class="sidebar-logo">LinkMed 需求规格</div>
  <div class="sidebar-title">需求名称</div>
  <div class="sidebar-meta">2026-05-29</div>
</div>
```
- Hero 区：`<h1>` 标题 + `.hero-sub` 副标题
- Nav：TOC 锚点链接，指向正文 section 的 `id`。激活样式：cyan 左边框 + cyan 文字 + cyan 浅底
- **导航层级**：一级导航（端/模块分组）用 `<a class="nav-section" href="#section-id">`，可点击跳转；二级导航用 `<a class="nav-sub" href="#section-id">`，缩进；三级导航更深缩进（必要时使用），最多三级。**nav-section 必须用 `<a>` + `href`，不可用 `<div>` / `<span>`**

侧边栏 TOC 结构示例（每个 spec `##` 节对应一个 nav-section）：
```html
<nav class="sidebar-nav">
  <a class="nav-section" href="#overview">一、综述</a>
  <a class="nav-sub" href="#req-1">1. 现状 & 问题</a>
  <a class="nav-sub" href="#req-2">2. 核心业务流程</a>
  <a class="nav-sub" href="#req-3">3. 需求 List</a>

  <a class="nav-section" href="#platform">二、平台端</a>
  <a class="nav-sub" href="#req-4">4. 需求点标题</a>

  <a class="nav-section" href="#portal">三、Portal 端</a>
  <a class="nav-sub" href="#req-5">5. 需求点标题</a>

  <a class="nav-section" href="#email">四、邮件</a>
  <a class="nav-sub" href="#req-6">6. 通知标题</a>
</nav>
```
- 移动端（≤900px）：侧边栏左滑隐藏，汉堡按钮 + 遮罩层

---

## 正文内容渲染规则

### 标题层级

| spec.md | PRD HTML |
|---------|----------|
| `# 标题` | Hero 区 `<h1>` |
| `## 一、综述` / `## 二、平台端` / `## 三、Portal 端` / `## 四、邮件` | `<h2>` + 底部分割线 |
| `### 1/2/3...`（需求点） | `<h3>` + 底部分割线 |
| `#### 1.1/1.2...`（需求点内子节） | `<h4>` |
| `##### 1.1.1/1.2.1...`（更深子节） | `<h4>` |

### 端分组与编号

编号与 spec.md 完全一致（整篇持续编号，规范见 `spec-template.md`），正文直接复制。

所有 `##` 同级统一渲染为 `<h2>`，`###` 渲染为 `<h3>`。自然层级映射，不因"综述"或"端名"做差异化处理。

每个 `##` 和 `###` 节用 `<section id="...">` 包裹。端分组用 `<div class="section-group">` 包裹同端的需求点 `<section>`（不含端标题 `<section>`），仅作视觉分组容器。

正文结构示例：
```html
<div class="main">
  <div class="hero"><h1>标题</h1><p class="hero-sub">副标题</p></div>

  <section id="overview">
    <h2>一、综述</h2>
    <h3>1. 现状 & 问题</h3>
    ...
    <h3>2. 核心业务流程</h3>
    ...
    <h3>3. 需求 List</h3>
    ...
  </section>

  <section id="platform">
    <h2>二、平台端</h2>
  </section>
  <div class="section-group">
    <section id="req-4">
      <h3>4. 需求点标题</h3>
      ...
    </section>
  </div>

  <section id="portal">
    <h2>三、Portal 端</h2>
  </section>
  <div class="section-group">
    <section id="req-5">
      <h3>5. 需求点标题</h3>
      ...
    </section>
  </div>
</div>
```

### 引用块

位置和触发场景分两行（见 spec-template.md 需求点顺序）：
```html
<blockquote>
  <p><strong>位置</strong>：平台端 &gt; 订单处理抽屉 &gt; Decline 弹窗</p>
  <p><strong>触发场景</strong>：点击页脚 [Decline Service] 按钮 → 弹窗弹出后</p>
</blockquote>
```

### 邮件内容

使用 `.email-content` 容器（字体与正文一致，非等宽代码块）。新增行用 `<span class="new-line">← 新增行</span>` 标注。

```html
<div class="email-content">
  邮件正文内容...
  <span class="new-line">← 新增行</span>
</div>
```

spec 中通知内容用 markdown 代码块；PRD 中用 `<pre>` 标签，前加 `<p><strong>内容</strong>：</p>`。

---

## 原型嵌入规范

原型内容直接内联到正文对应需求点下方，**顺序严格为：位置 → 触发场景（blockquote）→ proto-embed → 核心逻辑（h4 + 正文）**，proto-embed 必须在核心逻辑内容之前。

```html
<div class="proto-embed">
  <div class="proto-content" id="proto-xxx">
    <!-- 原型 HTML 内容 -->
  </div>
</div>
```

原型 CSS 全部在 `.proto-content` 下重写，不与 wiki 样式冲突。保留 `.changed` 标注样式。

---

## Mermaid 流程图

容器：`<div class="mermaid-wrap"><pre class="mermaid">...</pre></div>`

Mermaid 以 spec 为准：spec 有→PRD 继承；spec 文字→PRD 保持文字；spec 无→不创建。

主题配置：
```js
mermaid.initialize({
  startOnLoad: false,
  theme: 'neutral',
  themeVariables: {
    primaryColor: '#e6f7ff',
    primaryBorderColor: '#04b8cc',
    primaryTextColor: '#1e1e1e',
    lineColor: '#9ca3af',
    fontSize: '14px',
  },
  flowchart: { useMaxWidth: true, htmlLabels: true, curve: 'basis' },
});
```

---

## CSS 样式规范

生成 prd.html 时，**必须 Read `references/css-template.css` 并逐字嵌入** `<style>` 标签内。不自己写，不差异。

- 原型照常使用模板 CSS（该有颜色有颜色）
- spec/PRD 正文不写 UI 设计细节，但原型不受此限制
- CSS 只用标准模板。详见 `../lm-shared/constraints.md`

---

## 不可更改项

| # | 禁止 | 标准做法 |
|---|------|---------|
| 1 | sidebar 用 `.logo`/`.meta`（非标准缩写） | 用 `.sidebar-logo`/`.sidebar-meta` |
| 2 | sidebar-header 缺少需求名称（`.sidebar-title` 元素） | 必须包含 Logo + 需求名称（`.sidebar-title`）+ 日期（`.sidebar-meta`） |
| 3 | hero 用 `.badge`/`.subtitle` | 用 `.hero-sub`；禁止加 `.hero-badge` |
| 4 | h2 border 用 `2px solid var(--cyan)` | 用 `1px solid var(--border)` |
| 5 | state-label 用 inline-block 浅色底 | 用 `.state-label-inner` absolute定位+cyan实心底 |
| 6 | main 用 flex+`.content` wrapper | 用 `.main` 直接 margin-left + padding |
| 7 | 汉堡按钮用 `.hamburger` | 用 `.burger` |
| 8 | 自创 CSS class 名 | 只使用模板中已有的 class |
| 9 | 弹窗宽度自定 | modal-box 用 max-width:740px |
| 10 | 自创 CSS 规则（含 max-width） | 只用标准 CSS 模板中已定义的规则 |
| 11 | sidebar-meta 自创格式 | 格式严格按已有 PRD 基准，只写日期 |
| 12 | 同一 UI 组件多次出现时手写不一致 | 先写一份完善版，后续 copy-paste 微调 |
| 13 | spec 中文写"标记为'图片'"，原型画 "Img" | 用户面向标签英文原名，与原型逐字一致 |
| 14 | nav-section 用 `<div>` / `<span>`（无 href，不可点击） | nav-section 必须用 `<a href="#id">`，不可用 `<div>`/`<span>` |
| 15 | `##` 标题按"综述/端名"做差异化渲染（h2 vs section-group-title） | 所有 `##` 统一渲染为 `<h2>`，端分组仅作视觉容器 |
