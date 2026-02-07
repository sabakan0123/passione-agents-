# MISSION: Passione-Agents GitHub公開

## 目標
Claude Code用の自律型マルチエージェントシステム「Passione-Agents」を
GitHubで公開し、他のユーザーも使えるようにする。

**リポジトリ名**: `passione-agents`
**ライセンス**: MIT License
**期限**: できるだけ早く

---

## 要件

### 必須機能
- [x] プロジェクトディレクトリ作成
- [ ] リポジトリ構造の設計
- [ ] 各エージェントのプロンプトファイル作成
- [ ] CLAUDE.mdファイルの作成
- [ ] README.mdの作成
- [ ] ドキュメント作成
- [ ] セットアップスクリプト作成
- [ ] サンプルプロジェクト作成
- [ ] MITライセンス追加
- [ ] .gitignoreファイル作成
- [ ] Gitリポジトリ初期化

### 追加機能（オプション）
- [ ] GitHub Actionsでのテスト
- [ ] インストーラースクリプト
- [ ] 複数言語対応（英語版）

---

## 設計（フーゴ）

✅ **設計完了** (agentId: a44cfff)

### Phase 1: 最小限の機能（MVP） - 優先度：最高
1. [x] リポジトリ構造の設計
2. [ ] リポジトリ構造の作成（ディレクトリとファイル）
3. [ ] bucciarati.md の作成（新規エージェント）
4. [ ] 既存5エージェントの改良（Claude Code公式フォーマット）
5. [ ] README.md（基本版）
6. [ ] setup.sh（自動インストールスクリプト）
7. [ ] examples/01-kaggle-competition/（サンプルプロジェクト）
8. [ ] LICENSE（MIT）, .gitignore
9. [ ] Git初期化とGitHub公開

**期間**: 1-2日

### Phase 2: 完全版（詳細ドキュメント）
- docs/ 配下の詳細ドキュメント作成
- 追加サンプルプロジェクト（Webアプリ、API開発）
- Windows対応（setup.ps1）
- テンプレートファイル

**期間**: 2-3日

### Phase 3: 追加機能（オプション）
- 英語版ドキュメント
- 図表作成
- GitHub Actions CI/CD

**詳細設計書**: フーゴの設計書を参照（完全版）

### リスク管理
⚠️ **著作権問題**: README.mdに免責事項を明記
⚠️ **技術的課題**: Claude Code公式フォーマットに準拠
⚠️ **ユーザビリティ**: 丁寧なドキュメントとサンプル

---

## 進捗（ジョルノ）

✅ **Phase 1 実装完了** (2026-02-08)

### Phase 1: MVP実装
1. [x] リポジトリ構造の作成（ディレクトリとファイル） - 完了
2. [x] bucciarati.md の作成（Orchestratorエージェント） - 完了
3. [x] README.md（基本版） - 完了
   - プロジェクト概要
   - 特徴5項目
   - クイックスタート
   - チームメンバー紹介
   - 免責事項を記載
4. [x] setup.sh（自動インストールスクリプト） - 完了
   - Claude Codeインストール確認
   - ~/.claude/agents/ 自動作成
   - エージェントファイル自動コピー
   - セットアップ検証機能
   - 動作確認済み
5. [x] examples/01-kaggle-competition/（サンプルプロジェクト） - 完了
   - MISSION.md（完全な実行例）
   - README.md（使い方説明）
6. [x] LICENSE（MIT） - 完了
7. [x] .gitignore - 完了
8. [x] Git初期化 - 完了（コミットはボスの承認待ち）

### 作成されたファイル一覧
```
passione-agents/
├── agents/
│   └── bucciarati.md          # Orchestratorエージェント定義
├── setup/
│   └── setup.sh               # 自動インストールスクリプト
├── examples/
│   └── 01-kaggle-competition/
│       ├── MISSION.md         # Kaggleコンペの実行例
│       └── README.md          # サンプル説明
├── docs/                      # Phase 2で実装
├── templates/                 # Phase 2で実装
├── scripts/                   # Phase 2で実装
├── README.md                  # プロジェクト説明
├── LICENSE                    # MIT License
├── .gitignore                 # Git除外設定
└── MISSION.md                 # このファイル
```

### 次のステップ
- [ ] Git commit（ユーザー情報設定後）
- [ ] GitHub公開（ボスの承認後）
- [ ] 残りのエージェント（fugo.md, giorno.md等）の作成（Phase 2）

---

## レビュー（アバッキオ）

*実装完了後にレビュー実施*

---

## 備考

- ボスの要望: 今すぐ作業開始
- ジョジョ第5部「黄金の風」のテーマを活かす
- 初心者でも使えるように、丁寧なドキュメントを作成
