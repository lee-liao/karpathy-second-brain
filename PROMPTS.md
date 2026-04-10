# Second Brain Workflow Prompts

Copy and paste these prompts when working with your second brain.

## Collection Workflows

### Collect a Web Article

```
Please fetch this URL and save it to my raw directory:

URL: [paste URL here]

Use the web reader MCP to convert it to markdown. Save it as:
[domain]-[descriptive-slug]-[YYYY-MM-DD].md

in /home/lee/second-brain/raw/[domain]/
```

### Process Manual Notes

```
I have some notes to add to my raw directory. Please create a file at:

/home/lee/second-brain/raw/personal/[topic]-[YYYY-MM-DD].md

With this content:
[paste notes here]
```

## Processing Workflows

### Process All Raw Content (Main Workflow)

```
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
```

### Process Specific Category

```
Please process only [tech/business/life/quotes] content from my raw directory.

Follow the standard processing workflow in CLAUDE.md but only handle content that belongs to the [category] category.
```

## Search & Discovery Workflows

### Search by Topic

```
Search my knowledge base for information about [topic].

Please:
1. Search across /home/lee/second-brain/wiki/ for mentions of [topic]
2. Show me the most relevant articles with context
3. Summarize what my knowledge base says about [topic]
4. Suggest related topics I might want to explore
```

### Search by Tag

```
Show me all articles in my knowledge base tagged with #[tag].

Please list them with brief descriptions and highlight connections between them.
```

### Find Related Content

```
I'm reading about [current topic]. Please:

1. Find related articles in my knowledge base
2. Identify connections I might have missed
3. Suggest gaps where I should collect more information
```

## Q&A Workflows

### Ask a Question

```
Based on my knowledge base in /home/lee/second-brain/wiki/, please answer this question:

[Your question here]

Please:
1. Search for relevant information
2. Cite specific articles when referencing them
3. Synthesize an answer based on what I've collected
4. Save your response to /home/lee/second-brain/outputs/[topic]-qa-[YYYY-MM-DD].md
```

### Generate Essay or Summary

```
Based on my knowledge base, please write a [brief/detailed] [essay/summary/guide] about [topic].

Please:
1. Pull relevant information from across my wiki
2. Organize it logically
3. Include citations to my source articles
4. Save the output to /home/lee/second-brain/outputs/[topic]-essay-[YYYY-MM-DD].md
```

## Maintenance Workflows

### Weekly Review

```
Please run a weekly review of my knowledge base.

1. Show me what's new since [last review date]
2. Identify connections between new and existing content
3. Flag any contradictions or outdated information
4. Suggest themes or patterns I'm exploring
5. Recommend topics where I should collect more

Update the INDEX.md when done.
```

### Monthly Health Check

```
Please run a monthly health check of my second brain.

1. Review entire wiki/ structure
2. Identify outdated information
3. Find contradictions or confusion points
4. Suggest schema improvements (new categories, tag cleanup)
5. Recommend content gaps to fill
6. Check for duplicate or redundant entries

Provide a summary report with action items.
```

### Clean Up Raw Directory

```
Please help me clean up my raw directory.

1. List all files in /home/lee/second-brain/raw/
2. For each file, ask if I want to:
   - Process it into wiki
   - Delete it (low quality, not useful)
   - Keep for later
3. Move processed files to raw/processed/ subdirectory
```

## Automation Workflows

### Batch Process Multiple URLs

```
Please process these URLs and save them to raw:

URL 1: [url]
URL 2: [url]
URL 3: [url]

For each URL:
1. Fetch using web reader MCP
2. Save to appropriate raw/ subdirectory
3. Report when done

Don't process into wiki yet - just collect to raw.
```

### Update Index Only

```
Please regenerate my wiki index at /home/lee/second-brain/wiki/INDEX.md

Scan the wiki/ directory and create a complete index with:
- Statistics (total articles, by category)
- Recent additions
- All articles organized by category
- Tag index

Follow the INDEX.md structure in CLAUDE.md.
```

## Troubleshooting

### "I can't find anything about [topic]"

```
Please do a comprehensive search for [topic] across my entire second brain.

1. Search wiki/ directory
2. Search outputs/ directory
3. If nothing found, check if I have related content in raw/
4. If nothing exists, suggest what I should collect to learn about [topic]
```

### "Help me discover what I know about [category]"

```
Please give me an overview of everything I know about [tech/business/life].

1. List all articles in that category
2. Identify themes and patterns
3. Show me connections between articles
4. Highlight gaps where I should collect more
5. Suggest questions I should ask based on what I have
```

### "I want to revisit something I read about [topic]"

```
I remember reading about [topic] but can't find it. Please:

1. Search for any mentions of [topic]
2. Also search for related terms and synonyms
3. Show me the most likely matches
4. If we find it, summarize what it said
```

## Tips

- **Be specific** - More specific prompts get better results
- **Iterate** - Start broad, then narrow down
- **Save outputs** - Good Q&A sessions should be saved to outputs/
- **Process regularly** - Don't let raw/ pile up too much
- **Review connections** - The value is in linking ideas together
