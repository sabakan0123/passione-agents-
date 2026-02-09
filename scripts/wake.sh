#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# wake - スタンバイ中のメンバーを叩き起こす
# 使い方: wake <メンバー> "任務内容"
#        wake <メンバー1> <メンバー2> "任務内容"
# ═══════════════════════════════════════════════════════════════════════════

PASSIONE_DIR="/tmp/passione"

# メンバー名の正規化
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
        trish|トリッシュ|品質保証|qa)
            echo "trish" ;;
        *)
            echo "" ;;
    esac
}

# メンバー表示名
get_display_name() {
    case "$1" in
        fugo)      echo "フーゴ（設計）" ;;
        giorno)    echo "ジョルノ（実装）" ;;
        abbacchio) echo "アバッキオ（検証）" ;;
        mista)     echo "ミスタ（監視）" ;;
        narancia)  echo "ナランチャ（調査）" ;;
        trish)     echo "トリッシュ（品質保証）" ;;
    esac
}

# ヘルプ
if [[ -z "$1" ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    cat << 'EOF'
═══════════════════════════════════════════════════════════════════════════
  wake - スタンバイ中のメンバーを叩き起こす
═══════════════════════════════════════════════════════════════════════════

使い方:
  wake <メンバー> "任務内容"
  wake <メンバー1> <メンバー2> "任務内容"

例:
  wake abbacchio "コードレビューしろ"
  wake fugo giorno "認証機能を設計・実装しろ"
  wake all "全員起きろ、プロジェクトを進めるぞ"

メンバー:
  fugo, giorno, abbacchio, mista, narancia, trish, all
═══════════════════════════════════════════════════════════════════════════
EOF
    exit 0
fi

# 空きスロットを探す（1 or 2）
find_free_slot() {
    for slot in 1 2; do
        if [[ ! -f "$PASSIONE_DIR/slot${slot}.member" ]]; then
            echo "$slot"
            return 0
        fi
    done
    echo ""
    return 1
}

# パッショーネが起動しているか確認
if [[ ! -d "$PASSIONE_DIR" ]]; then
    echo "❌ パッショーネが起動していない"
    echo "   先に実行: passione-hub start"
    exit 1
fi

# 引数を解析
MEMBERS=()
MISSION=""

for arg in "$@"; do
    normalized=$(normalize_member "$arg")
    if [[ -n "$normalized" ]]; then
        MEMBERS+=("$normalized")
    elif [[ "$arg" == "all" ]] || [[ "$arg" == "全員" ]]; then
        MEMBERS=("fugo" "giorno" "abbacchio" "mista" "narancia" "trish")
    else
        # 最後の引数が任務内容
        MISSION="$arg"
    fi
done

if [[ -z "$MISSION" ]]; then
    echo "❌ 任務内容を指定してくれ"
    echo "   使い方: wake <メンバー> \"任務内容\""
    exit 1
fi

if [[ ${#MEMBERS[@]} -eq 0 ]]; then
    echo "❌ メンバーを指定してくれ"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo "  ⚡ メンバー起床"
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""
echo "  📋 任務: $MISSION"
echo ""

for member in "${MEMBERS[@]}"; do
    display_name=$(get_display_name "$member")

    # 空きスロットを探す
    slot=$(find_free_slot)

    if [[ -z "$slot" ]]; then
        echo "  ❌ $display_name - 空きスロットなし（2枠とも使用中）"
        echo "     現在のタスクが完了するまで待ってくれ"
        continue
    fi

    # スロットにメンバーを割り当て
    echo "$member" > "$PASSIONE_DIR/slot${slot}.member"
    echo "$MISSION" > "$PASSIONE_DIR/slot${slot}.mission"

    echo "  ⚡ $display_name - スロット${slot}に配置！任務を送信"
done

echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo "  ✅ 起床完了。各ペインで作業が始まる"
echo "═══════════════════════════════════════════════════════════════════════════"
