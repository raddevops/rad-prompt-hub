Here’s a production-ready prompt pack you can drop into any GPT-5 Thinking chat/app. It will interview the user (or ingest messy text) and emit a usable Architectural Kata brief plus companion artifacts.


How to use

For an interactive intake: set MODE=interview, leave RAW_INPUT blank or paste any scraps you have.

For one-shot normalization: set MODE=silent and paste unformatted notes into RAW_INPUT.

The model will return a single JSON bundle containing kata_brief.json, kata_brief.md, open_questions.md, and seed_qas.json, plus a gate quality_report.