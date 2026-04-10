# Second Brain Quick Start

**Location:** `/home/lee/second-brain/`
**Last updated:** 2026-04-10

## Daily Workflow

### Collect Content
```bash
# Navigate to second brain
sb

# Collect a URL (paste the prompt below)
"Please fetch this URL: [paste-url]"
```

### Quick Search
```bash
# Search for any topic
sbsearch "your topic"

# Search specific category
sbtech "topic"
sbbiz "topic"
```

## Weekly Workflow (Sundays)

1. **Process raw content** → Use prompt: "Please process my raw content"
2. **Update index** → Use prompt: "Update the index"
3. **Review new additions** → Check `wiki/INDEX.md`

## Monthly Workflow

1. **Health check** → Use prompt: "Please run a monthly health check"
2. **Clean raw/** → Use prompt: "Help me clean up my raw directory"
3. **Reflect on themes** → Review what you've been learning

## Quick Commands

```bash
sb           # cd to second brain
sraw         # cd to raw/
swiki        # cd to wiki/
sout         # cd to outputs/

sbsearch     # search all wiki content
sbtech       # search tech/ only
sbbiz        # search business/ only
sblife       # search life/ only

sbcount      # show statistics
sbindex      # view master index
sbrecent     # show recent additions

sbls         # list all wiki files
sblsraw      # list raw files pending processing
```

## File Locations

| Purpose | Path |
|---------|------|
| Raw collection | `/home/lee/second-brain/raw/` |
| Processed wiki | `/home/lee/second-brain/wiki/` |
| Q&A outputs | `/home/lee/second-brain/outputs/` |
| AI instructions | `/home/lee/second-brain/CLAUDE.md` |
| Workflow prompts | `/home/lee/second-brain/PROMPTS.md` |
| Helper scripts | `/home/lee/second-brain/scripts/` |

## Common Workflows

### Add a web article:
1. Copy prompt from PROMPTS.md: "Collect a Web Article"
2. Paste URL
3. Content goes to `raw/`

### Process raw content:
1. Use prompt: "Please process my raw content"
2. AI extracts insights, categorizes, creates wiki entries
3. Updates INDEX.md

### Ask a question:
1. Use prompt: "Ask a Question"
2. AI searches wiki and synthesizes answer
3. Saves to `outputs/`

### Find information:
1. Run `sbsearch "topic"`
2. AI finds relevant articles
3. Shows context and connections

## Categories

- **tech/** - Programming, tools, technical concepts
- **business/** - Startups, strategy, industry analysis
- **life/** - Personal growth, philosophy, health
- **quotes/** - Notable quotes, excerpts

## Need More Help?

- **Full prompts**: See `PROMPTS.md`
- **System details**: See `CLAUDE.md`
- **Scripts**: Check `scripts/` directory

---

*Remember: Keep collection simple (just dump to raw/), let AI do the organizing.*
