#!/bin/bash
# Publish a markdown article to Dev.to
# Usage: bash publish-curl.sh <article.md>

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
API_KEY=$(grep DEVTO_API_KEY "$SCRIPT_DIR/.env" | cut -d= -f2 | tr -d '[:space:]')
ARTICLE_FILE="$1"

if [ -z "$ARTICLE_FILE" ]; then
  echo "Usage: bash publish-curl.sh <article.md>"
  exit 1
fi

# Extract body (skip frontmatter)
BODY=$(awk 'BEGIN{c=0} /^---$/{c++; if(c==2){skip=1; next}} skip{print}' "$ARTICLE_FILE")

# Extract frontmatter fields
TITLE=$(grep '^title:' "$ARTICLE_FILE" | sed 's/title: *"\(.*\)"/\1/')
DESC=$(grep '^description:' "$ARTICLE_FILE" | sed 's/description: *"\(.*\)"/\1/')
TAGS=$(grep '^tags:' "$ARTICLE_FILE" | sed 's/tags: *\[\(.*\)\]/\1/' | tr -d ' ')
PUBLISHED=$(grep '^published:' "$ARTICLE_FILE" | grep -c 'true')

if [ "$PUBLISHED" -eq 1 ]; then
  PUB="true"
else
  PUB="false"
fi

# Build JSON payload using node (handles escaping properly)
PAYLOAD=$(node -e "
  const body = $(node -e "console.log(JSON.stringify(require('fs').readFileSync('$ARTICLE_FILE','utf8').split('\n').slice(6).join('\n').trim()))");
  console.log(JSON.stringify({
    article: {
      title: $(node -e "console.log(JSON.stringify('$TITLE'))"),
      published: $PUB,
      body_markdown: body,
      description: $(node -e "console.log(JSON.stringify('$DESC'))"),
      tags: '${TAGS}'.split(',')
    }
  }));
")

curl -s -X POST https://dev.to/api/articles \
  -H "Content-Type: application/json" \
  -H "api-key: $API_KEY" \
  -d "$PAYLOAD"
