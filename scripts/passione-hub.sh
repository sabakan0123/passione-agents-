#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# passione-hub - パッショーネ司令部（全員スタンバイ & 叩き起こし）
# ═══════════════════════════════════════════════════════════════════════════

PASSIONE_DIR="/tmp/passione"
AGENTS_DIR="$HOME/.claude/agents"

# ディレクトリ初期化
init_passione() {
    mkdir -p "$PASSIONE_DIR"
    for member in fugo giorno abbacchio mista narancia trish; do
        echo "sleep" > "$PASSIONE_DIR/${member}.status"
        rm -f "$PASSIONE_DIR/${member}.mission"
    done
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

# スリープ中の表示
show_sleep_animation() {
    local member=$1
    local display_name=$(get_display_name "$member")
    local frames=("💤" "😴" "💤" "🛏️")
    local i=0

    while [[ $(cat "$PASSIONE_DIR/${member}.status" 2>/dev/null) == "sleep" ]]; do
        printf "\r  ${frames[$i]} $display_name - スタンバイ中... 任務を待っている"
        i=$(( (i + 1) % 4 ))
        sleep 0.5
    done
    echo ""
}

# メンバーのメインループ（各ペインで実行）
member_loop() {
    local member=$1
    local display_name=$(get_display_name "$member")
    local project_dir=$2

    cd "$project_dir"

    while true; do
        clear
        echo ""
        echo "═══════════════════════════════════════════════════════════════════════════"
        echo "  🎭 $display_name"
        echo "═══════════════════════════════════════════════════════════════════════════"
        echo ""

        # スリープ状態で待機
        echo "  💤 スタンバイ中... ブチャラティからの指令を待っている"
        echo ""
        echo "  [起こし方] 別ターミナルで: wake $member \"任務内容\""
        echo ""
        echo "───────────────────────────────────────────────────────────────────────────"

        # ミッションファイルが来るまで待機
        while [[ ! -f "$PASSIONE_DIR/${member}.mission" ]]; do
            sleep 1
        done

        # ミッションを読み取り
        MISSION=$(cat "$PASSIONE_DIR/${member}.mission")
        rm -f "$PASSIONE_DIR/${member}.mission"

        echo ""
        echo "  ⚡ 起床！任務を受領した"
        echo ""
        echo "  📋 任務: $MISSION"
        echo ""
        echo "───────────────────────────────────────────────────────────────────────────"
        echo ""

        # エージェントプロンプトを読み込む
        AGENT_PROMPT=$(cat "$AGENTS_DIR/${member}.md")

        # Claude を自律モードで起動（git操作はブチャラティのみ許可）
        claude --permission-mode dontAsk \
            --allowedTools "Read,Edit,Write,Glob,Grep,Bash,WebSearch,WebFetch,Task,NotebookEdit" \
            --disallowedTools "Bash(git *)" \
            --append-system-prompt "$(cat << AGENT_EOF
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

        echo ""
        echo "───────────────────────────────────────────────────────────────────────────"
        echo "  ✅ 任務完了。再びスタンバイ状態に戻る..."
        echo "───────────────────────────────────────────────────────────────────────────"
        sleep 3
    done
}

# ヘルプ
show_help() {
    cat << 'EOF'
═══════════════════════════════════════════════════════════════════════════
  passione-hub - パッショーネ司令部
═══════════════════════════════════════════════════════════════════════════

コマンド:
  passione-hub start     3ペイン構成で起動（ブチャラティ + ワーカー×2）
  passione-hub stop      全員を解散
  passione-hub status    各メンバーの状態を表示

メンバーを起こす:
  wake <メンバー> "任務内容"

例:
  passione-hub start
  wake abbacchio "Zod導入のコードレビュー"
  wake giorno "ログイン機能を実装しろ"
  wake fugo narancia "認証機能を調査・設計しろ"
═══════════════════════════════════════════════════════════════════════════
EOF
}

# ターミナル検出：WezTerm or Windows Terminal
detect_terminal() {
    if command -v wezterm.exe &>/dev/null; then
        echo "wezterm"
    elif command -v wt.exe &>/dev/null; then
        echo "wt"
    else
        echo "none"
    fi
}

# ペイン分割の実行
split_pane() {
    local script_path=$1
    local project_dir=$2
    local terminal=$(detect_terminal)

    case "$terminal" in
        wezterm)
            wezterm.exe cli split-pane --right --percent 50 --cwd "$project_dir" -- wsl.exe bash "$script_path" &
            ;;
        wt)
            wt.exe -w 0 sp -V -s 0.5 -d "$project_dir" -- wsl.exe bash "$script_path" &
            ;;
        *)
            echo "  ❌ 対応ターミナルが見つからない（WezTerm or Windows Terminal が必要）"
            return 1
            ;;
    esac
}

# 3ペイン構成で起動（ブチャラティ + ワーカー×2）
start_all() {
    local project_dir=$(pwd)
    local terminal=$(detect_terminal)

    mkdir -p "$PASSIONE_DIR"
    rm -f "$PASSIONE_DIR"/slot*.member "$PASSIONE_DIR"/slot*.mission

    echo ""
    echo "═══════════════════════════════════════════════════════════════════════════"
    echo "  🏛️  パッショーネ司令部 起動（3ペイン構成）"
    echo "═══════════════════════════════════════════════════════════════════════════"
    echo ""
    echo "  📍 プロジェクト: $project_dir"
    echo "  🖥️  ターミナル: $terminal"
    echo ""
    echo "───────────────────────────────────────────────────────────────────────────"

    if [[ "$terminal" == "none" ]]; then
        echo "  ❌ WezTerm も Windows Terminal も見つからない"
        echo "     どちらかをインストールしてくれ"
        return 1
    fi

    # ワーカースロット1
    echo "  📣 ワーカースロット1 を配置..."
    LAUNCH_SCRIPT_1="/tmp/passione_slot1_launch.sh"
    cat > "$LAUNCH_SCRIPT_1" << SCRIPT_EOF
#!/bin/bash
source ~/.bashrc 2>/dev/null
export PASSIONE_DIR="$PASSIONE_DIR"
export AGENTS_DIR="$AGENTS_DIR"
$(declare -f get_display_name)
$(declare -f slot_loop)
slot_loop 1 "$project_dir"
SCRIPT_EOF
    chmod +x "$LAUNCH_SCRIPT_1"
    split_pane "$LAUNCH_SCRIPT_1" "$project_dir"
    sleep 1

    # ワーカースロット2
    echo "  📣 ワーカースロット2 を配置..."
    LAUNCH_SCRIPT_2="/tmp/passione_slot2_launch.sh"
    cat > "$LAUNCH_SCRIPT_2" << SCRIPT_EOF
#!/bin/bash
source ~/.bashrc 2>/dev/null
export PASSIONE_DIR="$PASSIONE_DIR"
export AGENTS_DIR="$AGENTS_DIR"
$(declare -f get_display_name)
$(declare -f slot_loop)
slot_loop 2 "$project_dir"
SCRIPT_EOF
    chmod +x "$LAUNCH_SCRIPT_2"
    split_pane "$LAUNCH_SCRIPT_2" "$project_dir"
    sleep 1

    echo ""
    echo "═══════════════════════════════════════════════════════════════════════════"
    echo "  ✅ 3ペイン起動完了（$terminal 使用）"
    echo ""
    echo "  メンバーを起こすには:"
    echo "    wake <メンバー> \"任務内容\""
    echo ""
    echo "  例:"
    echo "    wake abbacchio \"コードレビューしろ\""
    echo "═══════════════════════════════════════════════════════════════════════════"
}

# 全員解散
stop_all() {
    echo "🛑 パッショーネ解散..."
    rm -rf "$PASSIONE_DIR"
    echo "✅ 完了"
}

# ステータス表示
show_status() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════════════════"
    echo "  📊 パッショーネ ステータス"
    echo "═══════════════════════════════════════════════════════════════════════════"
    echo ""
    for member in fugo giorno abbacchio mista narancia trish; do
        display_name=$(get_display_name "$member")
        if [[ -f "$PASSIONE_DIR/${member}.mission" ]]; then
            echo "  ⚡ $display_name - 作業中"
        elif [[ -f "$PASSIONE_DIR/${member}.status" ]]; then
            echo "  💤 $display_name - スタンバイ"
        else
            echo "  ❌ $display_name - 未起動"
        fi
    done
    echo ""
}

# 汎用ワーカースロットのループ（どのメンバーでも受け入れる）
slot_loop() {
    local slot=$1
    local project_dir=$2

    cd "$project_dir"

    while true; do
        clear
        echo ""
        echo "═══════════════════════════════════════════════════════════════════════════"
        echo "  🔲 ワーカースロット $slot"
        echo "═══════════════════════════════════════════════════════════════════════════"
        echo ""
        echo "  💤 待機中... ブチャラティからの指令を待っている"
        echo ""
        echo "  [起こし方] ブチャラティのペインで: wake <メンバー> \"任務内容\""
        echo ""
        echo "───────────────────────────────────────────────────────────────────────────"

        # スロットにミッションが来るまで待機
        while [[ ! -f "$PASSIONE_DIR/slot${slot}.mission" ]]; do
            sleep 1
        done

        # メンバー名とミッションを読み取り
        local member=$(cat "$PASSIONE_DIR/slot${slot}.member")
        local mission=$(cat "$PASSIONE_DIR/slot${slot}.mission")
        local display_name=$(get_display_name "$member")
        rm -f "$PASSIONE_DIR/slot${slot}.mission"

        echo ""
        echo "  ⚡ ${display_name} 起床！ スロット${slot}に着任"
        echo ""
        echo "  📋 任務: $mission"
        echo ""
        echo "───────────────────────────────────────────────────────────────────────────"
        echo ""

        # エージェントプロンプトを読み込む
        local agent_prompt=""
        if [[ -f "$AGENTS_DIR/${member}.md" ]]; then
            agent_prompt=$(cat "$AGENTS_DIR/${member}.md")
        fi

        # Claude を自律モードで起動（git操作はブチャラティのみ許可）
        claude --permission-mode dontAsk \
            --allowedTools "Read,Edit,Write,Glob,Grep,Bash,WebSearch,WebFetch,Task,NotebookEdit" \
            --disallowedTools "Bash(git *)" \
            --append-system-prompt "$(cat << AGENT_EOF
$agent_prompt

---

## 現在の任務

$mission

---

【重要】自律的に行動しろ。
1. 必要なファイルを自分で読め
2. 作業を完遂するまで止まるな
3. 完了したらMISSION.mdを更新しろ
4. 最後に完了報告を出力しろ
AGENT_EOF
)" "$mission"

        # スロットを解放
        rm -f "$PASSIONE_DIR/slot${slot}.member"

        echo ""
        echo "───────────────────────────────────────────────────────────────────────────"
        echo "  ✅ ${display_name} 任務完了。スロットを解放、スタンバイに戻る..."
        echo "───────────────────────────────────────────────────────────────────────────"
        sleep 3
    done
}

# メイン
case "${1:-}" in
    start)
        start_all
        ;;
    stop)
        stop_all
        ;;
    status)
        show_status
        ;;
    member-loop)
        # 内部用: 各ペインで実行される（旧方式、互換用）
        member_loop "$2" "$3"
        ;;
    slot-loop)
        # 内部用: 汎用ワーカースロット
        slot_loop "$2" "$3"
        ;;
    *)
        show_help
        ;;
esac
