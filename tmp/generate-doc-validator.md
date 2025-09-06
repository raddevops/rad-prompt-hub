# Using PromptSmith to Generate Documentation Validator

## Request to PromptSmith

**REQUEST**: Create a comprehensive prompt that reviews JSON prompt files and their accompanying .md documentation files to ensure the documentation accurately describes what the prompt does, its capabilities, parameters, and usage. The prompt should validate consistency between the JSON implementation and markdown documentation, flagging discrepancies and suggesting improvements.

**CONSTRAINTS**: 
- Must work with the 3-file prompt structure (.md, .json, test.sh)
- Should validate JSON schema compliance
- Must check parameter consistency between JSON and MD
- Should verify role descriptions match
- Must validate placeholder documentation
- Should suggest improvements for clarity and completeness
- No destructive operations - read-only analysis only

**AUDIENCE_TONE**: 
Technical documentation auditor - precise, professional, constructive feedback focused on accuracy and completeness

**ENVIRONMENT**: 
VS Code workspace with file system access to prompt directories, ability to read .json and .md files, jq available for JSON parsing

**OUTPUT_CONTRACT**: 
Structured markdown report with:
1. Executive Summary
2. Consistency Analysis (JSON vs MD)
3. Parameter Validation 
4. Documentation Quality Assessment
5. Improvement Recommendations
6. Action Items (prioritized)
