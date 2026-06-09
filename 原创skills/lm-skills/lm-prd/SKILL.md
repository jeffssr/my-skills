---
name: lm-prd
description: LinkMed 需求规格+原型。solution.md → spec.md → prd.html。触发词：写spec/画原型/写PRD/需求文档。
argument-hint: "<需求名称>"
user-invocable: true
disable-model-invocation: false
metadata:
  author: "jeffssr"
  version: "9.0.0"
  updated: "2026-06-09"
---

# lm-prd — spec.md + prd.html

先写 spec.md，再生成 prd.html，最后统一自检。审查由用户决定。不改源码。

---

## 前置条件判断

执行前先判断当前场景，决定流程分支：

```
solution.md 存在？
├─ 是 →
│   ├─ spec.md 不存在 → 新建流程：步骤 1 写 spec + 步骤 2 写 prd
│   ├─ spec.md 存在但 prd.html 不存在 → 仅走步骤 2 写 prd
│   └─ 两者都存在 → 修改流程（见 modification-guide.md）
├─ 否 →
│   ├─ spec.md + prd.html 都存在 → 修改流程（见 modification-guide.md）
│   ├─ 用户指定了来源文档 → 以指定文档为来源，走新建或修改流程
│   └─ 无任何来源 → 询问用户确认内容来源后再继续
```

---

## 核心流程与方案思路的关系

spec > 核心业务流程 = solution.md 核心业务流程节。内容完全一致，不可重写、不可增减、不可变序、不可改措辞。

其他章节：新需求以 solution.md 为大纲展开；修改已有需求以用户指定的已有 spec.md/prd.html 为来源。

---

## 前置（按需加载）

1. 读 CLAUDE.md + 项目 memory
3. **写 spec 时读取**：`references/writing-rules.md` + `references/spec-template.md`
4. **写 prd 时读取**：`references/prd-guide.md` + `references/prototype-guide.md` + `references/css-template.css`
5. 确认需求目录存在（定义见 lm-backup「需求目录」章节）
6. 确认 `frontend-design` skill 是否可用（优先使用，不可用时手写）

> 按当前步骤按需加载，节省上下文。

---

## 备份门禁

详见 `../lm-shared/backup-gate.md`。若 spec.md 或 prd.html 已存在，覆写前必须先备份。

---

## 步骤 1：写 spec.md

严格遵循 `references/spec-template.md` 模板 + `references/writing-rules.md` 规范。

### 内容来源

- 新需求：solution.md 为大纲展开
- 修改已有需求：用户指定的已有 spec.md/prd.html 为来源

### 写前必做

按 `../lm-shared/constraints.md` 3.1（写前 grep + Read）执行。用户提供的 UI 资料优先于代码。

### 核心流程

新需求：spec > 核心业务流程 从 solution.md **完整复制**。修改需求：如 solution.md 给了新流程则更新，否则保持原有。

### 写完验证

新需求：变更清单 ↔ spec 对应？spec 每点 ↔ 变更清单？待确认每项 ↔ spec 有去向？核心业务流程与 solution.md 逐字一致？

修改需求：修改内容与用户要求一致？规范/模板/格式已修正？spec 修改能在 prd 同步体现？

---

## 步骤 2：生成 prd.html

严格遵循 `references/prd-guide.md` 指南 + `references/prototype-guide.md` 规范。CSS 只用标准模板。

### 内容来源

- 正文：直接从 spec.md 复制，逐节转 HTML，不重写不改写
- 原型：以 spec 为唯一来源，spec 写了什么状态就画什么

### 生成前必做

画原型前按 `../lm-shared/constraints.md` 3.1（写前 grep + Read）执行。用户提供的 UI 资料优先。

### 需求点内容顺序

每个需求点按：序号 需求标题 → 位置 → 触发场景 → 原型（嵌入需求点下方）→ 核心逻辑。位置和触发场景分两行。

---

## 步骤 3：统一自检 spec + prd

spec.md 和 prd.html 均完成后，按审查标准统一自检。**自检维度 = 审查维度**。

### 分级自检

| 级别 | 适用场景 | 检查范围 |
|------|---------|---------|
| **关键项自检**（默认） | 所有场景 | 仅 ★ 标记项（19 项：spec ★8 + prd ★11） |
| **完整自检**（deep-check） | 首次交付 / 重大修改 | 全部检查项（~100 项） |

- 关键项（★）定义见 `references/spec-review-guide.md` 和 `references/prd-review-guide.md`
- 用户未指定时默认走关键项自检；首次生成建议走完整自检

### 自检维度

- spec：`references/spec-review-guide.md`（A 模板结构 + B 内容正确性 + C 写作规范）
- prd：`references/prd-review-guide.md`（A 正文对齐 + B 原型对齐 + C CSS/样式规范 + D 侧边栏与导航 + E 其他）

### 自检执行

自检流程（格式、证据规则、修正循环）详见 `../lm-shared/self-check.md`。

自检文件：`<需求目录>/self-check-prd.md`

修正时 spec 和 prd 必须同步修正。备份门禁见 `../lm-shared/backup-gate.md`。

---

## 步骤 4：审查决策

自检通过后询问用户：

> spec.md + prd.html 自检通过。是否派子代理审查？
> - 是（仅内容审查）→ 调用 /lm-review（输入：spec.md + prd.html + 审查维度=references/spec-review-guide.md + references/prd-review-guide.md + 是否包含风格审查=否）
> - 是（含风格审查）→ 调用 /lm-review（输入：同上 + 是否包含风格审查=是）
> - 否 → 完成

---

## 通用约束

内容约束和流程约束详见 `../lm-shared/constraints.md`。写作规范详见 `references/writing-rules.md`。

---

## 完成

验证所有产物文件存在后：

```
lm-prd 完成。
产出：spec.md + prd.html
前置依赖：lm-clarify → context.md（如有），lm-solution → solution.md
spec.md + prd.html 可交付开发。
```
