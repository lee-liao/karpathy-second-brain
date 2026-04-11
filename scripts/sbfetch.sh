#!/bin/bash
# sbfetch.sh - Fetch URL and save to raw/ directory
# Usage: sbfetch <url>
#
# Three-tier fetch strategy:
# Tier 1: Trafilatura (fast, standalone) - for most sites
# Tier 2: agent-browser (JavaScript rendering) - for protected sites
# Tier 3: Claude AI (Web Reader MCP) - for anti-bot sites
#
# Sites in CLAUDE_FIRST_SITES skip directly to Tier 3

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
    echo "Please run: python3 -m venv ~/.venv/second-brain && source ~/.venv/second-brain/bin/activate && pip install trafilatura requests pyyaml"
    exit 1
fi

# Configuration file
CONFIG_FILE="$HOME/.config/sbfetch/config.yaml"

# Function to read YAML config and output shell arrays
read_yaml_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        return 1
    fi

    $VENV_PYTHON - "$CONFIG_FILE" <<'PYTHON_SCRIPT'
import sys
import yaml

try:
    with open(sys.argv[1], 'r') as f:
        config = yaml.safe_load(f)

    # Output browser_required sites
    if 'browser_required' in config:
        print("BROWSER_REQUIRED_SITES=" + "|".join(config['browser_required']))

    # Output claude_first sites
    if 'claude_first' in config:
        print("CLAUDE_FIRST_SITES=" + "|".join(config['claude_first']))

except Exception as e:
    sys.exit(1)
PYTHON_SCRIPT
}

# Read config if available
CONFIG_OUTPUT=$(read_yaml_config)
if [ $? -eq 0 ] && [ -n "$CONFIG_OUTPUT" ]; then
    # Parse the output into arrays
    BROWSER_REQUIRED_SITES_STR=$(echo "$CONFIG_OUTPUT" | grep "^BROWSER_REQUIRED_SITES=" | cut -d= -f2)
    CLAUDE_FIRST_SITES_STR=$(echo "$CONFIG_OUTPUT" | grep "^CLAUDE_FIRST_SITES=" | cut -d= -f2)

    IFS='|' read -ra BROWSER_REQUIRED_SITES <<< "$BROWSER_REQUIRED_SITES_STR"
    IFS='|' read -ra CLAUDE_FIRST_SITES <<< "$CLAUDE_FIRST_SITES_STR"
else
    # Fallback to hardcoded values if config doesn't exist
    BROWSER_REQUIRED_SITES=(
        "twitter.com"
        "x.com"
        "facebook.com"
        "medium.com"
        "substack.com"
        "linkedin.com"
    )

    CLAUDE_FIRST_SITES=(
        "mp.weixin.qq.com"
        "weixin.qq.com"
    )
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

# Check if this domain requires browser
REQUIRES_BROWSER=false
for site in "${BROWSER_REQUIRED_SITES[@]}"; do
    if [[ "$DOMAIN" == *"$site"* ]] || [[ "$URL" == *"$site"* ]]; then
        REQUIRES_BROWSER=true
        break
    fi
done

# Check if this domain should go directly to Claude
USE_CLAUDE_FIRST=false
for site in "${CLAUDE_FIRST_SITES[@]}"; do
    if [[ "$DOMAIN" == *"$site"* ]] || [[ "$URL" == *"$site"* ]]; then
        USE_CLAUDE_FIRST=true
        break
    fi
done

# ===================================================================
# Skip to Claude AI for sites with strong anti-bot protection
# ===================================================================
if [ "$USE_CLAUDE_FIRST" = true ]; then
    echo "🌐 Domain '$DOMAIN' has strong anti-bot protection"
    echo "🔄 Skipping directly to Claude AI (most reliable method)..."

    # Check if we're already inside a Claude session
    if [ -n "$CLAUDECODE" ]; then
        echo "⚠️  sbfetch is running from within a Claude session."
        echo ""
        echo "Please ask me directly:"
        echo "  \"Please fetch this URL and save it: $URL\""
        echo ""
        echo "Or run sbfetch from your terminal (not from within Claude)."
        exit 1
    fi

    # Check if claude command exists
    if ! command -v claude &> /dev/null; then
        echo "⚠️  Claude command not found. Please install Claude Code CLI:"
        echo "  https://github.com/anthropics/claude-code"
        exit 1
    fi

    # Create prompt for Claude
    PROMPT="Please fetch the content from this URL: $URL

Use the Web Reader MCP (mcp__web_reader__webReader) or any available method to retrieve the content.

After fetching, save the markdown content to this exact path:
$FILENAME

Include the following metadata at the top of the file:
---
title: [Extract from page title or generate descriptive title]
source: $URL
date_collected: $DATE
tags: [pending]
fetched_by: claude-ai
---

The content should be well-formatted markdown. Return a brief confirmation when complete."

    # Invoke Claude in non-interactive mode
    echo "Invoking Claude AI..."
    claude -p "$PROMPT" --permission-mode bypassPermissions 2>&1

    CLAUDE_EXIT=$?

    if [ $CLAUDE_EXIT -eq 0 ] && [ -f "$FILENAME" ]; then
        echo ""
        echo "✅ Claude AI succeeded!"
        echo "✅ Saved to: $FILENAME"
        echo ""
        echo "Next steps:"
        echo "  1. Review the file: less \"$FILENAME\""
        echo "  2. Process with AI: 'Please process my raw content'"
        exit 0
    else
        echo ""
        echo "❌ Claude AI failed"
        echo ""
        echo "Manual options:"
        echo "  1. Run from terminal: claude -p \"Please fetch and save: $URL\""
        echo "  2. Or ask directly in this Claude session if running from one"
        exit 1
    fi
fi

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
# Method 3: AI fallback (non-interactive Claude)
# ===================================================================
echo "⚠️  Both automated methods failed or content was insufficient"
echo ""
echo "🔄 Step 3: Trying Claude AI with Web Reader MCP..."

# Check if claude command exists
if ! command -v claude &> /dev/null; then
    echo "⚠️  Claude command not found. Please install Claude Code CLI:"
    echo "  https://github.com/anthropics/claude-code"
    exit 1
fi

# Check if we're already inside a Claude session
if [ -n "$CLAUDECODE" ]; then
    echo "⚠️  sbfetch is running from within a Claude session."
    echo ""
    echo "Please ask me directly:"
    echo "  \"Please fetch this URL and save it: $URL\""
    echo ""
    echo "Or run sbfetch from your terminal (not from within Claude)."
    exit 1
fi

# Create a prompt that instructs Claude to fetch and save the content
PROMPT="Please fetch the content from this URL: $URL

Use the Web Reader MCP (mcp__web_reader__webReader) or any available method to retrieve the content.

After fetching, save the markdown content to this exact path:
$FILENAME

Include the following metadata at the top of the file:
---
title: [Extract from page title or generate descriptive title]
source: $URL
date_collected: $DATE
tags: [pending]
fetched_by: claude-ai
---

The content should be well-formatted markdown. Return a brief confirmation when complete."

# Invoke Claude in non-interactive mode
echo "Invoking Claude AI..."
claude -p "$PROMPT" --permission-mode bypassPermissions 2>&1

CLAUDE_EXIT=$?

if [ $CLAUDE_EXIT -eq 0 ] && [ -f "$FILENAME" ]; then
    echo ""
    echo "✅ Claude AI succeeded!"
    echo "✅ Saved to: $FILENAME"
    echo ""
    echo "Next steps:"
    echo "  1. Review the file: less \"$FILENAME\""
    echo "  2. Process with AI: 'Please process my raw content'"
    exit 0
else
    echo ""
    echo "❌ Claude AI fallback failed"
    echo ""
    echo "Manual options:"
    echo "  1. Run from terminal: claude -p \"Please fetch and save: $URL\""
    echo "  2. Or ask directly in this Claude session if running from one"
    exit 1
fi
