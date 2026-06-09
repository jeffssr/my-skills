#!/usr/bin/env bash
set -euo pipefail

# lm-skills install script
# Usage:
#   ./install.sh                        # 全局安装（复制）
#   ./install.sh --project              # 项目级安装（复制到当前目录下的 .claude/skills/）
#   ./install.sh --symlink              # 全局 + symlink 模式
#   ./install.sh --update               # 更新：git pull + 重装（沿用上次模式）
#   ./install.sh --update --project     # 更新项目级安装
#   ./install.sh --target <dir>         # 装到指定目录

MODE="global"
SYMLINK=false
TARGET=""
UPDATE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) MODE="project" ;;
    --global)  MODE="global" ;;
    --symlink) SYMLINK=true ;;
    --target)  TARGET="$2"; shift ;;
    --update)  UPDATE=true ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ---- Update: git pull first ----
if [[ "$UPDATE" == true ]]; then
  echo "==> Updating lm-skills repo..."
  cd "$SCRIPT_DIR"
  git pull --ff-only origin main 2>/dev/null || git pull --ff-only origin master 2>/dev/null || {
    echo "[WARN] git pull failed — continuing with local version"
  }
  echo ""
fi

# ---- Determine target directory ----
if [[ -n "$TARGET" ]]; then
  SKILLS_DIR="$TARGET"
elif [[ "$MODE" == "project" ]]; then
  SKILLS_DIR="$(pwd)/.claude/skills"
else
  SKILLS_DIR="${HOME}/.claude/skills"
fi

echo "==> lm-skills installer"
echo "    Repo:      $SCRIPT_DIR"
echo "    Mode:      $MODE"
echo "    Symlink:   $SYMLINK"
echo "    Target:    $SKILLS_DIR"
echo ""

mkdir -p "$SKILLS_DIR"

SKILLS=(lm-shared lm-backup lm-clarify lm-solution lm-prd lm-review)

for skill in "${SKILLS[@]}"; do
  SRC="$SCRIPT_DIR/$skill"
  DST="$SKILLS_DIR/$skill"

  if [[ ! -d "$SRC" ]]; then
    echo "[WARN] $SRC not found, skipping"
    continue
  fi

  if [[ "$SYMLINK" == true ]]; then
    rm -rf "$DST" 2>/dev/null || true
    ln -s "$SRC" "$DST"
    echo "[OK] $skill -> symlinked"
  else
    rm -rf "$DST" 2>/dev/null || true
    cp -r "$SRC" "$DST"
    echo "[OK] $skill -> copied"
  fi
done

echo ""
echo "Done! lm-skills installed to $SKILLS_DIR"
echo "Restart Claude Code or start a new conversation to use."
