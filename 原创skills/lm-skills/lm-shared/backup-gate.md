# 备份门禁

所有 lm-* skill 覆写已有产物前的强制前置步骤。各 skill 只引用本文，不重复描述。

---

## 规则

> ⚠️ 若目标产物已存在于需求目录，任何覆写操作前**必须**先调用 `/lm-backup` 备份。
>
> 备份失败或未执行 = 禁止修改。
>
> 修改异常时可调用 `/lm-backup` 恢复。

---

## 适用产物

| Skill | 触发条件 |
|-------|---------|
| lm-clarify | context.md 已存在 |
| lm-solution | solution.md 已存在 |
| lm-prd | spec.md 或 prd.html 已存在 |
| lm-review | 待审产物已存在（整改前） |

---

## 备份文件位置

`<需求目录>/.backup/<文件名>.r<序号>.bak`

详见 `/lm-backup`。
