# Second Brain Quick Start

**Location:** `/home/lee/second-brain/`
**Last updated:** 2026-04-10

---

## How to Read This Guide

**🖥️ Terminal Commands** → Run in your terminal (bash/zsh)
**🤖 AI Prompts** → Copy and paste to Claude/AI

---

## Daily Workflow

### Collect Content

**🖥️ Terminal:**
```bash
# Navigate to second brain
sb
```

**🤖 AI Prompt:**
```
"Please fetch this URL: [paste-url-here]"
```

---

### Quick Search

**🖥️ Terminal:**
```bash
# Search for any topic (all categories)
sbsearch "your topic"

# Search specific category
sbsearch tech "topic"
sbsearch business "topic"
sbsearch life "topic"
```

---

## Weekly Workflow (Sundays)

### 1. Process Raw Content

**🤖 AI Prompt:**
```
"Please process my raw content"
```

**What happens:** AI reads raw/, extracts insights, creates wiki entries

### 2. Update Index

**🤖 AI Prompt:**
```
"Update the index"
```

**What happens:** AI updates wiki/INDEX.md with current content

### 3. Review New Additions

**🖥️ Terminal:**
```bash
# View master index
sbindex

# Or open in editor
code ~/second-brain/wiki/INDEX.md
```

---

## Monthly Workflow

### 1. Health Check

**🤖 AI Prompt:**
```
"Please run a monthly health check"
```

**What happens:** AI reviews entire wiki for contradictions and gaps

### 2. Clean Raw Directory

**🤖 AI Prompt:**
```
"Help me clean up my raw directory"
```

**What happens:** AI suggests what to delete, process, or keep

### 3. Reflect on Themes

**🖥️ Terminal:**
```bash
# Review what you've been learning
sbrecent

# Check statistics
sbcount
```

---

## Terminal Commands Reference

**Navigation:**
```bash
sb           # cd to second brain
sraw         # cd to raw/
swiki        # cd to wiki/
sout         # cd to outputs/
```

**Search:**
```bash
sbsearch "topic"           # Search all wiki
sbsearch tech "topic"      # Search tech/ only
sbsearch business "topic"  # Search business/ only
sbsearch life "topic"      # Search life/ only
sbsearch quotes "topic"    # Search quotes/ only
```

**Information:**
```bash
sbcount      # Show statistics
sbindex      # View master index
sbrecent     # Show recent additions
sbls         # List all wiki files
sblsraw      # List raw files pending
```

---

## AI Prompts Reference

**Collect Content:**
```
"Please fetch this URL: [paste-url]"
```

**Process Content:**
```
"Please process my raw content"
```

**Ask Questions:**
```
"Based on my wiki, [your question here]"
```

**Update Index:**
```
"Update the index"
```

**Health Check:**
```
"Please run a monthly health check"
```

**Search Content:**
```
"Search my wiki for [topic] and summarize what I know"
```

---

## Common Workflows

### Add a Web Article

1. **🖥️ Terminal:** Run `sb`
2. **🤖 AI Prompt:** "Please fetch this URL: [paste-url]"
3. **Result:** Content saved to `raw/`

### Process Raw Content

1. **🤖 AI Prompt:** "Please process my raw content"
2. **Result:** AI creates wiki entries, updates INDEX.md

### Ask a Question

1. **🤖 AI Prompt:** "Based on my wiki, what do I know about [topic]?"
2. **Result:** AI searches wiki and saves answer to `outputs/`

### Find Information

1. **🖥️ Terminal:** Run `sbsearch "topic"`
2. **Result:** Shows files matching your search

---

## File Locations

| Purpose | Path |
|---------|------|
| Raw collection | `/home/lee/second-brain/raw/` |
| Processed wiki | `/home/lee/second-brain/wiki/` |
| Q&A outputs | `/home/lee/second-brain/outputs/` |
| AI instructions | `/home/lee/second-brain/CLAUDE.md` |
| Workflow prompts | `/home/lee/second-brain/PROMPTS.md` |
| Helper scripts | `/home/lee/second-brain/scripts/` |

---

## Categories

- **tech/** - Programming, tools, technical concepts
- **business/** - Startups, strategy, industry analysis
- **life/** - Personal growth, philosophy, health
- **quotes/** - Notable quotes, excerpts

---

## Need More Help?

- **Full prompts**: See `PROMPTS.md`
- **System details**: See `CLAUDE.md`
- **Complete guide**: See `README.md`
- **Scripts**: Check `scripts/` directory

---

## Quick Decision Tree

```
Want to collect content?
  → 🤖 "Please fetch this URL: [url]"

Want to find something?
  → 🖥️ sbsearch "topic"
  → OR 🤖 "Search my wiki for [topic]"

Want to organize?
  → 🤖 "Please process my raw content"

Want to see what you have?
  → 🖥️ sbcount
  → 🖥️ sbindex
```

---

*Remember: **Terminal commands** manipulate files, **AI prompts** process content.*
