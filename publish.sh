#!/bin/bash
# Publish a markdown article to Dev.to via API
# Usage: bash publish.sh <article.md>

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
API_KEY=$(grep DEVTO_API_KEY "$SCRIPT_DIR/.env" | cut -d= -f2 | tr -d '[:space:]')
ARTICLE_FILE="$1"

if [ -z "$ARTICLE_FILE" ]; then
  echo "Usage: bash publish.sh <article.md>"
  exit 1
fi

# Use node to properly parse frontmatter and build JSON payload
TMPFILE=$(node -e "
const fs = require('fs');
const content = fs.readFileSync(process.argv[1], 'utf8');
const lines = content.split('\n');
let fmEnd = 0, count = 0;
for (let i = 0; i < lines.length; i++) {
  if (lines[i].trim() === '---') { count++; if (count === 2) { fmEnd = i; break; } }
}
const fm = lines.slice(1, fmEnd).join('\n');
const title = (fm.match(/title:\\s*\"(.+)\"/)||[])[1] || 'Untitled';
const desc = (fm.match(/description:\\s*\"(.+)\"/)||[])[1] || '';
const tagsMatch = fm.match(/tags:\\s*\\[(.+)\\]/);
const tags = tagsMatch ? tagsMatch[1].split(',').map(t=>t.trim()) : [];
const published = fm.includes('published: true');
const body = lines.slice(fmEnd + 1).join('\n').trim();
const payload = JSON.stringify({ article: { title, published, body_markdown: body, description: desc, tags } });
const os = require('os');
const path = require('path');
const tmpFile = path.join(os.tmpdir(), 'devto-payload.json');
fs.writeFileSync(tmpFile, payload);
console.log(tmpFile);
" "$ARTICLE_FILE")

curl -s -X POST https://dev.to/api/articles \
  -H "Content-Type: application/json" \
  -H "api-key: $API_KEY" \
  -d @"$TMPFILE"

rm -f "$TMPFILE"
