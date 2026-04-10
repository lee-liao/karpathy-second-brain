# My Second Brain Schema

## Directory Structure

```
/home/lee/second-brain/
├── raw/           # Unprocessed content collection (articles, notes, screenshots)
├── wiki/          # AI-organized knowledge base (structured by topic)
├── outputs/       # Q&A responses and generated content
├── scripts/       # Helper scripts for automation
├── CLAUDE.md      # This file - AI instructions for processing
├── PROMPTS.md     # Copy-paste prompts for common workflows
└── QUICKSTART.md  # Quick reference card
```

## Wiki Categories

Content in `wiki/` should be organized into these categories:

- **tech/** - Technical articles, tutorials, programming concepts, tools
- **business/** - Business cases, industry analysis, startups, strategy
- **life/** - Personal reflections, life lessons, philosophy, health
- **quotes/** - Notable quotes, excerpts, tweet threads

## Wiki Article Format

Every wiki article should follow this metadata structure:

```markdown
---
title: [Descriptive Title]
category: [tech|business|life|quotes]
source: [URL or "personal note"]
date_collected: [YYYY-MM-DD]
tags: [tag1, tag2, tag3]
related: [path/to/related-article.md]
---

# [Title]

## Key Takeaways
1. [First key insight]
2. [Second key insight]
3. [Third key insight]

## Summary
[2-3 paragraph summary of the main content]

## Details
[Main content, organized with headings]

## Notes
[Personal thoughts, connections to other topics, action items]
```

## Processing Rules (raw → wiki)

When processing content from `raw/` into `wiki/`:

1. **Extract 3-5 key takeaways** - What are the main insights?
2. **Categorize** - Which category does this belong in?
3. **Tag properly** - Add relevant tags for future search
4. **Link related content** - Connect to existing wiki articles
5. **Preserve source** - Always include original URL or attribution
6. **Generate clear filename** - Use descriptive kebab-case: `topic-description-date.md`

## INDEX.md Structure

The master index (`wiki/INDEX.md`) should be organized by:

```markdown
# Knowledge Base Index

Last updated: [YYYY-MM-DD]

## Statistics
- Total articles: [count]
- Tech: [count] | Business: [count] | Life: [count] | Quotes: [count]

## Recent Additions
- [Date] - [Title] ([category])
- [Date] - [Title] ([category])

## By Category

### Tech
- [Title](path) - [brief description]

### Business
- [Title](path) - [brief description]

### Life
- [Title](path) - [brief description]

### Quotes
- [Title](path) - [brief description]

## By Tag
#tag1 - [count] articles
#tag2 - [count] articles
```

## Workflow Trigger Phrases

Use these phrases to trigger specific workflows:

- **"Please process my raw content"** - Read all files in `raw/` and compile into `wiki/`
- **"Search for [topic]"** - Search across all wiki content for a topic
- **"Update the index"** - Regenerate `wiki/INDEX.md` with current content
- **"Answer this question:"** - Search wiki and generate answer based on knowledge base
- **"Weekly review"** - Review recent additions, suggest connections, flag gaps

## Search Guidelines

When searching the knowledge base:

1. **Start broad** - Use `Grep` tool with `output_mode: files_with_matches`
2. **Then deep** - Use `Grep` with `output_mode: content` and context for relevant files
3. **Check related** - Look at `related:` metadata in found articles
4. **Cross-reference** - Check INDEX.md for articles by same author or topic

## Content Quality Standards

**DO:**
- Extract original insights, don't just summarize
- Include personal context and connections
- Link to related concepts
- Add action items when applicable
- Preserve important quotes verbatim

**DON'T::**
- Create wiki entries for content you haven't read
- Over-tag (3-5 relevant tags maximum)
- Duplicate content (link to existing instead)
- Include raw promotional content or fluff

## Maintenance

**Weekly:**
- Process accumulated `raw/` content
- Update INDEX.md
- Review for connections between new and existing content

**Monthly:**
- Full knowledge base review
- Identify contradictions or outdated information
- Suggest gaps in knowledge collection
- Optimize category structure if needed

## Tools Available

- **Web Reader MCP** - Fetch and convert web articles to markdown
- **baoyu-url-to-markdown skill** - Alternative URL fetcher with site adapters
- **Bash scripts** - Located in `scripts/` for common operations
- **grep/rg** - Fast content search across all markdown files

## File Naming Conventions

- **Raw files:** `[domain-or-topic]-[slug]-[YYYY-MM-DD].md`
- **Wiki files:** `[topic]-[description]-[YYYY-MM-DD].md`
- **Output files:** `[topic]-qa-[YYYY-MM-DD].md` or `[topic]-essay-[YYYY-MM-DD].md`
- **Always use:** kebab-case, lowercase, descriptive names
