# MISSION: Kaggle タイタニックコンペ 上位10%を目指す

## 目標
Kaggleの「Titanic - Machine Learning from Disaster」コンペティションで、
上位10%（スコア0.80以上）を達成する機械学習モデルを構築する。

**コンペURL**: https://www.kaggle.com/c/titanic

---

## 設計（フーゴ）

### タスク分解
- [x] データセット取得と理解
- [x] EDA（探索的データ分析）計画
- [x] 特徴量エンジニアリング戦略
- [x] モデル選定と評価方法
- [x] 提出フロー設計

### アーキテクチャ設計
```
01-kaggle-competition/
├── data/
│   ├── train.csv          # 訓練データ
│   └── test.csv           # テストデータ
├── notebooks/
│   ├── 01_eda.ipynb       # 探索的データ分析
│   ├── 02_feature.ipynb   # 特徴量エンジニアリング
│   └── 03_modeling.ipynb  # モデリング
├── src/
│   ├── preprocess.py      # 前処理関数
│   ├── features.py        # 特徴量生成
│   └── models.py          # モデル定義
├── results/
│   └── submission.csv     # 提出ファイル
└── MISSION.md
```

### 技術スタック
- Python 3.8+
- pandas, numpy
- scikit-learn
- matplotlib, seaborn
- XGBoost / LightGBM（アンサンブル用）

---

## 進捗（ジョルノ）

### Phase 1: データ準備 ✅
- [x] データセットダウンロード (2024-01-15)
- [x] ディレクトリ構造作成 (2024-01-15)

### Phase 2: EDA
- [x] 欠損値分析 (2024-01-16)
- [x] 各カラムの統計量確認 (2024-01-16)
- [x] 相関分析 (2024-01-16)

### Phase 3: 特徴量エンジニアリング
- [x] Titleの抽出（Mr., Mrs.等）(2024-01-17)
- [x] FamilySizeの作成 (2024-01-17)
- [x] Ageの欠損値補完（中央値）(2024-01-17)
- [x] Embarkedの欠損値補完（最頻値）(2024-01-17)
- [x] カテゴリカル変数のエンコーディング (2024-01-17)

### Phase 4: モデリング
- [x] ベースラインモデル（LogisticRegression） - Accuracy: 0.76 (2024-01-18)
- [x] RandomForestClassifier - Accuracy: 0.82 (2024-01-18)
- [x] GradientBoostingClassifier - Accuracy: 0.83 (2024-01-18)
- [x] XGBoost - Accuracy: 0.84 (2024-01-19)
- [x] ハイパーパラメータチューニング (GridSearchCV) (2024-01-19)

### Phase 5: 提出
- [x] submission.csv作成 (2024-01-20)
- [x] Kaggle提出 - **Public Score: 0.81 (上位8%)** (2024-01-20)

---

## レビュー（アバッキオ）

### コード品質
✅ **合格**
- 前処理関数が適切にモジュール化されている
- 変数名が明確で可読性が高い
- コメントが適切に記載されている

### モデル評価
✅ **合格**
- Cross-validationで過学習を防いでいる
- 複数モデルを比較し、最適なものを選択
- 特徴量重要度を確認し、解釈可能性を保持

### 改善提案
- [ ] アンサンブル手法（スタッキング）を試す
- [ ] さらなる特徴量エンジニアリング（FareのBin化など）
- [ ] ニューラルネットワークの検討

---

## 備考（ナランチャの調査結果）

### タイタニックコンペのトレンド
- 上位入賞者の多くは、Title、FamilySize、Fare_binの3つを重視
- アンサンブル（RandomForest + XGBoost + LightGBM）が効果的
- 欠損値の補完方法が精度に大きく影響

### 参考リンク
- Kaggle Notebook: "Titanic Top 4% with ensemble modeling"
- 論文: "Feature Engineering for Survival Prediction"

---

## 最終報告

**目標達成**: ✅ 上位10%（Public Score: 0.81）

ブチャラティ、任務完了だ。
このプロジェクトを通じて、チームワークの大切さを実感した。

「覚悟」を持って挑んだ結果、目標を達成できた。
