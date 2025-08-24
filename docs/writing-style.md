# Writing Style Guide

This guide establishes consistent tone, structure, and formatting conventions for all prompts in rad-prompt-hub.

## Core Principles

### Clarity Over Cleverness
Write prompts that are immediately understandable to both humans and LLMs. Avoid jargon, metaphors, or cultural references that might confuse AI models.

### Deterministic Language
Use precise, unambiguous instructions that produce consistent results across different LLM implementations.

### Actionable Instructions
Every prompt should specify exactly what the LLM should do, in what format, and with what constraints.

## Voice and Tone

### Professional but Accessible
- Use second person ("You are...", "Analyze the...")
- Avoid overly casual language or slang
- Write for an expert audience but explain domain-specific terms
- Balance authority with helpfulness

### Direct and Imperative
```markdown
✅ "Analyze the code for security vulnerabilities"
❌ "Could you please take a look at this code and maybe find some security issues?"

✅ "Return JSON with fields: summary, issues, recommendations"
❌ "It would be nice if you could format this as JSON"
```

### Consistent Persona Assignment
When assigning roles, be specific and professional:

```markdown
✅ "You are a senior software engineer performing a code review"
✅ "You are an experienced product manager drafting requirements"
❌ "You are a helpful assistant"
❌ "Pretend you're really good at coding"
```

## Structure Standards

### Section Order
All prompts must follow this exact structure:

1. **YAML Frontmatter** (metadata)
2. **Purpose** (2-5 sentences)
3. **Prompt** (main instruction text)
4. **Variables** (if applicable)
5. **Example** (if helpful)
6. **Notes** (optional guidance)

### Section Formatting

#### Purpose Section
- Start with active voice: "Provide...", "Generate...", "Analyze..."
- Include context: when and why to use this prompt
- Mention key constraints or scope limitations
- Keep to 2-5 sentences maximum

```markdown
## Purpose
Provide a structured, repeatable code review heuristic emphasizing clarity, safety, performance, and maintainability for production code changes.
```

#### Prompt Section
- Lead with role assignment: "You are a [specific role]"
- State the task clearly: "TASK: [imperative instruction]"
- List constraints numbered or bulleted
- Specify exact output format
- End with clarification request if needed

```markdown
## Prompt
You are a senior software engineer performing a code review.

TASK: Analyze the provided code changes for correctness and maintainability.

CONSTRAINTS:
1. Focus only on the submitted code (don't speculate)
2. Prioritize security and performance issues
3. Suggest specific improvements with rationale

OUTPUT FORMAT:
Return Markdown with sections: Summary, Issues, Recommendations

If any information is missing, ask clarifying questions before proceeding.
```

#### Variables Section
- List each `{{variable}}` used in the prompt
- Provide clear explanation of what to substitute
- Include expected format or type

```markdown
## Variables
- {{code_diff}}: Unified diff or code excerpt to review
- {{programming_language}}: Specific language context (optional)
```

## Language Conventions

### Instruction Verbs
Use strong, specific verbs:

| Preferred | Avoid |
|-----------|-------|
| Analyze | Look at |
| Generate | Create |
| Evaluate | Check |
| Summarize | Tell me about |
| Identify | Find |
| Validate | Make sure |

### Constraint Language
Be explicit about boundaries:

```markdown
✅ "Analyze ONLY the submitted code"
✅ "Return exactly 5 bullet points"
✅ "Use Markdown formatting with ### headings"

❌ "Look at the code"
❌ "Give me some points"  
❌ "Format it nicely"
```

### Output Specifications
Always specify exact format expectations:

```markdown
✅ "Return JSON with fields: title, summary, score"
✅ "Use Markdown with ### headings for each section"
✅ "Provide a numbered list of 3-7 items"

❌ "Format as JSON"
❌ "Use headings"
❌ "Make a list"
```

## Variable Naming

### Placeholder Format
Always use double curly braces: `{{variable_name}}`

### Naming Conventions
- Use `snake_case` for multi-word variables
- Be descriptive and specific
- Avoid abbreviations unless widely understood

```markdown
✅ {{code_snippet}}, {{user_story}}, {{target_audience}}
❌ {{code}}, {{story}}, {{audience}}
❌ {{cs}}, {{us}}, {{aud}}
```

### Common Variable Patterns
Establish consistency across prompts:

- `{{input_text}}`: Raw content to process
- `{{context}}`: Background or situational information  
- `{{requirements}}`: Specifications or constraints
- `{{format}}`: Output structure requirements
- `{{goal}}`: Specific objective or outcome

## Formatting Standards

### Lists and Enumerations
Use consistent list formatting:

```markdown
For instructions:
1. First step (numbered for sequence)
2. Second step
3. Third step

For constraints:
- Constraint one (bulleted for equal weight)
- Constraint two  
- Constraint three
```

### Code and Examples
Use proper Markdown code formatting:

```markdown
Inline code: `variable_name`, `function()`, `git commit`

Code blocks:
```python
def example_function():
    return "properly formatted"
```

Example input/output:
```
INPUT: user requirement text
OUTPUT: structured specification
```
```

### Emphasis and Highlighting
Use sparingly and consistently:

- **Bold** for key terms or section labels
- *Italic* for emphasis or variable names in text
- `Code` for technical terms, commands, filenames

## Domain-Specific Guidelines

### Engineering Prompts
- Reference specific technologies when relevant
- Use industry-standard terminology
- Include performance and security considerations
- Focus on maintainability and best practices

### Product Prompts  
- Use business language appropriate to stakeholders
- Include user-centered perspective
- Reference common frameworks (Agile, Lean, etc.)
- Balance technical and business considerations

### Writing Prompts
- Specify target audience and medium
- Include style and tone requirements
- Reference word count or length constraints
- Consider SEO and accessibility when relevant

### Research Prompts
- Use academic language appropriately
- Reference methodological standards
- Include data quality and bias considerations
- Specify evidence requirements and citation needs

## Quality Checklist

Before finalizing any prompt, verify:

- [ ] Role assignment is specific and professional
- [ ] Task instruction is clear and actionable
- [ ] Output format is explicitly specified
- [ ] Constraints are enumerated and unambiguous
- [ ] Variables are documented if used
- [ ] Language is direct and imperative
- [ ] No jargon without explanation
- [ ] Consistent with style guide conventions
- [ ] Under 500 words total

## Anti-Patterns to Avoid

### Vague Instructions
❌ "Help me improve this"
✅ "Refactor this function to improve readability and reduce complexity"

### Ambiguous Output
❌ "Give me feedback"
✅ "Return a structured report with sections: Strengths, Issues, Recommendations"

### Unnecessary Politeness
❌ "Could you please analyze this code if you don't mind?"
✅ "Analyze this code for security vulnerabilities"

### Multiple Responsibilities
❌ "Review the code, write documentation, and create tests"
✅ "Review the code for correctness and maintainability" (separate prompts for other tasks)

### Context Assumptions
❌ "Fix the obvious problems"
✅ "Identify syntax errors, logic bugs, and performance issues"

---

Following these conventions ensures our prompts are reliable, reusable, and effective across different LLM implementations and use cases.