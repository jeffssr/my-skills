---
name: lm-solution
description: >
  LinkMed 产品方案。solution.md → 自检 → 用户确认。审查由用户决定是否派子代理。
  触发词：lm-solution, 写方案, 方案思路, 产品方案, solution。仅限 LinkMed 项目。
argument-hint: "<需求名称>"
user-invocable: true
disable-model-invocation: false
metadata:
  author: "jeffssr"
  version: "6.0.0"
  updated: "2026-06-09"
---

# lm-solution — 产品方案

职责：派子代理写方案 → 自检 → 用户确认。主代理只管协调、过滤、确认。不改源码。

---

## 方案定位

- 产品向文档，spec 的前置参考
- 像规范一样结构清晰，比 spec 更概要（不画 UI 交互，变更清单只列改什么）
- 第 3 节核心业务流程 = spec 第 1.2 节（内容完全一致，spec 从 solution 复制）

---

## 触发

| 触发 | 不触发 |
|------|--------|
| context.md 已产出，用户要出方案 | 需求还不明确（先 lm-clarify） |
| 用户说"出方案""怎么改" | 无需求描述 |
| 跳过 clarify 直接出方案（标注"⚠ 未经代码搜索验证"） | |

---

## 前置

1. 读 CLAUDE.md + 项目 memory
2. 读 `references/solution-guide.md`（模板 + 自查清单）
3. 收集前置产物：用户需求 + 对话上下文 + 澄清结论 + context.md（如有）
4. 确认需求目录（定义见 lm-backup「需求目录」章节）

---

## 备份门禁

详见 `../lm-shared/backup-gate.md`。若 solution.md 已存在，覆写前必须先备份。

---

## 流程

```
步骤 1：派 writer 子代理 → solution.md
  ↓
步骤 2：自检 → self-check-solution.md
  ↓
步骤 3：询问用户是否审查
  ├─ 是 → 调用 /lm-review → 整改 → 复查
  └─ 否 ↓
用户确认（第 7 节待确认项逐条提问）
  ↓
完成
```

---

## 步骤 1：派 writer 子代理

主代理 ≠ 写作者。派全新子代理 `writer-r<n>` 写 solution.md。

Writer prompt 见 `references/writer-prompt.md`，替换 `<占位符>` 后发送。

用 `ls` 验证 solution.md 存在且非空。

---

## 步骤 2：自检

检查维度：
- `references/solution-guide.md` 自查清单（格式规范 + 内容规范）
- `references/solution-review-guide.md` 全部检查项（A 格式规范 + B 内容正确性）

自检流程（格式、证据规则、修正循环）详见 `../lm-shared/self-check.md`。

自检文件：`<需求目录>/self-check-solution.md`

---

## 步骤 3：审查决策

自检通过后询问用户：

> solution.md 自检通过。是否派子代理审查？
> - 是（仅内容审查）→ 调用 /lm-review（输入：solution.md + 审查维度=references/solution-guide.md 自查清单 + references/solution-review-guide.md + 是否包含风格审查=否）
> - 是（含风格审查）→ 调用 /lm-review（输入：同上 + 是否包含风格审查=是）
> - 否 → 等下一步指示

审查整改流程和质疑过滤规则详见 `/lm-review`。

---

## 用户确认

自检 + 审查（如选择）通过后，呈现方案 + 第 7 节待确认清单。

**待确认项处理**：第 7 节有待确认项 → AskUserQuestion → 用户回答 → 结论写入正文（不是单独章节）→ 再问"方案是否通过？"

完成判定 = 用户确认 + 自检全通过 + 审查通过（如有）。缺任一项 ≠ 完成。

---

## 通用约束

内容约束和流程约束详见 `../lm-shared/constraints.md`。本 skill 特别强调：

1. **基于上游产物写方案** — 不凭空添加。没有 context.md 时标注"⚠ 未经代码搜索验证"
2. **变更清单按操作流程顺序** — 不按端分组、不按技术模块排
3. **第 7 节待确认项逐条选项化** — 本阶段结束前全部提问，不留入下一阶段
4. **主代理 ≠ 写作者** — 主代理自己写 = 产物作废
5. **审查质疑必须过筛** — 不照单全收
