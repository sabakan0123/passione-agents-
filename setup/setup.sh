#!/bin/bash

# Passione-Agents セットアップスクリプト
# MIT License

set -e

echo "========================================="
echo "  Passione-Agents セットアップ開始"
echo "========================================="
echo ""

# 色付きメッセージ
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Claude Codeインストール確認
echo "1. Claude Codeインストール確認中..."
if ! command -v claude &> /dev/null; then
    echo -e "${RED}[ERROR] Claude Codeがインストールされていません${NC}"
    echo "以下のURLからインストールしてください："
    echo "https://claude.ai/claude-code"
    exit 1
fi
echo -e "${GREEN}✓ Claude Code インストール確認完了${NC}"
echo ""

# ~/.claude/agents/ ディレクトリ作成
echo "2. エージェントディレクトリ作成中..."
AGENT_DIR="$HOME/.claude/agents"
if [ ! -d "$AGENT_DIR" ]; then
    mkdir -p "$AGENT_DIR"
    echo -e "${GREEN}✓ ディレクトリ作成: $AGENT_DIR${NC}"
else
    echo -e "${YELLOW}! ディレクトリは既に存在します: $AGENT_DIR${NC}"
fi
echo ""

# agents/*.md を ~/.claude/agents/ にコピー
echo "3. エージェントファイルをコピー中..."

# スクリプトのディレクトリを取得
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
SOURCE_DIR="$PROJECT_ROOT/agents"

if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}[ERROR] エージェントディレクトリが見つかりません: $SOURCE_DIR${NC}"
    exit 1
fi

# エージェントファイルをコピー
for agent_file in "$SOURCE_DIR"/*.md; do
    if [ -f "$agent_file" ]; then
        filename=$(basename "$agent_file")
        cp "$agent_file" "$AGENT_DIR/$filename"
        echo -e "${GREEN}✓ コピー完了: $filename${NC}"
    fi
done
echo ""

# セットアップ検証
echo "4. セットアップ検証中..."
AGENTS=("bucciarati.md" "fugo.md" "giorno.md" "abbacchio.md" "mista.md" "narancia.md")
ALL_FOUND=true

for agent in "${AGENTS[@]}"; do
    if [ -f "$AGENT_DIR/$agent" ]; then
        echo -e "${GREEN}✓ $agent${NC}"
    else
        echo -e "${RED}✗ $agent が見つかりません${NC}"
        ALL_FOUND=false
    fi
done
echo ""

# 完了メッセージ
if [ "$ALL_FOUND" = true ]; then
    echo "========================================="
    echo -e "${GREEN}  セットアップ完了！${NC}"
    echo "========================================="
    echo ""
    echo "次のステップ："
    echo "1. Claude Codeを起動"
    echo "2. 以下のコマンドでエージェントを呼び出す："
    echo ""
    echo "   /bucciarati    # Orchestrator（統括）"
    echo "   /fugo          # Planner（設計）"
    echo "   /giorno        # Developer（実装）"
    echo "   /abbacchio     # Reviewer（検証）"
    echo "   /narancia      # Researcher（調査）"
    echo "   /mista         # Monitor（監視）"
    echo ""
    echo "3. 使い方はREADME.mdを参照"
    echo ""
    echo "「覚悟」を持って、プロジェクトを始めよう！"
else
    echo "========================================="
    echo -e "${RED}  セットアップに問題がありました${NC}"
    echo "========================================="
    echo ""
    echo "不足しているファイルを確認し、再度実行してください。"
    exit 1
fi
