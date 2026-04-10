#!/bin/bash
# search-wiki.sh - Search wiki content with context
# Usage: ./scripts/search-wiki.sh "search term" [context_lines]

SEARCH_TERM="$1"
CONTEXT_LINES="${2:-2}"  # Default 2 lines of context

if [ -z "$SEARCH_TERM" ]; then
    echo "Usage: $0 \"search term\" [context_lines]"
    echo "Example: $0 \"machine learning\" 3"
    exit 1
fi

echo "=== Searching for: $SEARCH_TERM ==="
echo ""

grep -r -i -n -C "$CONTEXT_LINES" "$SEARCH_TERM" /home/lee/second-brain/wiki/ --include="*.md" 2>/dev/null

echo ""
echo "=== Found in files ==="
grep -r -i -l "$SEARCH_TERM" /home/lee/second-brain/wiki/ --include="*.md" 2>/dev/null | wc -l
echo "files"
