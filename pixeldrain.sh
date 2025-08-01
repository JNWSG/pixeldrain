#!/bin/bash

FILE="$1"
API_KEY="b2dc58bf-0ebc-4fe6-adc0-bf14515a385e"

if [ ! -f "$FILE" ]; then
  echo "❌ File not found: $FILE"
  echo "Usage: ./pixeldrain.sh path/to/your_rom.zip"
  exit 1
fi

FILENAME=$(basename "$FILE")
echo "📤 Uploading: $FILENAME to PixelDrain..."

RESPONSE=$(curl --progress-bar -T "$FILE" -u :$API_KEY https://pixeldrain.com/api/file/)
echo

ID=$(echo "$RESPONSE" | jq -r '.id')

if [ "$ID" != "null" ] && [ -n "$ID" ]; then
  LINK="https://pixeldrain.com/u/$ID"
  echo "✅ Upload successful!"
  echo "🔗 Download Link: $LINK"

  if command -v termux-clipboard-set >/dev/null 2>&1; then
    echo -n "$LINK" | termux-clipboard-set
    echo "📋 Link copied to Termux clipboard"
  elif command -v xclip >/dev/null 2>&1; then
    echo -n "$LINK" | xclip -selection clipboard
    echo "📋 Link copied to system clipboard (xclip)"
  elif command -v xsel >/dev/null 2>&1; then
    echo -n "$LINK" | xsel --clipboard --input
    echo "📋 Link copied to system clipboard (xsel)"
  fi
else
  echo "❌ Upload failed!"
  echo "$RESPONSE"
fi
