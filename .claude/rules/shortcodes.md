# ショートコード・HTMLテンプレート集(nmanablog / SANGO)

## リード文テンプレート(タイトル直下・必須)
```
「#悩み」
「#悩み」
こんなお悩みはありませんか？

[say name="manabu" img="https://nmanablog.com/wp-content/uploads/2025/05/IMG_2356-scaled.jpeg"]結論、(#結論)です。
<br>
(#ワンポイントアドバイス)[/say]

この記事では(#記事内容)について詳しく解説します。
(#ユーザーメリット)内容です。

[box class="box28" title="この記事でわかること"]
<ul>
<li>(わかること1)</li>
<li>(わかること2)</li>
<li>(わかること3)</li>
<li>(わかること4)</li>
</ul>
[/box]
```

## 吹き出し
```
[say name="manabu" img="https://nmanablog.com/wp-content/uploads/2025/05/IMG_2356-scaled.jpeg"]一文目です。
<br>
二文目です。[/say]
```
右配置：`[say ... from="right"]テキスト[/say]`
改行は<br>タグ。最低2文、最大3文。

## マーカー(各H3に1本必須)
```
<span class="keiko_yellow">重要な文章</span>
```

## ボックスパーツ

### ポイント(黄色)
```
[memo title="(具体的なタイトル)"]
<ul><li>(要点1)</li><li>(要点2)</li></ul>
[/memo]
```

### 注意点(赤色)
```
[alert title="(具体的なタイトル)"]
<ul><li>(注意点1)</li><li>(注意点2)</li></ul>
[/alert]
```

### まとめ(緑色)
```
[box class="box28" title="(具体的なタイトル)"]
<ul><li>(要点1)</li><li>(要点2)</li></ul>
[/box]
```

### ステップ形式
```
[box class="box28" title="(タイトル)"]
<ol><li>手順1</li><li>手順2</li></ol>
[/box]
```

## ジャンプリンク(H3が2つ以上あるH2に必須)
```
[box class="box28" title="(H2内容に合わせた具体的タイトル)"]
<ul>
<li><a href="#1a">{H3見出しと完全一致}</a></li>
<li><a href="#2a">{H3見出しと完全一致}</a></li>
</ul>
[/box]
```
id命名：1a,2a,3a... → 次のH2は1b,2b,3b...
「この記事でわかること」はリード文のみ。

## テーブル
```
<table class="table1">
<colgroup><col style="width: 25%;"></colgroup>
<colgroup><col style="width: 75%;"></colgroup>
<thead><tr><th>項目</th><th>{タイトル}</th></tr></thead>
<tbody><tr><th>項目名</th><td>内容</td></tr></tbody>
</table>
```
class="table1"統一。セル内で「。」を多用しない。

## 見出し
- H2：`<h2></h2>`
- H3：`<h3 id="◯"></h3>`

## 内部リンク
```
[kanren id="2075"]
[kanren id="2075,2050,2169"]
```

## レビューボックス
```
[rate title="タイトル"]
[value 4]使いやすさ[/value]
[value 4.5]コンテンツの質[/value]
[value 4 end]総合評価[/value]
[/rate]
```

## 出典
```
[sanko href="URL" title="記事タイトル" site="サイト名"]
```
データの直後に配置。ボックス・テーブルの中ではなく外(下)に。

## CTA挿入
```
【ここに{サービス名}のアフィリエイトリンクを挿入】
```

## FAQ(plain textで書く。custom-faqは使わない)
- H3見出し・吹き出しは使わない
- 質問形式：「Q. 〜ですか？」「Q. 〜ますか？」で統一
- FAQのH2にも導入文を入れる
