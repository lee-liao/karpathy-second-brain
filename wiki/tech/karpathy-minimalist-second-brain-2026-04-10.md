---
title: "Karpathy's Minimalist Second Brain System"
category: tech
source: https://mp.weixin.qq.com/s/V8PLwa9DqyQzrRVoyooHmg
date_collected: 2026-04-10
tags: [knowledge-management, ai, productivity, karpathy, minimalism]
related: []
---

# Karpathy's Minimalist Second Brain System

## Key Takeaways

1. **Complexity is the enemy** - Knowledge management systems fail because they're too complex. Karpathy's approach uses a simple three-folder structure with AI doing the heavy lifting.

2. **Separate collection from organization** - The key insight: collect everything without organizing (raw/), then use AI to periodically process and organize it (wiki/). This eliminates the friction that stops people from collecting content in the first place.

3. **AI excels at pattern recognition, humans excel at judgment** - Let AI handle extraction, categorization, and connection-finding. Let humans handle defining the schema, determining value, and asking good questions.

## Summary

Andrej Karpathy's minimalist second brain system consists of just three directories:

- **raw/** - Unprocessed content collection (articles, notes, screenshots). No manual organizing, renaming, or categorizing. Just dump everything here.

- **wiki/** - AI-organized knowledge base. Periodically run a prompt that has Claude read everything in raw/ and compile it into structured wiki entries following a defined schema.

- **outputs/** - Q&A responses and generated content. When you ask questions based on your wiki, save the answers here. These can become inputs for future wiki updates.

The system works because it eliminates the friction that causes traditional knowledge management to fail. Instead of forcing you to categorize and tag everything as you collect it, you just dump to raw/. Then you use a single prompt to have AI process everything at once.

## Why This Approach Works

### Separates Collection from Processing
Traditional systems fail because you see good content but the thought of categorizing, tagging, and summarizing stops you from saving it. This method separates collection (zero friction) from processing (AI-powered batch processing).

### Leverages AI Strengths
AI is excellent at: extracting information, finding patterns, generating summaries, making connections. Humans are excellent at: defining structure, judging value, asking questions. This approach plays to both strengths.

### Creates a Self-Reinforcing Knowledge Network
The wiki is structured and searchable. The outputs are question-based and reusable. Together they form a system that gets more valuable over time as connections emerge.

## Implementation

### Directory Structure
```bash
mkdir -p ~/second-brain/{raw,wiki,outputs}
```

### Schema File (CLAUDE.md)
Define how you want AI to organize your knowledge:
- Categories (tech, business, life, quotes)
- Metadata format (title, source, date, tags, related)
- Processing rules (extract 3 key points, tag properly, link related)
- INDEX.md structure

### Processing Workflow
When raw/ accumulates content, use this prompt:
```
Read everything in ~/second-brain/raw/. Then compile a wiki in ~/second-brain/wiki/ following the rules in CLAUDE.md. Create an INDEX.md first, then organize content into subdirectories.
```

### Regular Maintenance
- **Weekly**: Process raw/ content, update INDEX.md
- **Monthly**: Health check (review for contradictions, find gaps, suggest new articles)

## Common Pitfalls to Avoid

1. **Don't** pursue perfect taxonomy - categories evolve over time
2. **Don't** try to migrate all historical notes at once - start with new content
3. **Don't** think you need special software - any text editor works
4. **Don't** expect full automation - AI needs guidance via regular "compilation"

## Tools Mentioned

- **agent-browser** (Vercel Labs) - AI-controlled browser for automatic web scraping, allegedly 82% more token-efficient than Playwright MCP
- Standard tools: grep/rg for search, any markdown editor for writing

## Notes

This article is a meta-example - it's being processed into this very wiki using the system it describes. The key insight is that the system's simplicity is its strength. Each component does one thing well, and AI bridges the gaps.

The author's personal workflow:
1. See good content → dump into raw/
2. Every Sunday → AI compiles into wiki/
3. Have questions → query wiki, save answers to outputs/
4. Monthly → health check and schema optimization

Result: Near-zero collection friction, knowledge actually gets used.

## Related Concepts

- Zettelkasten (but simplified)
- Building a Second Brain (Tiago Forte) - but with AI instead of manual linking
- Andy Matuschak's evergreen notes - but with automated processing

## Action Items

- [ ] Set up directory structure
- [ ] Create CLAUDE.md schema
- [ ] Collect first batch of raw content
- [ ] Run first AI compilation
- [ ] Establish weekly processing habit
