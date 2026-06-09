---
name: lm-review
description: 共享审查流程。被 lm-clarify/solution/prd 调用，不独立触发。
argument-hint: ""
user-invocable: false
disable-model-invocation: false
metadata:
  author: "jeffssr"
  version: "2.0.0"
  updated: "2026-06-09"
---

# lm-review — 共享审查流程

## 触发方式

由其他 skill 通过引用本 skill 触发。调用时需提供：

| 参数 | 说明 |
|------|------|
| 产物路径 | 待审查产物的文件路径 |
| 产物类型 | solution / context / spec / prd |
| 审查维度 | 产物特有的审查维度（调用方定义） |
| 输出目录 | 审查报告和过滤报告的写入目录。未指定时默认为产物所在目录（即 lm-backup「需求目录」定义的路径） |
| 是否包含风格审查 | 默认否；用户明确要求时为是 |

## 执行

1. ⚠️ **备份门禁**：详见 `../lm-shared/backup-gate.md`。整改覆写前必须先备份
2. 读取 references/
   - `review-flow.md` — 6 步流程（含逐条手术整改 + 整改记录 + 复查）
   - `filter-rules.md` — 质疑过滤规则（含"建议优化"自动驳回）
   - `report-format.md` — 审查报告格式（含字段要求和类别枚举）
3. 按流程执行
4. 产物随调用方的流程继续

## 产出物清单

| 文件 | 说明 |
|------|------|
| `review-r{n}-{1\|2}.md` | 审查员报告 |
| `review-filter-r{n}.md` | 质疑过滤报告 |
| `review-fix-r{n}.md` | 整改记录（逐条：定位+修改前+修改后+是否连带） |
| `self-check-review-r{n}.md` | 复查记录（逐条验证+非质疑区域未动） |

## 审查维度（调用方补充）

每个调用方需声明产物特有的审查维度。通用维度：

- 一致性：与上游产物（spec / context）一致
- 完整性：覆盖所有受影响点
- 规范性：符合写作约束和模板结构
- 准确性：事实和表述正确

调用方追加维度示例：
- lm-solution：变更清单顺序（操作流程 vs 按端分组）、技术细节泄露
- lm-clarify：搜索维度覆盖、代码模块识别完整性
- lm-prd：proto-embed 在核心逻辑之前、原型 section-title 使用规范、导航层级合规、编号全局层级递增、CSS 规范遵守、交互标注完整性
