#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# passione-start - 現在のWezTermで一発パッショーネ起動
# 使い方: passione （または cc でエイリアス）
# ═══════════════════════════════════════════════════════════════════════════

PROJECT_DIR="/mnt/c/Users/Asus/OneDrive/novelworks/REQXIGN"
PASSIONE_DIR="/tmp/passione"
SCRIPTS_DIR="$HOME/.claude/scripts"

cd "$PROJECT_DIR"

# パッショーネディレクトリ初期化
mkdir -p "$PASSIONE_DIR"
for member in fugo giorno abbacchio mista narancia; do
    echo "sleep" > "$PASSIONE_DIR/${member}.status"
    rm -f "$PASSIONE_DIR/${member}.mission"
done

echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo "  🏛️  パッショーネ司令部 起動"
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""

# 右側にメンバーペインを縦に並べる
echo "  📣 メンバーをスタンバイ状態で配置中..."

# フーゴ（右上）
wezterm.exe cli split-pane --right --percent 30 --cwd "$PROJECT_DIR" -- wsl.exe bash "$SCRIPTS_DIR/passione-hub.sh" member-loop fugo "$PROJECT_DIR" &
sleep 0.5

# ジョルノ（フーゴの下）
wezterm.exe cli split-pane --bottom --percent 80 --cwd "$PROJECT_DIR" -- wsl.exe bash "$SCRIPTS_DIR/passione-hub.sh" member-loop giorno "$PROJECT_DIR" &
sleep 0.5

# アバッキオ（ジョルノの下）
wezterm.exe cli split-pane --bottom --percent 75 --cwd "$PROJECT_DIR" -- wsl.exe bash "$SCRIPTS_DIR/passione-hub.sh" member-loop abbacchio "$PROJECT_DIR" &
sleep 0.5

# ミスタ（アバッキオの下）
wezterm.exe cli split-pane --bottom --percent 66 --cwd "$PROJECT_DIR" -- wsl.exe bash "$SCRIPTS_DIR/passione-hub.sh" member-loop mista "$PROJECT_DIR" &
sleep 0.5

# ナランチャ（ミスタの下）
wezterm.exe cli split-pane --bottom --percent 50 --cwd "$PROJECT_DIR" -- wsl.exe bash "$SCRIPTS_DIR/passione-hub.sh" member-loop narancia "$PROJECT_DIR" &
sleep 0.5

echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo "  ✅ パッショーネ起動完了"
echo ""
echo "  🎭 ここはブチャラティ（指揮）のペイン"
echo ""
echo "  メンバーを起こすには:"
echo "    wake abbacchio \"コードレビューしろ\""
echo "    wake fugo giorno \"設計・実装しろ\""
echo "    wake all \"全員起きろ\""
echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""

# ブチャラティとしてClaude Codeを起動
claude
