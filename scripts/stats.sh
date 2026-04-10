#!/bin/bash
# stats.sh - Show second brain statistics

echo "╔═══════════════════════════════════════╗"
echo "║   Second Brain Statistics             ║"
echo "╚═══════════════════════════════════════╝"
echo ""

# Count files
RAW_COUNT=$(find /home/lee/second-brain/raw -name "*.md" -type f 2>/dev/null | wc -l)
WIKI_COUNT=$(find /home/lee/second-brain/wiki -name "*.md" -type f 2>/dev/null | wc -l)
OUTPUT_COUNT=$(find /home/lee/second-brain/outputs -name "*.md" -type f 2>/dev/null | wc -l)

# Count by category
TECH_COUNT=$(find /home/lee/second-brain/wiki/tech -name "*.md" -type f 2>/dev/null | wc -l)
BUSINESS_COUNT=$(find /home/lee/second-brain/wiki/business -name "*.md" -type f 2>/dev/null | wc -l)
LIFE_COUNT=$(find /home/lee/second-brain/wiki/life -name "*.md" -type f 2>/dev/null | wc -l)
QUOTES_COUNT=$(find /home/lee/second-brain/wiki/quotes -name "*.md" -type f 2>/dev/null | wc -l)

# Calculate totals
TOTAL=$((RAW_COUNT + WIKI_COUNT + OUTPUT_COUNT))

echo "📊 Overview"
echo "   Total files: $TOTAL"
echo "   Raw (unprocessed): $RAW_COUNT"
echo "   Wiki (processed): $WIKI_COUNT"
echo "   Outputs: $OUTPUT_COUNT"
echo ""

echo "📁 Wiki by Category"
echo "   Tech:     $TECH_COUNT"
echo "   Business: $BUSINESS_COUNT"
echo "   Life:     $LIFE_COUNT"
echo "   Quotes:   $QUOTES_COUNT"
echo ""

echo "📈 Processing Status"
if [ "$RAW_COUNT" -gt 0 ]; then
    echo "   ⚠️  $RAW_COUNT files in raw/ waiting to be processed"
else
    echo "   ✅ No raw files pending"
fi
echo ""

echo "🕐 Recent Activity (last 7 days)"
RECENT=$(find /home/lee/second-brain/wiki -name "*.md" -type f -mtime -7 2>/dev/null | wc -l)
echo "   Articles added/modified: $RECENT"
echo ""

echo "💡 Next steps"
if [ "$RAW_COUNT" -gt 5 ]; then
    echo "   → Run: 'Please process my raw content'"
fi
if [ ! -f "/home/lee/second-brain/wiki/INDEX.md" ]; then
    echo "   → Run: 'Update the index'"
fi
