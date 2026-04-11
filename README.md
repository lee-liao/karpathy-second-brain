# My Second Brain

A Karpathy-inspired minimalist knowledge management system using AI + flat markdown files.

**Philosophy:** Simple structure, AI does the work, grep is your search engine.

---

## Prerequisites

This project requires several tools to be installed:

### Required Tools

1. **Python 3 + Virtual Environment**
   ```bash
   python3 -m venv ~/.venv/second-brain
   source ~/.venv/second-brain/bin/activate
   pip install trafilatura requests pyyaml
   ```

2. **agent-browser** (Browser automation for JavaScript-heavy sites)
   ```bash
   npm install -g agent-browser
   # Or: sudo npm install -g agent-browser
   ```

3. **bun** (JavaScript runtime for agent-browser)
   ```bash
   curl -fsSL https://bun.sh/install | bash
   source ~/.bashrc
   ```

4. **Claude Code** (AI assistant for processing content)
   - Download from: https://claude.com/claude-code
   - Required for AI-powered content processing and fetching

### Optional Tools

- **unzip** (for bun installation)
  ```bash
  sudo apt install unzip
  ```

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

This system uses a **three-tier fetching strategy** to handle different types of websites. Site behavior is configured via `~/.config/sbfetch/config.yaml`:

**Tier 1: Trafilatura** (Fast, free)
- Works for: Blogs, news sites, documentation
- Example: `paulgraham.com`, `example.com`
- No browser required, pure HTTP fetching

**Tier 2: agent-browser** (JavaScript rendering)
- Works for: Sites requiring JS, dynamic content
- Example: Web apps, SPAs
- Uses headless Chrome with session persistence

**Tier 3: AI/Web Reader MCP** (Enterprise protection)
- Works for: WeChat, paywalled sites, heavily protected sites
- Example: `mp.weixin.qq.com`, `twitter.com`
- Uses cloud infrastructure with advanced anti-detection

**Usage:**
```bash
# Automatic tier selection - tries Trafilatura, then agent-browser, then prompts for AI
sbfetch https://example.com/article

# For WeChat and protected sites - use AI directly
"Please fetch this URL: https://mp.weixin.qq.com/s/..."
```

**Manual notes:**
```bash
# Create a file manually
echo "My thoughts..." > raw/personal/notes-$(date +%Y-%m-%d).md
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
sbsearch "topic"              # Search all wiki
sbsearch tech "python"        # Search tech category
sbsearch business "startup"   # Search business category
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

### Content Collection
```bash
sbfetch <url>                 # Smart fetch (auto-selects method)
                              # Uses: Trafilatura → agent-browser → AI prompt
```

### Search
```bash
sbsearch "topic"              # Search all wiki
sbsearch tech "topic"         # Search tech/ only
sbsearch business "topic"     # Search business/ only
sbsearch life "topic"         # Search life/ only
sbsearch quotes "topic"       # Search quotes/ only
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
~/second-brain/scripts/sbfetch.sh        # Smart URL fetcher
~/second-brain/scripts/process-raw.sh    # Show processing prompt
```

---

## How It Works

### Three-Tier Fetching Architecture

The `sbfetch` command automatically selects the best fetching method:

```
┌─────────────────────────────────────────────────────────────┐
│                    sbfetch <url>                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                ┌─────────────────────────┐
                │   Tier 1: Trafilatura   │  ← Fast, free
                │   (Python library)      │     Works for 90% of sites
                └──────────┬──────────────┘
                           │ (if fails)
                           ▼
                ┌─────────────────────────┐
                │   Tier 2: agent-browser │  ← JavaScript rendering
                │   (Local Chrome)        │     Handles dynamic content
                └──────────┬──────────────┘
                           │ (if fails)
                           ▼
                ┌─────────────────────────┐
                │   Tier 3: AI Prompt     │  ← Cloud infrastructure
                │   (Web Reader MCP)      │     Bypasses protection
                └─────────────────────────┘
```

**Why three tiers?**
- **Speed:** Trafilatura is instant (~2 seconds)
- **Coverage:** agent-browser handles JavaScript sites
- **Reliability:** AI bypasses enterprise-grade protection (WeChat, etc.)

**Sites that require AI (Tier 3):**
- WeChat articles (`mp.weixin.qq.com`)
- Twitter/X (`x.com`, `twitter.com`)
- Facebook (`facebook.com`)
- Medium (`medium.com`)
- LinkedIn (`linkedin.com`)

### No Database, Just Files

```bash
# Traditional systems
Database -> Index -> Search Engine -> Results

# This system
*.md files -> grep -> Results
```

**Benefits:**
- ✅ Files are human-readable (any text editor)
- ✅ Git-friendly (version control your knowledge)
- ✅ No database corruption
- ✅ Grep is blazing fast
- ✅ Works offline (except AI fetching)

### Search Performance

| Articles | Search Time |
|----------|-------------|
| 5,000    | < 1 second |
| 20,000   | 2-3 seconds |
| 50,000   | ~10 seconds |

**You won't hit practical limits for 10-20 years.**

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

### Load Aliases

```bash
# Aliases are loaded from ~/.bash_aliases_second_brain
# Add to ~/.bashrc for automatic loading:
echo 'source ~/.bash_aliases_second_brain' >> ~/.bashrc

# Reload manually
source ~/.bashrc
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

### Customize sbfetch Site Configuration

Edit `~/.config/sbfetch/config.yaml` to customize which sites use which fetching tier:

```yaml
# Sites that require browser rendering (JavaScript)
# These sites will try agent-browser first, then fall back to other methods
browser_required:
  - twitter.com
  - x.com
  - facebook.com
  - medium.com
  - substack.com
  - linkedin.com

# Sites with strong anti-bot protection that should go directly to Claude AI
# These sites skip agent-browser and Trafilatura entirely
claude_first:
  - mp.weixin.qq.com
  - weixin.qq.com
  # Add more protected sites here
```

**Why configure this?**
- **Speed**: Skip slow methods for known problematic sites
- **Reliability**: Go directly to AI for sites that always fail with automated tools
- **Cost**: Save API calls by trying faster methods first for compatible sites

---

## Common Workflows

### Collect & Process an Article

```bash
# 1. Collect (automatic tier selection)
sbfetch https://example.com/article

# Or for WeChat/protected sites:
# Paste to Claude: "Please fetch this URL: https://mp.weixin.qq.com/s/..."

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

### DO ✅
- **Collect freely** - Don't worry about organizing when collecting
- **Process weekly** - Batch processing is more efficient
- **Tag sparingly** - 3-5 relevant tags maximum
- **Link articles** - Build connections via `related:` metadata
- **Save outputs** - Good Q&A should go to `outputs/`
- **Use sbfetch** - Let it auto-select the best fetching method

### DON'T ❌
- **Don't** overthink categories - Start simple, evolve later
- **Don't** batch process 1000+ files - Do it incrementally
- **Don't** duplicate - Link to existing articles instead
- **Don't** hoard - Delete low-quality content
- **Don't** obsess over perfect tagging - Good enough is fine
- **Don't** force automation on WeChat - Use AI prompt (it works better)

---

## Advanced Usage

### Use with Git

```bash
cd /home/lee/second-brain
git init
git add .
git commit -m "Initial knowledge base"

# Track changes over time
git log -- wiki/tech/  # See how your tech knowledge evolved
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
source ~/.bash_aliases_second_brain

# Or add to .bashrc
echo 'source ~/.bash_aliases_second_brain' >> ~/.bashrc
```

### sbfetch fails on WeChat
```bash
# This is expected! WeChat requires AI
# Use the AI prompt instead:
"Please fetch this URL: https://mp.weixin.qq.com/s/..."
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
| `scripts/sbfetch.sh` | Smart URL fetcher (3-tier) |
| `scripts/search-wiki.sh` | Search with category support |

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
6. **Right tool for the job** - Use Trafilatura for speed, AI for reliability

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
**Last updated:** 2026-04-11
