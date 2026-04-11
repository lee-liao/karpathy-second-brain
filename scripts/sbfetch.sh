#!/bin/bash
# sbfetch.sh - Fetch URL and save to raw/ directory
# Usage: sbfetch <url>
#
# Strategy:
# 1. Try Trafilatura (fast, standalone)
# 2. If failed, fall back to AI (via Web Reader MCP)

URL="$1"

if [ -z "$URL" ]; then
    echo "Usage: sbfetch <url>"
    echo "Example: sbfetch https://example.com/article"
    exit 1
fi

# Validate URL
if [[ ! "$URL" =~ ^https?:// ]]; then
    echo "Error: URL must start with http:// or https://"
    exit 1
fi

# Virtual environment Python
VENV_PYTHON="$HOME/.venv/second-brain/bin/python"

# Check if venv exists
if [ ! -f "$VENV_PYTHON" ]; then
    echo "Error: Virtual environment not found at $VENV_PYTHON"
    echo "Please run: python3 -m venv ~/.venv/second-brain && source ~/.venv/second-brain/bin/activate && pip install trafilatura requests"
    exit 1
fi

# Generate filename from URL
DOMAIN=$(echo "$URL" | sed -e 's|^[^/]*//||' -e 's|/.*$||')
SLUG=$(echo "$URL" | sed -e 's|^[^/]*//||' -e 's|/$||' -e 's|/|-|g' -e 's|[^a-zA-Z0-9-]||g' | cut -c1-50)
DATE=$(date +%Y-%m-%d)
RAW_DIR="/home/lee/second-brain/raw/${DOMAIN}"
FILENAME="${RAW_DIR}/${SLUG}-${DATE}.md"

# Check if file already exists
if [ -f "$FILENAME" ]; then
    echo "Warning: File already exists: $FILENAME"
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Create raw directory and domain subdirectory if they don't exist
mkdir -p "$RAW_DIR"

# Sites that require AI (skip Trafilatura)
AI_REQUIRED_SITES=(
    "mp.weixin.qq.com"
    "weixin.qq.com"
    "twitter.com"
    "x.com"
    "facebook.com"
    "medium.com"
    "substack.com"
    "linkedin.com"
)

# Check if this domain requires AI
REQUIRES_AI=false
for site in "${AI_REQUIRED_SITES[@]}"; do
    if [[ "$DOMAIN" == *"$site"* ]] || [[ "$URL" == *"$site"* ]]; then
        REQUIRES_AI=true
        break
    fi
done

# If domain requires AI, skip Trafilatura
if [ "$REQUIRES_AI" = true ]; then
    echo "🤖 Domain '$DOMAIN' requires AI (JavaScript/anti-bot protection)"
    echo "🔄 Skipping Trafilatura, going straight to AI..."
    echo ""

    # Check if we're running inside Claude Code
    if [ -n "$CLAUDECODE" ]; then
        echo "⚠️  Running inside Claude Code session"
        echo ""
        echo "Please use this prompt directly:"
        echo ""
        echo "  \"Please fetch this URL: $URL\""
        echo ""
        echo "Or run sbfetch from a separate terminal (not inside Claude Code)"
        exit 1
    fi

    # Check if claude CLI exists
    if ! command -v claude &> /dev/null; then
        echo "Error: claude CLI not found"
        echo "Please install Claude Code CLI or use AI manually:"
        echo "  \"Please fetch this URL: $URL\""
        exit 1
    fi

    # Use claude CLI to fetch with AI
    echo "Invoking AI to fetch content..."
    claude -p --add-dir /home/lee/second-brain/raw \
        "Please fetch this URL: $URL

Use the webReader MCP tool to fetch the content and save it as a markdown file.
Save the file to: $FILENAME

Format the file with:
- YAML frontmatter with title, source, date_collected, tags
- Clear heading structure
- Main content in markdown

After saving, report the filename." 2>&1 | tail -20

    echo ""
    echo "✅ Done! Check: $FILENAME"
    exit 0
fi

# Function to detect if content extraction failed
extraction_failed() {
    local content="$1"

    # Check if empty
    if [ -z "$content" ]; then
        return 0
    fi

    # Check if too short (less than 200 chars)
    local length=${#content}
    if [ "$length" -lt 200 ]; then
        return 0
    fi

    # Check for error patterns (Chinese and English)
    local error_patterns=(
        "环境异常"
        "验证"
        "access denied"
        "403 forbidden"
        "404 not found"
        "please verify"
        "captcha"
        "blocked"
        "subscription"
        "login required"
    )

    for pattern in "${error_patterns[@]}"; do
        if echo "$content" | grep -qi "$pattern"; then
            return 0
        fi
    done

    return 1
}

echo "🔄 Step 1: Trying Trafilatura..."
echo "Fetching: $URL"

# Use Python script with trafilatura and requests
EXTRACTED_CONTENT=$($VENV_PYTHON - <<PYTHON_SCRIPT
import sys
import requests
import trafilatura

url = "$URL"

try:
    # Fetch with requests (more reliable)
    response = requests.get(url, timeout=30, headers={'User-Agent': 'Mozilla/5.0'})
    response.raise_for_status()

    # Extract with trafilatura
    content = trafilatura.extract(
        response.content,
        include_comments=False,
        include_tables=True,
        output_format='markdown'
    )

    if content:
        print(content, end='')
    else:
        sys.exit(1)
except Exception as e:
    sys.exit(1)
PYTHON_SCRIPT
)

TRAFAILATURA_EXIT=$?

# Check if Trafilatura succeeded
if [ $TRAFAILATURA_EXIT -eq 0 ] && ! extraction_failed "$EXTRACTED_CONTENT"; then
    echo "✅ Trafilatura succeeded!"

    # Try to get title from first heading or use domain
    TITLE=$(echo "$EXTRACTED_CONTENT" | grep -m 1 '^#' | sed 's/^# //' | head -1)
    if [ -z "$TITLE" ]; then
        TITLE="$DOMAIN - Article"
    fi

    # Create markdown file with metadata
    cat > "$FILENAME" << EOF
---
title: $TITLE
source: $URL
date_collected: $DATE
tags: [pending]
---

# $TITLE

Source: $URL
Collected: $DATE

## Content

$EXTRACTED_CONTENT
EOF

    echo "✅ Saved to: $FILENAME"
    echo ""
    echo "Next steps:"
    echo "  1. Review the file: less \"$FILENAME\""
    echo "  2. Process with AI: 'Please process my raw content'"
    exit 0
fi

# Trafilatura failed - fall back to AI
echo "⚠️  Trafilatura failed or content was insufficient"
echo "🔄 Step 2: Falling back to AI (Web Reader MCP)..."
echo ""

# Check if claude CLI exists
if ! command -v claude &> /dev/null; then
    echo "Error: claude CLI not found"
    echo "Please install Claude Code CLI or use AI manually:"
    echo "  \"Please fetch this URL: $URL\""
    exit 1
fi

# Use claude CLI to fetch with AI
echo "Invoking AI to fetch content..."
claude -p --add-dir /home/lee/second-brain/raw \
    "Please fetch this URL: $URL

Use the webReader MCP tool to fetch the content and save it as a markdown file.
Save the file to: $FILENAME

Format the file with:
- YAML frontmatter with title, source, date_collected, tags
- Clear heading structure
- Main content in markdown

After saving, report the filename." 2>&1 | grep -E "(Saved to|✅|Error|Failed)" || echo "AI fetch completed"

echo ""
echo "✅ Done! Check if file was created: $FILENAME"
