# PRD 审查维度

lm-prd prd.html 专有的审查维度，供 /lm-review 调用时追加。自检与审查共用同一标准。

通用审查流程和质疑过滤规则见 `/lm-review`。审查员输出必须按 `/lm-review/references/report-format.md` 格式，缺字段的质疑项 = 无效。通用约束详见 `../lm-shared/constraints.md`。

---

## 审查输入

调用 /lm-review 审查 prd 时，需额外提供：
- `references/prd-guide.md` 全文（PRD 生成指南）
- `references/css-template.css` 全文（标准 CSS 模板依据）
- `references/prototype-guide.md` 全文（原型规范）
- `spec.md` 全文（内容正确性基准）

---

## 审查维度（PRD 特有）

> ★ = 关键项自检覆盖项（默认级别），无标记 = 完整自检覆盖项

### A. 正文对齐（最高优先级）

| # | ★ | 维度 | 检查点 |
|---|---|------|--------|
| 1 | ★ | 需求List | 每行与 spec 完全一致（不缺/不多/不改词）？列顺序为 `产品端 \| 需求点`？ |
| 2 | | section 标题 | 与 spec 完全一致？ |
| 3 | ★ | 位置和触发场景 | 分两行（blockquote 内各一个 `<p>`）？与 spec 逐字一致？ |
| 4 | ★ | 核心逻辑 | 逐句与 spec 一致（不缺句/不改词/不自加）？ |
| 5 | ★ | 需求点顺序 | 位置/触发场景（blockquote）→ proto-embed → 核心逻辑（h4 + 正文）？**proto-embed 在核心逻辑之前**？ |
| 6 | | 编号规范 | 端名渲染为 section-group-title、需求点渲染为 h2？编号：## 一、二、... → ### 1/2/3...（每端重新编号）？ |

### B. 原型对齐

| # | ★ | 维度 | 检查点 |
|---|---|------|--------|
| 7 | | 原型结构 | 只有 proto-content → state-grid（**无 section-meta**）？ |
| 8 | ★ | section-title 使用 | 单一状态无 section-title；多变体时用 state-label-inner 区分，不额外加 section-title 重复描述 |
| 9 | | 变体标题 | state-label-inner 区分变体/触发条件，与 spec 对应？ |
| 10 | ★ | 原型覆盖 | spec "需原型"的都有？spec "无需原型"的无残留？ |
| 11 | | 文案溯源 | 原型每句文案都能溯源到 spec？ |
| 12 | ★ | 内容边界 | PRD 是否超出 spec 自加文案/状态/标签/功能？ |
| 13 | ★ | 布局规范 | 默认 cols-1？单 block 未用 cols-2？用户未要求并排时未用 cols-2？ |

### C. CSS/样式规范

关键项：
| # | ★ | 维度 | 检查点 |
|---|---|------|--------|
| 14 | ★ | CSS 模板 | 只用标准模板 class？无自创 class/规则？ |
| 15 | ★ | .changed | 全新模块无 .changed？改已有模块有 .changed？ |
| 16 | | Mermaid | spec 有→PRD 继承；spec 文字→PRD 不升级 |
| 17 | | 组件一致性 | 同一 UI 组件出现 ≥2 次时样式一致？ |

完整项（deep-check 时追加）：prd-guide.md 不可更改项（13条）+ prototype-guide.md 全部规则。

### D. 侧边栏与导航

| # | ★ | 维度 | 检查点 |
|---|---|------|--------|
| 18 | | sidebar-title | sidebar-header 中无需求名称（`.sidebar-title`）？ |
| 19 | | hero-badge | hero 区无 `.hero-badge`？ |
| 20 | | 导航层级 | 一级导航可点击？二/三级导航缩进合理？最多三级？ |

### E. 其他

| # | ★ | 维度 | 检查点 |
|---|---|------|--------|
| 21 | | 正文 UI 设计细节 | PRD 正文（非原型）无颜色/对齐/间距/字体大小描述？ |
| 22 | | 移动端 | ≤900px 侧边栏折叠？原型 grid 单列？ |
| 23 | | 废弃检查 | 废弃功能无降级/兼容/fallback 残留？ |
| 24 | | UI 资料优先 | 用户提供了 UI 资料时原型优先参考？ |
| 25 | | 文档修改同步 | 修改场景 spec+prd 同步更新？原型在原有基础上改（用户未要求重画时）？ |

---

## 关键项自检覆盖面（★ 汇总）

**10 项**（PRD 侧）：A1 需求List（含列顺序）、A3 位置和触发场景、A4 核心逻辑、A5 需求点顺序（含proto-embed位置）、B8 section-title使用、B10 原型覆盖、B12 内容边界、B13 布局规范、C14 CSS模板、C15 .changed

---

## 质疑分类枚举

正文对齐 / 原型对齐 / 内容超出spec / 文案溯源 / 无需原型残留 / changed标注 / CSS规范 / 原型结构 / section-title使用 / 变体标题 / 正文UI设计细节 / 自创功能或样式 / 组件一致性 / 布局规范 / proto-embed位置 / 编号规范 / 端分组规范 / sidebar-title / hero-badge / 导航层级 / 移动端 / 废弃检查 / UI资料优先 / 文档修改同步 / 原型修改策略

> 以上为审查覆盖面，报告"类别"字段仍须使用 report-format.md 定义的 5 个标准类别（事实错误/规则违反/遗漏/逻辑矛盾/建议优化），此处仅用于审查员自检覆盖完整性。
