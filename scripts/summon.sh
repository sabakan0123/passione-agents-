#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# summon - パッショーネメンバー呼び出しコマンド（Multi-Agent Mode）
# 使い方: summon <メンバー名> "任務内容"
#
# 新しいターミナルペインでエージェントが対話モードで起動する
# ═══════════════════════════════════════════════════════════════════════════

set -e

AGENTS_DIR="$HOME/.claude/agents"
MEMBER=$1
MISSION="${@:2}"

# メンバー名の正規化（日本語対応）
normalize_member() {
    case "$1" in
        fugo|フーゴ|設計|planner)
            echo "fugo" ;;
        giorno|ジョルノ|実装|developer)
            echo "giorno" ;;
        abbacchio|アバッキオ|検証|reviewer)
            echo "abbacchio" ;;
        mista|ミスタ|監視|monitor)
            echo "mista" ;;
        narancia|ナランチャ|調査|researcher)
            echo "narancia" ;;
        *)
            echo "" ;;
    esac
}

# メンバーの表示名を取得
get_display_name() {
    case "$1" in
        fugo)      echo "フーゴ（設計）" ;;
        giorno)    echo "ジョルノ（実装）" ;;
        abbacchio) echo "アバッキオ（検証）" ;;
        mista)     echo "ミスタ（監視）" ;;
        narancia)  echo "ナランチャ（調査）" ;;
    esac
}

# メンバーの口癖を表示
show_greeting() {
    case "$1" in
        fugo)
            echo "📐 計算上、最適な設計を導き出す..." ;;
        giorno)
            echo "🌟 無駄のない実装をする。それが僕の覚悟だ。" ;;
        abbacchio)
            echo "👁️ チッ...見てやるよ。信用はしねぇがな。" ;;
        mista)
            echo "🔫 おいおい、監視任務か。任せとけ！（4は使うなよ）" ;;
        narancia)
            echo "✈️ よっしゃー！調査なら俺に任せろ！" ;;
    esac
}

# ヘルプ表示
show_help() {
    cat << 'EOF'
═══════════════════════════════════════════════════════════════════════════
  summon - パッショーネメンバー呼び出しコマンド（Multi-Agent Mode）
═══════════════════════════════════════════════════════════════════════════

使い方:
  summon <メンバー> "任務内容"

メンバー一覧:
  fugo      (フーゴ)      設計・計画
  giorno    (ジョルノ)    実装・開発
  abbacchio (アバッキオ)  検証・レビュー
  mista     (ミスタ)      監視・進捗確認
  narancia  (ナランチャ)  調査・リサーチ

オプション:
  --here    新しいペインを開かず、現在のターミナルで起動

例:
  summon fugo "認証機能を設計しろ"
  summon abbacchio "PRをレビューしろ"
  summon giorno "ログイン画面を実装しろ" --here

日本語でもOK:
  summon フーゴ "設計を頼む"
  summon 設計 "APIの構造を考えろ"
═══════════════════════════════════════════════════════════════════════════
EOF
}

# 引数チェック
if [[ -z "$MEMBER" ]] || [[ "$MEMBER" == "-h" ]] || [[ "$MEMBER" == "--help" ]]; then
    show_help
    exit 0
fi

# --here オプションのチェック
RUN_HERE=false
for arg in "$@"; do
    if [[ "$arg" == "--here" ]]; then
        RUN_HERE=true
        # MISSIONから--hereを除去
        MISSION=$(echo "$MISSION" | sed 's/--here//g' | xargs)
    fi
done

# メンバー名を正規化
NORMALIZED=$(normalize_member "$MEMBER")

if [[ -z "$NORMALIZED" ]]; then
    echo "❌ 不明なメンバー: $MEMBER"
    echo ""
    echo "利用可能なメンバー:"
    echo "  fugo, giorno, abbacchio, mista, narancia"
    exit 1
fi

# エージェントファイルの確認
AGENT_FILE="$AGENTS_DIR/${NORMALIZED}.md"
if [[ ! -f "$AGENT_FILE" ]]; then
    echo "❌ エージェントファイルが見つからない: $AGENT_FILE"
    exit 1
fi

# 任務がない場合
if [[ -z "$MISSION" ]]; then
    echo "⚠️  任務内容を指定してくれ"
    echo "使い方: summon $MEMBER \"任務内容\""
    exit 1
fi

# 表示名と挨拶
DISPLAY_NAME=$(get_display_name "$NORMALIZED")

echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo "  📣 $DISPLAY_NAME を召喚"
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""
show_greeting "$NORMALIZED"
echo ""
echo "📋 任務: $MISSION"
echo ""
echo "───────────────────────────────────────────────────────────────────────────"

# エージェントプロンプトを読み込む
AGENT_PROMPT=$(cat "$AGENT_FILE")

# 現在のディレクトリ（プロジェクトルート）
PROJECT_DIR=$(pwd)

# 起動スクリプトを一時ファイルに作成
LAUNCH_SCRIPT=$(mktemp /tmp/summon_XXXXXX.sh)
cat > "$LAUNCH_SCRIPT" << SCRIPT_EOF
#!/bin/bash
cd "$PROJECT_DIR"
clear
echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo "  🎭 $DISPLAY_NAME - 任務開始"
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""
echo "📋 任務: $MISSION"
echo ""
echo "───────────────────────────────────────────────────────────────────────────"
echo ""

# Claude を自律モードで起動（許可不要、最後まで自動実行）
claude --dangerously-skip-permissions --append-system-prompt "\$(cat << 'AGENT_EOF'
$AGENT_PROMPT

---

## 現在の任務

$MISSION

---

【重要】自律的に行動しろ。
1. 必要なファイルを自分で読め
2. 作業を完遂するまで止まるな
3. 完了したらMISSION.mdを更新しろ
4. 最後に完了報告を出力しろ
AGENT_EOF
)" "$MISSION"

# 終了後
echo ""
echo "───────────────────────────────────────────────────────────────────────────"
echo "  ✅ $DISPLAY_NAME の任務完了"
echo "───────────────────────────────────────────────────────────────────────────"
read -p "Press Enter to close..."
SCRIPT_EOF

chmod +x "$LAUNCH_SCRIPT"

if [[ "$RUN_HERE" == "true" ]]; then
    # 現在のターミナルで実行
    echo ""
    echo "🚀 現在のターミナルで起動..."
    bash "$LAUNCH_SCRIPT"
    rm -f "$LAUNCH_SCRIPT"
else
    # 新しいペインで起動（Windows Terminal）
    echo ""
    echo "🚀 新しいペインで起動中..."

    # Windows Terminal で新しいペインを開く
    # wt.exe -w 0 sp -d . -- wsl.exe bash "$LAUNCH_SCRIPT"
    wt.exe -w 0 sp -V -d "$PROJECT_DIR" -- wsl.exe bash "$LAUNCH_SCRIPT"

    echo ""
    echo "✅ $DISPLAY_NAME を新しいペインで起動した"
    echo "   右側のペインで作業風景を確認できる"
    echo ""

    # 一時ファイルは新しいペインで使うので、ここでは削除しない
    # 新しいペインの終了時に削除されるようにスクリプト内で処理
fi
