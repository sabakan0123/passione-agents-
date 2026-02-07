# サンプルプロジェクト: Kaggle タイタニックコンペ

このディレクトリは、Passione-Agentsを使った実際のプロジェクト例です。

## プロジェクト概要

Kaggleの「Titanic - Machine Learning from Disaster」コンペティションで、
上位10%（スコア0.80以上）を達成する機械学習モデルを構築します。

**結果**: Public Score 0.81（上位8%）を達成

## ワークフロー

### 1. ボスからの指示
```
「Kaggleのタイタニックコンペで上位10%を目指すプロジェクトを作ってくれ」
```

### 2. ブチャラティ（Orchestrator）
```
「了解した。まずフーゴに設計させる」
```

### 3. フーゴ（Planner）
- タスクを分解: データ準備 → EDA → 特徴量 → モデリング → 提出
- アーキテクチャを設計: ディレクトリ構造、技術スタック選定
- MISSION.mdに設計書を記載

### 4. ジョルノ（Developer）
- フーゴの設計に従って実装
- notebooks/でEDA、特徴量エンジニアリング、モデリング
- src/に再利用可能な関数を作成
- MISSION.mdに進捗を記録

### 5. アバッキオ（Reviewer）
- コード品質をレビュー
- モデル評価結果を検証
- 改善提案を記載

### 6. ナランチャ（Researcher）
- Kaggle Notebooksで上位入賞者の手法を調査
- 論文や技術記事を検索
- MISSION.mdに調査結果を記載

### 7. 最終報告
```
ブチャラティ「ボス、任務完了だ。目標の上位10%を達成した」
```

## ディレクトリ構成

```
01-kaggle-competition/
├── data/                  # データセット
│   ├── train.csv
│   └── test.csv
├── notebooks/             # Jupyter Notebook
│   ├── 01_eda.ipynb
│   ├── 02_feature.ipynb
│   └── 03_modeling.ipynb
├── src/                   # ソースコード
│   ├── preprocess.py
│   ├── features.py
│   └── models.py
├── results/               # 提出ファイル
│   └── submission.csv
├── MISSION.md             # 進捗管理
└── README.md              # このファイル
```

## 学べること

このサンプルから、以下を学べます：

1. **MISSION.mdの使い方**: プロジェクト全体の進捗を一元管理
2. **エージェント間の連携**: 設計→実装→検証の流れ
3. **段階的な実装**: Phase分けで進める方法
4. **レビューの重要性**: アバッキオによる品質チェック
5. **調査の活用**: ナランチャが外部情報を収集

## 実際に試すには

1. このディレクトリをテンプレートとして使う
2. MISSION.mdを自分のプロジェクトに合わせて書き換える
3. Claude Codeで `/bucciarati` を起動
4. 「このMISSION.mdに従ってプロジェクトを進めてくれ」と指示

---

「この経験が、お前の『黄金体験』になる」
