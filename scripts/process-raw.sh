#!/bin/bash
# process-raw.sh - Display prompt for processing raw content

cat << 'EOF'

╔════════════════════════════════════════════════════════════╗
║           Process Raw Content - Copy This Prompt           ║
╚════════════════════════════════════════════════════════════╝

Please process my raw content.

1. Read all files in /home/lee/second-brain/raw/ and its subdirectories
2. For each file:
   - Extract 3-5 key takeaways
   - Categorize into tech/, business/, life/, or quotes/
   - Add appropriate metadata (title, category, source, date, tags)
   - Create wiki entry following the format in CLAUDE.md
3. Look for connections between new content and existing wiki entries
4. Update /home/lee/second-brain/wiki/INDEX.md with all current content

Start by showing me what raw files you found, then process them one by one.

═══════════════════════════════════════════════════════════════

EOF

# Count and display raw files
RAW_COUNT=$(find /home/lee/second-brain/raw -name "*.md" -type f 2>/dev/null | wc -l)
echo "Raw files pending: $RAW_COUNT"
