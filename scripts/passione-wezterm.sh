#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# passione-wezterm - WezTermでパッショーネを起動（3ペイン構成）
# ═══════════════════════════════════════════════════════════════════════════
#
# ┌──────────────────┬──────────────────┬──────────────────┐
# │   ブチャラティ    │   ワーカー枠1    │   ワーカー枠2    │
# │   (指揮・claude)  │  💤 待機中       │  💤 待機中       │
# └──────────────────┴──────────────────┴──────────────────┘

PROJECT_DIR="/mnt/c/Users/Asus/OneDrive/novelworks/REQXIGN"
PASSIONE_DIR="/tmp/passione"
SCRIPTS_DIR="$HOME/.claude/scripts"

# パッショーネディレクトリ初期化
mkdir -p "$PASSIONE_DIR"
rm -f "$PASSIONE_DIR"/slot*.member "$PASSIONE_DIR"/slot*.mission

echo "🏛️ パッショーネ司令部 起動中...（3ペイン構成）"

# ブチャラティ（左ペイン）- WezTermを起動
wezterm.exe start --cwd "$PROJECT_DIR" -- wsl.exe bash -c "
cd $PROJECT_DIR
clear
echo ''
echo '═══════════════════════════════════════════════════════════════════════════'
echo '  🎭 ブチャラティ（指揮） - メインターミナル'
echo '═══════════════════════════════════════════════════════════════════════════'
echo ''
echo '  パッショーネ司令部へようこそ。'
echo ''
echo '  📋 メンバーを起こすには: wake <メンバー> \"任務内容\"'
echo '  ⌨️  ショートカット: Ctrl+Shift+W でメンバー起床ダイアログ'
echo ''
echo '───────────────────────────────────────────────────────────────────────────'
echo ''
claude
" &

sleep 2

# ワーカースロット1（中央ペイン）
wezterm.exe cli split-pane --right --percent 66 --cwd "$PROJECT_DIR" -- wsl.exe bash "$SCRIPTS_DIR/passione-hub.sh" slot-loop 1 "$PROJECT_DIR"
sleep 0.5

# ワーカースロット2（右ペイン）
wezterm.exe cli split-pane --right --percent 50 --cwd "$PROJECT_DIR" -- wsl.exe bash "$SCRIPTS_DIR/passione-hub.sh" slot-loop 2 "$PROJECT_DIR"

echo "✅ パッショーネ起動完了（3ペイン）"
