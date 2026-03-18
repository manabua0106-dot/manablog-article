#!/bin/bash
# nmanablog用 出典URLチェッカー
set +e
if [ $# -lt 1 ]; then echo "使い方: bash scripts/check-sources.sh <HTMLファイル>"; exit 1; fi
FILE="$1"
if [ ! -f "$FILE" ]; then echo "エラー: ファイル未検出: $FILE"; exit 1; fi
echo "出典URLチェック: $(basename "$FILE")"
URLS=$(grep -oP 'sanko href="[^"]*"' "$FILE" | sed 's/sanko href="//;s/"//' || true)
if [ -z "$URLS" ]; then echo "出典URLなし"; exit 0; fi
ERRORS=0
while IFS= read -r url; do
  [ -z "$url" ] && continue
  STATUS=$(curl -o /dev/null -s -w "%{http_code}" -L --max-time 10 "$url" 2>/dev/null)
  if [ "$STATUS" -eq 404 ]; then echo "[ERROR] 404: $url"; ERRORS=$((ERRORS+1))
  elif [ "$STATUS" -eq 200 ] || [ "$STATUS" -eq 301 ] || [ "$STATUS" -eq 302 ]; then echo "[OK] $STATUS: $url"
  else echo "[WARN] $STATUS: $url"; fi
done <<< "$URLS"
if [ "$ERRORS" -gt 0 ]; then echo "❌ 404あり"; exit 1; else echo "✅ 全URL有効"; exit 0; fi
