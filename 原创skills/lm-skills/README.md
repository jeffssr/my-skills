# lm-skills — LinkMed 需求文档技能套件

Claude Code 技能套件，覆盖需求澄清 → 方案设计 → PRD 撰写 → 审查全流程。

> 本目录是 [my-skills](https://github.com/<user>/my-skills) 仓库的子技能套件，位于 `原创skills/lm-skills/`。
> install.sh 用 `$SCRIPT_DIR` 自定位，搬到任何位置都能正常工作。

## 技能清单

| 技能 | 用途 | 触发词 |
|------|------|--------|
| `lm-clarify` | 需求澄清 + 代码搜索 → context.md | 澄清需求, 搜代码 |
| `lm-solution` | 产品方案 → solution.md | 写方案, 方案思路 |
| `lm-prd` | 需求规格 + 交互原型 → spec.md + prd.html | 写spec, 画原型, 写PRD |
| `lm-review` | 共享审查流程（被其他技能调用） | (内部) |
| `lm-backup` | 需求文档版本备份与恢复 | 备份, 回退 |
| `lm-shared` | 通用约束与流程（内部依赖，非技能） | — |

## 依赖关系

```
lm-clarify ──→ lm-solution ──→ lm-prd
     │              │              │
     └──────────────┼──────────────┘
                    ↓
              lm-review（审查）
                    ↓
              lm-backup（备份门禁）

所有技能共享 lm-shared/（通用约束、自检流程、备份门禁）
```

## 安装

### 前置：获取仓库

```bash
# 克隆整个 my-skills 仓库（推荐）
git clone https://github.com/<user>/my-skills.git ~/my-skills

# lm-skills 在这里：
cd ~/my-skills/原创skills/lm-skills
```

install.sh 使用 `$SCRIPT_DIR` 定位自身所在目录，所以它在 `my-skills/原创skills/lm-skills/` 下同样能正确找到同目录的 `lm-*/` 子目录。

### 两种安装范围

| 范围 | 安装位置 | 哪些项目能用 |
|------|---------|------------|
| **全局** | `~/.claude/skills/lm-*/` | 本机所有项目 |
| **项目级** | `<项目>/.claude/skills/lm-*/` | 仅该项目 |

### 执行安装

```bash
# 先 cd 到 lm-skills 目录
cd ~/my-skills/原创skills/lm-skills

# 全局安装
./install.sh

# 项目级安装（先 cd 到目标项目根目录）
cd /path/to/your-project
~/my-skills/原创skills/lm-skills/install.sh --project

# 或指定目标目录
./install.sh --target /path/to/your-project/.claude/skills

# Symlink 模式（git pull 自动更新，Windows 需管理员/开发者模式）
./install.sh --symlink
```

安装后目录变化：
```
~/.claude/skills/  或  <项目>/.claude/skills/
├── lm-shared/
├── lm-backup/
├── lm-clarify/
├── lm-solution/
├── lm-prd/
└── lm-review/
```

### Windows (PowerShell)

```powershell
git clone https://github.com/<user>/my-skills.git $env:USERPROFILE\my-skills
cd $env:USERPROFILE\my-skills\原创skills\lm-skills

# 全局安装
.\install.ps1

# 项目级安装
cd D:\Jimmy\ai_docs\my-project
$env:USERPROFILE\my-skills\原创skills\lm-skills\install.ps1 -Project

# Symlink 模式
.\install.ps1 -Symlink
```

---

## 更新

核心原理：`my-skills` 仓库是源，install.sh 所在目录是安装源。更新 = 拉取仓库 → 重装到目标。

```bash
# 1. 拉取最新
cd ~/my-skills && git pull

# 2. 重装到目标
cd ~/my-skills/原创skills/lm-skills

# 全局
./install.sh --update

# 项目级（当前在项目目录下）
./install.sh --update --project

# 项目级（指定目录）
./install.sh --update --target /path/to/your-project/.claude/skills
```

Symlink 模式更简单：`git pull` 即生效，因为目标目录存的是快捷方式直指源文件。

```
你的 my-skills 仓库                        安装目标
──────────────────────                    ──────────
~/my-skills/                             ~/.claude/skills/  （全局）
└── 原创skills/                           ├── lm-shared/  ←──┐
    └── lm-skills/                        ├── lm-backup/     │
        ├── lm-shared/  ← git pull ──→   ├── lm-clarify/    │ ./install.sh
        ├── lm-backup/                    ├── lm-solution/   │ 从此目录
        ├── lm-clarify/                   ├── lm-prd/        │ 复制过去
        ├── lm-solution/                  └── lm-review/    ←┘
        ├── lm-prd/
        ├── lm-review/
        └── install.sh
```

---

## 卸载

```bash
# 全局卸载
rm -rf ~/.claude/skills/lm-{shared,backup,clarify,solution,prd,review}

# 项目级卸载（在项目根目录执行）
rm -rf .claude/skills/lm-{shared,backup,clarify,solution,prd,review}
```

---

## 前置依赖

- Claude Code CLI
- `lm-backup` 需求目录默认：`D:/Jimmy/ai_docs/linkmed-spec/1-产品需求/<YYYY-MM-DD 需求简述>/`
- `lm-prd` 需要 `frontend-design` skill（可选，无则手写原型）

---

## FAQ

**Q: 为什么不直接 clone lm-skills，而要 clone 整个 my-skills？**
A: my-skills 是你的个人技能集仓库，lm-skills 是其中一个子套件。一个大仓库管理所有技能更方便。install.sh 用 `$SCRIPT_DIR` 自定位，放在任何路径都能正常工作。

**Q: 能不能只下载 lm-skills 不 clone 整个仓库？**
A: 可以，install.sh 不依赖 git。把 `原创skills/lm-skills/` 目录复制到任意位置，直接运行 install.sh 即可。

**Q: 克隆 my-skills 到哪比较好？**
A: 推荐 `~/my-skills/`。install.sh 不依赖绝对路径，只要不动它就行。

**Q: 能把 `.claude/skills/` 纳入 git 吗？**
A: 项目级安装后可以。团队成员 clone 项目即获得技能，无需各自安装。

## 目录结构

```
my-skills/                        ← GitHub 仓库根目录
└── 原创skills/
    └── lm-skills/                ← 本目录
        ├── README.md
        ├── install.sh
        ├── install.ps1
        ├── lm-shared/
        ├── lm-backup/
        ├── lm-clarify/
        ├── lm-solution/
        ├── lm-prd/
        └── lm-review/
```

## License

MIT
