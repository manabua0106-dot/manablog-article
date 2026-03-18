#!/bin/bash
# nmanablog用 lint.sh
set +e

if [ $# -lt 1 ]; then echo "使い方: bash scripts/lint.sh <HTMLファイル>"; exit 1; fi
FILE="$1"
if [ ! -f "$FILE" ]; then echo "エラー: ファイル未検出: $FILE"; exit 1; fi

ERRORS=0; WARNINGS=0
RED='\033[0;31m'; YELLOW='\033[0;33m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'

error() { echo -e "${RED}[ERROR]${NC} ${CYAN}[$1]${NC} L$2: $3"; ERRORS=$((ERRORS+1)); }
warning() { echo -e "${YELLOW}[WARN]${NC} ${CYAN}[$1]${NC} L$2: $3"; WARNINGS=$((WARNINGS+1)); }

echo "============================================================"
echo "lint.sh(nmanablog) — $(basename "$FILE")"
echo "============================================================"

# 1. 禁止ワード
for w in "様々" "行なう" "行なっ" "行なわ" "負荷" "スキット" "到達" "テーブル" "迷わなくなります" "迷いがなくなります"; do
  while IFS= read -r n; do error "禁止" "$n" "「${w}」は禁止"; done < <(grep -n "$w" "$FILE" | cut -d: -f1)
done

# AI表現
for p in "有効です" "大きな分かれ道" "成功の鍵" "のが基本です" "基本となります" "刺さる" "グッと" "一気に" "道が開ける" "未来が切り拓ける" "効果的です" "おすすめです" "おすすめします" "不安が軽くなります" "不安が和らぎます" "全級合計"; do
  while IFS= read -r n; do error "AI表現" "$n" "「${p}」禁止"; done < <(grep -n "$p" "$FILE" | cut -d: -f1)
done

# 比喩
for p in "土台になる" "基礎に穴" "道が開ける" "景色が変わり" "入り口が広い" "壁を崩す" "近道です" "近づけます" "広がります" "第一歩" "絞られる" "幅が狭まる"; do
  while IFS= read -r n; do error "比喩" "$n" "「${p}」禁止"; done < <(grep -n "$p" "$FILE" | cut -d: -f1)
done

# 後述系
for p in "後ほど紹介" "詳しくは後述" "前述の通り"; do
  while IFS= read -r n; do error "後述系" "$n" "「${p}」禁止"; done < <(grep -n "$p" "$FILE" | cut -d: -f1)
done

# 2. 冗長表現
TOIU=$(grep -c "という" "$FILE" || true)
if [ "$TOIU" -gt 3 ]; then error "冗長" "0" "「という」が${TOIU}箇所(上限3)"; fi

# 3. 指示語
for d in "これは" "これが" "それは" "それが" "あれは" "あれが"; do
  while IFS= read -r n; do error "指示語" "$n" "指示語「${d}」が使われています"; done < <(grep -n "$d" "$FILE" | cut -d: -f1)
done

# 4. 「ことです」
while IFS= read -r n; do error "こと" "$n" "「ことです」で文が終わっています"; done < <(grep -n "ことです" "$FILE" | cut -d: -f1)

# 5. 記号
while IFS= read -r n; do error "記号" "$n" "全角カッコ→半角に統一"; done < <(grep -n "（\|）" "$FILE" | cut -d: -f1)
while IFS= read -r n; do error "記号" "$n" "H2に「？」禁止"; done < <(grep -n "<h2.*>.*？.*</h2>" "$FILE" | cut -d: -f1)

# 6. HTMLタグ
while IFS= read -r n; do error "HTML" "$n" "<strong>禁止"; done < <(grep -n "<strong>" "$FILE" | cut -d: -f1)
while IFS= read -r n; do error "HTML" "$n" "<b>禁止"; done < <(grep -n "<b>" "$FILE" | cut -d: -f1)
while IFS= read -r n; do
  line=$(sed -n "${n}p" "$FILE")
  if ! echo "$line" | grep -q "class=\"table1\""; then error "HTML" "$n" "tableのclassがtable1ではない"; fi
done < <(grep -n "<table" "$FILE" | cut -d: -f1)

# 7. H3パーツ存在
H3_LINES=$(grep -n "<h3" "$FILE" | cut -d: -f1)
TOTAL=$(wc -l < "$FILE")
prev=""
for h3 in $H3_LINES; do
  if [ -n "$prev" ]; then
    sec=$(sed -n "${prev},${h3}p" "$FILE")
    if ! echo "$sec" | grep -q "\[say "; then error "パーツ" "$prev" "H3(L${prev})に吹き出しなし"; fi
    if ! echo "$sec" | grep -q "keiko_yellow"; then warning "パーツ" "$prev" "H3(L${prev})にマーカーなし"; fi
    if ! echo "$sec" | grep -qE "\[memo|\[alert|\[box|<table"; then warning "パーツ" "$prev" "H3(L${prev})にボックス/テーブルなし"; fi
  fi
  prev=$h3
done
if [ -n "$prev" ]; then
  sec=$(sed -n "${prev},${TOTAL}p" "$FILE")
  if ! echo "$sec" | grep -q "\[say "; then error "パーツ" "$prev" "最後のH3(L${prev})に吹き出しなし"; fi
fi

# 結果
echo "============================================================"
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  echo -e "${GREEN}✅ 違反なし${NC}"; exit 0
elif [ "$ERRORS" -eq 0 ]; then
  echo -e "${YELLOW}⚠️ ERROR:0 / WARN:${WARNINGS}${NC}"; exit 0
else
  echo -e "${RED}❌ ERROR:${ERRORS} / WARN:${WARNINGS}${NC}"; exit 1
fi
