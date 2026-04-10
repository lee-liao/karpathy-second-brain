# My Second Brain

A Karpathy-inspired minimalist knowledge management system using AI + flat markdown files.

**Philosophy:** Simple structure, AI does the work, grep is your search engine.

---

## What Is This?

A personal knowledge base that separates **collection** from **organization**:

1. **Collect** - Dump articles, notes, tweets into `raw/` (zero friction)
2. **Process** - AI extracts insights and organizes into `wiki/` (batch processing)
3. **Query** - Search and ask questions based on your knowledge (outputs saved)

**No database. No complex software. Just markdown files + AI + grep.**

---

## Quick Start

```bash
# Navigate
cd /home/lee/second-brain

# Check what you have
sbcount

# Search for anything
sbsearch "topic"

# Process new content
# Just tell Claude: "Please process my raw content"
```

---

## Directory Structure

```
/home/lee/second-brain/
+-- raw/              # Unprocessed content (dump everything here)
|   +-- [domain]/     # Organized by source domain
+-- wiki/             # AI-organized knowledge base
|   +-- tech/         # Technical articles, tutorials, tools
|   +-- business/     # Business cases, startups, strategy
|   +-- life/         # Personal growth, philosophy, health
|   +-- quotes/       # Notable quotes, excerpts
|   +-- INDEX.md      # Master table of contents
+-- outputs/          # Q&A responses, generated content
+-- scripts/          # Helper automation scripts
+-- CLAUDE.md         # AI instructions (how to process content)
+-- PROMPTS.md        # Copy-paste prompts for workflows
+-- QUICKSTART.md     # One-page reference card
+-- README.md         # This file
```

---

## Daily Workflow

### Collect Content

**From a URL:**
```
"Please fetch this URL: [paste-url-here]"
```

**Manual notes:**
```
Create a file in raw/personal/notes-YYYY-MM-DD.md
Paste your content
```

### Process Content (Weekly)

When raw/ accumulates content:

```
"Please process my raw content"
```

AI will:
- Extract 3-5 key takeaways
- Categorize into tech/business/life/quotes
- Tag and link related articles
- Update INDEX.md

### Search & Query

**Search:**
```bash
sbsearch "machine learning"  # Search all wiki
sbtech "productivity"        # Search tech only
```

**Ask questions:**
```
"Based on my wiki, what do I know about [topic]?"
```

Answer gets saved to `outputs/` for future reference.

---

## Command Reference

### Navigation
```bash
sb          # cd to second brain
sraw        # cd to raw/
swiki       # cd to wiki/
sout        # cd to outputs/
```

### Search
```bash
sbsearch "topic"    # Search all wiki content
sbtech "topic"      # Search tech/ articles
sbbiz "topic"       # Search business/ articles
sblife "topic"      # Search life/ articles
```

### Information
```bash
sbcount     # Show statistics
sbindex     # View master index
sbrecent    # Show recent additions (last 7 days)
sbls        # List all wiki files
sblsraw     # List raw files pending processing
```

### Scripts
```bash
~/second-brain/scripts/stats.sh          # Statistics dashboard
~/second-brain/scripts/search-wiki.sh    # Search with context
~/second-brain/scripts/process-raw.sh    # Show processing prompt
```

---

## How It Works

### No Database, Just Files

```bash
# Traditional systems
Database -> Index -> Search Engine -> Results

# This system
*.md files -> grep -> Results
```

**Benefits:**
- [OK] Files are human-readable (any text editor)
- [OK] Git-friendly (version control your knowledge)
- [OK] No database corruption
- [OK] Zero dependencies
- [OK] Grep is blazing fast

### Search Performance

| Articles | Search Time |
|----------|-------------|
| 5,000    | < 1 second |
| 20,000   | 2-3 seconds |
| 50,000   | ~10 seconds |

**You won't hit practical limits for 10-20 years.**

### Scalability

**At 5 articles/day:**
```
1 year   = 1,825 articles
5 years  = 9,125 articles
10 years = 18,250 articles
20 years = 36,500 articles
```

**When to optimize:**
- ~10,000 articles (~5 years) -> Consider archiving old content
- Process in batches instead of all at once
- Archive by year: `wiki/2026/`, `wiki/2027/`, `wiki/archive/`

**Real bottleneck:** AI context window, not grep
```
Solution: Process incrementally
"Process raw content from last 7 days only"
"Process tech/ category only"
```

---

## Wiki Article Format

Every wiki entry follows this structure:

```markdown
---
title: "Descriptive Title"
category: [tech|business|life|quotes]
source: [URL or "personal note"]
date_collected: [YYYY-MM-DD]
tags: [tag1, tag2, tag3]
related: [path/to/related-article.md]
---

# Title

## Key Takeaways
1. First key insight
2. Second key insight
3. Third key insight

## Summary
2-3 paragraph overview

## Details
Main content with headings

## Notes
Personal thoughts, connections, action items
```

---

## Setup & Configuration

### First-Time Setup

Already done! System is ready at `/home/lee/second-brain/`

### Load Aliases (if needed)

```bash
# Add to ~/.bashrc for automatic loading
echo 'source ~/.bash_aliases' >> ~/.bashrc

# Or load manually
source ~/.bash_aliases
```

### Customize Categories

Edit `CLAUDE.md` to add/modify categories:

```bash
## Wiki Categories
- tech/     # Technical articles
- business/ # Business content
- life/     # Personal thoughts
- quotes/   # Notable quotes
- cooking/  # Your new category!
```

---

## Common Workflows

### Collect & Process an Article

```bash
# 1. Collect
sb
# Paste to Claude: "Please fetch this URL: https://example.com/article"

# 2. Process (do this weekly)
# Paste to Claude: "Please process my raw content"

# 3. Search
sbsearch "topic from article"
```

### Weekly Maintenance

```bash
# 1. Check what's pending
sblsraw

# 2. Process if needed
# "Please process my raw content"

# 3. Review what you added
sbrecent

# 4. Update index
# "Update the index"
```

### Monthly Review

```bash
# 1. Full statistics
~/second-brain/scripts/stats.sh

# 2. Health check
# "Please run a monthly health check"

# 3. Clean up
# "Help me clean up my raw directory"
```

---

## Tips & Best Practices

### DO [OK]
- **Collect freely** - Don't worry about organizing when collecting
- **Process weekly** - Batch processing is more efficient
- **Tag sparingly** - 3-5 relevant tags maximum
- **Link articles** - Build connections via `related:` metadata
- **Save outputs** - Good Q&A should go to `outputs/`

### DON'T [X]
- **Don't** overthink categories - Start simple, evolve later
- **Don't** batch process 1000+ files - Do it incrementally
- **Don't** duplicate - Link to existing articles instead
- **Don't** hoard - Delete low-quality content
- **Don't** obsess over perfect tagging - Good enough is fine

---

## Advanced Usage

### Use with Git

```bash
cd /home/lee/second-brain
git init
git add .
git commit -m "Initial knowledge base"

# Track changes over time
git log --wiki/tech/  # See how your tech knowledge evolved
```

### Batch URL Collection

```
"Process these URLs and save to raw/:
- https://example1.com
- https://example2.com
- https://example3.com

Don't process into wiki yet - just collect."
```

### Export to Other Tools

Since everything is markdown:

```bash
# Convert to PDF (pandoc)
pandoc wiki/tech/article.md -o article.pdf

# Import to Obsidian
cp -r wiki/ ~/ObsidianVault/

# Import to Notion (use markdown import feature)
```

---

## Troubleshooting

### Aliases not working
```bash
# Reload them
source ~/.bash_aliases

# Or add to .bashrc
echo 'source ~/.bash_aliases' >> ~/.bashrc
```

### Search returning nothing
```bash
# Check you're in the right place
pwd  # Should be /home/lee/second-brain

# Check files exist
sbls

# Use full script path
~/second-brain/scripts/search-wiki.sh "topic"
```

### Processing taking too long
```bash
# Process in smaller batches
"Process only tech/ content"
"Process last 7 days only"

# Check how much you have
sbcount
```

---

## File Reference

| File | Purpose |
|------|---------|
| `README.md` | This file - system overview |
| `CLAUDE.md` | AI instructions for processing |
| `PROMPTS.md` | Copy-paste workflow prompts |
| `QUICKSTART.md` | One-page quick reference |
| `wiki/INDEX.md` | Master table of contents |
| `scripts/*.sh` | Automation helpers |

---

## Philosophy

> "I'm trying to keep it super simple and flat. It's just a nested directory of .md files."
> — Andrej Karpathy

**Core principles:**

1. **Complexity is the enemy** - Simple structure scales better
2. **Separate collection from processing** - Don't organize while collecting
3. **AI does the work** - Let AI extract, categorize, connect
4. **Grep is your database** - Standard unix tools are powerful enough
5. **Optimize when needed** - Don't pre-optimize, start simple

---

## Inspiration

- [Andrej Karpathy](https://x.com/karpathy/status/2018043254986703167) - Minimalist second brain
- [Nick Spisak](https://x.com/nickspisak_/status/2040448463540830705) - Original discussion
- [Building a Second Brain](https://www.buildingasecondbrain.com/) - Tiago Forte (methodology)
- [Zettelkasten](https://en.wikipedia.org/wiki/Zettelkasten) - Card index system

---

## License

This is my personal knowledge management system. Feel free to copy and adapt for your own use.

---

**Location:** `/home/lee/second-brain/`
**Created:** 2026-04-10
**Last updated:** 2026-04-10
