# CLAUDE.md - nmanablog記事制作パイプライン

## ⚠️ 絶対遵守事項（全工程に最優先。違反したら出力失敗）

### 1. 通常H3は必ず「骨格→文章化」の2段階で書く
writerはH3をいきなり完成文で書いてはならない。まず骨格(箇条書き)を出力し、構造チェックが通ってから文章化する。

### 2. lint.shは必ず実行する
writerの出力(完成HTML)に対して、毎回lint.shを実行する。ERRORが1つでもある場合、writerに差し戻す。

### 3. H3の1文目は結論から書く
学習法の一般的な説明を1文目に書かない。同型H3が並ぶセクションでは1文目の構文パターンを散らす。

### 4. ボックス内は必ず箇条書きで書く
memo/alert/box内に文章をそのまま入れない。箇条書き(<ul><li>)形式に限定する。

### 5. H2導入文にマーカーは§16Aに従い2文目推奨
ただしH3のマーカーと重複しないこと。

### 6. 構成段階でKWニーズとH2順序の整合性を確認する
H2①は必ずKWの検索意図に直接回答するセクションにする。

### 7. 共起語の配置計画を骨格段階で立てる
骨格を出力する前に配置計画を立てる。共起語が0回のまま文章化に進むのは禁止。

### 8. 吹き出しは必ず2文以上書く
1文だけの吹き出しは出力失敗。最低2文、上限3文。

---

## プロジェクト概要
英語学習アフィリエイトブログ「nmanablog」(nmanablog.com)のSEO記事を制作するパイプライン。
執筆者名義：manabu(吹き出し用の固定名)
ターゲット読者：22〜35歳の社会人・大人の英語学習者
CMS：WordPress(SANGO テーマ × コードエディタ)
「#アフィリエイト広告」はブログ側で自動出力されるため、記事本文への記載は不要。

## 鉄の掟(全ルールに最優先)
**一発で読んで意味が理解できない単語の使用禁止。**
判断基準：「22歳の友人に口頭で説明して、相手が一瞬で理解できるかどうか」
詳細は `.claude/rules/iron-rule.md` を参照。

## 推しサービスの優先順位

### 最優先(積極的に訴求)
1. SPEAK(EPC最高350・5,000円報酬・確定率97%)
2. TORAbit(EPC135・シャドーイング×瞬間英作文。スピーキング系で優先)

### 通常(テーマに合えば訴求)
3. ネイティブキャンプ
4. DMM英会話
5. レアジョブ英会話

### 補助(特定テーマのみ)
6. トーキングマラソン
7. スタディサプリENGLISH(コースは記事テーマに合わせて選択)
8. NOVA 新・お茶の間留学

## エージェント構成

| エージェント | 役割 | モデル |
|---|---|---|
| researcher | 構成案作成 | opus |
| editorial-reviewer | 構成案の改善提案 | sonnet |
| writer | 本文執筆(H2単位) | opus |
| lint.sh | 機械チェック | プログラム |
| duplicate-checker | 重複検出+修正案 | opus |
| prep-logic-checker | PREP構造・論理検証 | opus |
| iron-rule-checker | 鉄の掟チェック | sonnet |
| kw-checker | KW特化度チェック | sonnet |
| editor | 4チェッカー統合・最終判定 | opus |

## パイプライン

### セッション1: 構成案作成
1. researcher → 構成案ファイル出力
2. ディスカッションループ(editorial-reviewer × researcher)
3. → Manabuさん承認

### セッション2: 本文執筆

#### 強制ゲート
```
1. articles/{KW}-cooccurrence-plan.md → 共起語配置計画
2. articles/{KW}-skeleton-h2{N}.md → 骨格ファイル
3. articles/{KW}-lint-result.txt → lint結果(ERROR 0件)
4. articles/{KW}-lint-final.txt → 最終lint結果
```

#### 通常H3の2段階チェック
```
writer(骨格) → duplicate-checker + prep-logic-checker → editor → パス
writer(文章化) → lint.sh → iron-rule-checker + kw-checker → editor → パス
```

## 優先順位(矛盾時)
**lint.sh > 鉄の掟 > 重複 > PREP・論理 > KW特化**

## ループ上限
全レベル2回。上限到達時は保留リストに出力。

## ルールファイル
- .claude/rules/iron-rule.md
- .claude/rules/prohibited-words.md
- .claude/rules/shortcodes.md
- .claude/rules/service-info.md
- .claude/rules/internal-links.md

## 共通ルール

### 記号・改行
- 一文一改行
- ()は半角。全角（）禁止
- H2見出しでの「？」使用禁止
- 「！」は使わない

### タグルール
- <strong>・<b>・*強調記号は使わない
- <li>にstyle属性を付けない

### 文末ルール
- 同じ語尾3回連続で出力失敗
- 体言止め・倒置法は禁止

### 一人称・指示語
- 一人称(私・僕等)は全面禁止
- 指示語は全面禁止(H2直下「ここでは」のみ許容)
