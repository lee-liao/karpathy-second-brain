#!/bin/bash
# search-wiki.sh - Search wiki content with context
# Usage: sbsearch [category] "search term" [context_lines]
#
# Categories: all, tech, business, life, quotes
# Default: all

CATEGORY="$1"
SEARCH_TERM="$2"
CONTEXT_LINES="${3:-2}"  # Default 2 lines of context

# If no category provided, default to "all" and shift arguments
if [ -z "$SEARCH_TERM" ]; then
    SEARCH_TERM="$CATEGORY"
    CATEGORY="all"
fi

if [ -z "$SEARCH_TERM" ]; then
    echo "Usage: sbsearch [category] \"search term\" [context_lines]"
    echo ""
    echo "Categories:"
    echo "  all       - Search all wiki (default)"
    echo "  tech      - Search tech/ only"
    echo "  business  - Search business/ only"
    echo "  life      - Search life/ only"
    echo "  quotes    - Search quotes/ only"
    echo ""
    echo "Examples:"
    echo "  sbsearch \"machine learning\""
    echo "  sbsearch tech \"python\""
    echo "  sbsearch business \"startup\" 3"
    exit 1
fi

# Determine search directory based on category
case "$CATEGORY" in
    all|ALL)
        SEARCH_DIR="/home/lee/second-brain/wiki/"
        CATEGORY_NAME="All wiki"
        ;;
    tech|TECH)
        SEARCH_DIR="/home/lee/second-brain/wiki/tech/"
        CATEGORY_NAME="Tech"
        ;;
    business|BUSINESS)
        SEARCH_DIR="/home/lee/second-brain/wiki/business/"
        CATEGORY_NAME="Business"
        ;;
    life|LIFE)
        SEARCH_DIR="/home/lee/second-brain/wiki/life/"
        CATEGORY_NAME="Life"
        ;;
    quotes|QUOTES)
        SEARCH_DIR="/home/lee/second-brain/wiki/quotes/"
        CATEGORY_NAME="Quotes"
        ;;
    *)
        echo "Error: Unknown category '$CATEGORY'"
        echo "Valid categories: all, tech, business, life, quotes"
        exit 1
        ;;
esac

# Check if search directory exists
if [ ! -d "$SEARCH_DIR" ]; then
    echo "Error: Directory not found: $SEARCH_DIR"
    exit 1
fi

echo "=== Searching $CATEGORY_NAME for: $SEARCH_TERM ==="
echo ""

grep -r -i -n -C "$CONTEXT_LINES" "$SEARCH_TERM" "$SEARCH_DIR" --include="*.md" 2>/dev/null

echo ""
echo "=== Found in files ==="
grep -r -i -l "$SEARCH_TERM" "$SEARCH_DIR" --include="*.md" 2>/dev/null | wc -l
echo "files"
