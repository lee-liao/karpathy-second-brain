#!/bin/bash
# sbfetch.sh - Fetch URL and save to raw/ directory
# Usage: sbfetch <url>
#
# Strategy:
# 1. Try Trafilatura (fast, standalone) - for most sites
# 2. Try agent-browser (JavaScript rendering) - for protected sites
# 3. Fall back to AI prompt (user manual) - if both fail

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
        "需要验证"
        "请验证"
        "请完成验证"
        "access denied"
        "403 forbidden"
        "404 not found"
        "please verify"
        "captcha"
        "blocked"
        "订阅"
    )

    for pattern in "${error_patterns[@]}"; do
        if echo "$content" | grep -qi "$pattern"; then
            return 0
        fi
    done

    return 1
}

# Sites that require browser (JavaScript rendering)
BROWSER_REQUIRED_SITES=(
    "mp.weixin.qq.com"
    "weixin.qq.com"
    "twitter.com"
    "x.com"
    "facebook.com"
    "medium.com"
    "substack.com"
    "linkedin.com"
)

# Check if this domain requires browser
REQUIRES_BROWSER=false
for site in "${BROWSER_REQUIRED_SITES[@]}"; do
    if [[ "$DOMAIN" == *"$site"* ]] || [[ "$URL" == *"$site"* ]]; then
        REQUIRES_BROWSER=true
        break
    fi
done

# ===================================================================
# Method 1: agent-browser (for sites requiring JavaScript)
# ===================================================================
if [ "$REQUIRES_BROWSER" = true ]; then
    echo "🌐 Domain '$DOMAIN' requires browser rendering"
    echo "🔄 Trying agent-browser..."

    # Check if agent-browser exists
    if command -v agent-browser &> /dev/null; then
        # Close any existing sessions first
        agent-browser close &> /dev/null

        # Try to fetch with agent-browser using Chrome profile for better anti-detection
        # Check if Default profile exists, use it for cookies/session state
        if [ -d "$HOME/.config/google-chrome/Default" ]; then
            echo "  Using Chrome profile (may have cookies/session state)"
            BROWSER_CONTENT=$(timeout 30 bash -c "
                agent-browser --profile Default open '$URL' 2>&1
                sleep 3
                agent-browser eval 'document.body.innerText' 2>&1
            " 2>&1 | grep -v '✓\|⚠\|✗' | tr -d '"' | $VENV_PYTHON -c "import sys; print(sys.stdin.read().replace('\\\\n', '\n'))")
        else
            BROWSER_CONTENT=$(timeout 30 bash -c "
                agent-browser open '$URL' 2>&1
                sleep 2
                agent-browser eval 'document.body.innerText' 2>&1
            " 2>&1 | grep -v '✓\|⚠\|✗' | tr -d '"' | $VENV_PYTHON -c "import sys; print(sys.stdin.read().replace('\\\\n', '\n'))")
        fi

        # Clean up agent-browser session
        agent-browser close &> /dev/null

        if ! extraction_failed "$BROWSER_CONTENT"; then
            echo "✅ agent-browser succeeded!"

            # Try to extract title from content
            TITLE=$(echo "$BROWSER_CONTENT" | head -5 | grep -v '^\s*$' | head -1)
            if [ -z "$TITLE" ]; then
                TITLE="$DOMAIN - Article"
            fi

            # Create markdown file
            cat > "$FILENAME" << EOF
---
title: $TITLE
source: $URL
date_collected: $DATE
tags: [pending]
fetched_by: agent-browser
---

# $TITLE

Source: $URL
Collected: $DATE
Fetched with: agent-browser

## Content

$BROWSER_CONTENT
EOF

            echo "✅ Saved to: $FILENAME"
            echo ""
            echo "Next steps:"
            echo "  1. Review the file: less \"$FILENAME\""
            echo "  2. Process with AI: 'Please process my raw content'"
            exit 0
        fi
    else
        echo "⚠️  agent-browser not found, skipping..."
    fi
fi

# ===================================================================
# Method 2: Trafilatura (for all other sites or if browser failed)
# ===================================================================
if [ "$REQUIRES_BROWSER" = false ]; then
    echo "🔄 Step 1: Trying Trafilatura..."
else
    echo "🔄 Step 2: Falling back to Trafilatura..."
fi

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
fetched_by: trafilatura
---

# $TITLE

Source: $URL
Collected: $DATE
Fetched with: Trafilatura

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

# ===================================================================
# Method 2.5: agent-browser fallback (if Trafilatura failed and not yet tried)
# ===================================================================
if [ "$REQUIRES_BROWSER" = false ]; then
    echo "⚠️  Trafilatura failed or content was insufficient"
    echo "🔄 Step 2: Trying agent-browser as fallback..."

    # Check if agent-browser exists
    if command -v agent-browser &> /dev/null; then
        # Close any existing sessions first
        agent-browser close &> /dev/null

        # Try to fetch with agent-browser
        BROWSER_CONTENT=$(timeout 30 bash -c "
            agent-browser open '$URL' 2>&1
            sleep 2
            agent-browser eval 'document.body.innerText' 2>&1
        " 2>&1 | grep -v '✓\|⚠\|✗' | tr -d '"' | $VENV_PYTHON -c "import sys; print(sys.stdin.read().replace('\\\\n', '\n'))")

        # Clean up agent-browser session
        agent-browser close &> /dev/null

        if ! extraction_failed "$BROWSER_CONTENT"; then
            echo "✅ agent-browser fallback succeeded!"

            # Try to extract title from content
            TITLE=$(echo "$BROWSER_CONTENT" | head -5 | grep -v '^\s*$' | head -1)
            if [ -z "$TITLE" ]; then
                TITLE="$DOMAIN - Article"
            fi

            # Create markdown file
            cat > "$FILENAME" << EOF
---
title: $TITLE
source: $URL
date_collected: $DATE
tags: [pending]
fetched_by: agent-browser
---

# $TITLE

Source: $URL
Collected: $DATE
Fetched with: agent-browser (fallback)

## Content

$BROWSER_CONTENT
EOF

            echo "✅ Saved to: $FILENAME"
            echo ""
            echo "Next steps:"
            echo "  1. Review the file: less \"$FILENAME\""
            echo "  2. Process with AI: 'Please process my raw content'"
            exit 0
        fi
    else
        echo "⚠️  agent-browser not found, skipping..."
    fi
fi

# ===================================================================
# Method 3: AI fallback (manual prompt)
# ===================================================================
echo "⚠️  Both automated methods failed or content was insufficient"
echo ""
echo "Please use AI to fetch this URL:"
echo ""
echo "  \"Please fetch this URL: $URL\""
echo ""
echo "The AI will use the Web Reader MCP which can handle complex sites."
exit 1
