#!/bin/bash

# Test script for documentation-validator prompt
# Validates JSON structure, required fields, and functionality

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/documentation-validator.json"

echo "🔍 Testing Documentation Validator Prompt..."
echo "======================================================"

# Check if prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo "❌ Prompt file not found: $PROMPT_FILE"
    exit 1
fi

echo "✅ Prompt file exists: $PROMPT_FILE"

# Validate JSON syntax
if ! jq . "$PROMPT_FILE" > /dev/null 2>&1; then
    echo "❌ Invalid JSON syntax"
    exit 1
fi

echo "✅ Valid JSON syntax"

# Extract content for validation
SYSTEM_CONTENT=$(jq -r '.messages[0].content // empty' "$PROMPT_FILE")
USER_CONTENT=$(jq -r '.messages[1].content // empty' "$PROMPT_FILE")

echo ""
echo "📋 Schema validation..."

# Validate required fields
REQUIRED_FIELDS=("name" "target_model" "parameters" "messages")
for field in "${REQUIRED_FIELDS[@]}"; do
    if jq -e ".$field" "$PROMPT_FILE" > /dev/null; then
        echo "✅ Required field present: $field"
    else
        echo "❌ Missing required field: $field"
        exit 1
    fi
done

# Validate parameters
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
VERBOSITY=$(jq -r '.parameters.verbosity // "not_specified"' "$PROMPT_FILE")

if [[ "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for validation analysis: $REASONING_EFFORT"
    exit 1
fi

if [[ "$VERBOSITY" == "medium" ]]; then
    echo "✅ Appropriate verbosity for validation reports: $VERBOSITY"
else
    echo "❌ Suboptimal verbosity for detailed validation reports: $VERBOSITY"
    exit 1
fi

echo ""
echo "🎯 Role and functionality validation..."

# Validate role specification
if echo "$SYSTEM_CONTENT" | grep -q -i "documentation.*validator"; then
    echo "✅ Documentation Validator role specified"
else
    echo "❌ Missing Documentation Validator role"
    exit 1
fi

# Validate core capabilities
if echo "$SYSTEM_CONTENT" | grep -q -i "json.*markdown.*consistency"; then
    echo "✅ JSON ↔ markdown consistency validation specified"
else
    echo "❌ Missing core consistency validation capability"
    exit 1
fi

# Validate validation framework
if echo "$SYSTEM_CONTENT" | grep -q -i "validation.*framework"; then
    echo "✅ Structured validation framework specified"
else
    echo "❌ Missing validation framework"
    exit 1
fi

# Validate output structure requirements
if echo "$SYSTEM_CONTENT" | grep -q -i "validation.*report.*format"; then
    echo "✅ Structured report format specified"
else
    echo "❌ Missing report format specification"
    exit 1
fi

echo ""
echo "📋 Input template validation..."

# Validate input template sections
INPUT_SECTIONS=("PROMPT_FOLDER_PATH" "JSON_CONTENT" "MARKDOWN_CONTENT" "VALIDATION_FOCUS" "QUALITY_STANDARDS")
MISSING_INPUT_SECTIONS=()
for section in "${INPUT_SECTIONS[@]}"; do
    if echo "$USER_CONTENT" | grep -q "$section"; then
        echo "✅ Input template section: $section"
    else
        MISSING_INPUT_SECTIONS+=("$section")
    fi
done

if [ ${#MISSING_INPUT_SECTIONS[@]} -gt 0 ]; then
    echo "❌ Missing input template sections: ${MISSING_INPUT_SECTIONS[*]}"
    exit 1
fi

# Validate required vs optional sections
if echo "$USER_CONTENT" | grep -q -i "optional"; then
    echo "✅ Optional sections marked appropriately"
else
    echo "❌ Missing optional section markings"
    exit 1
fi

echo ""
echo "🔍 Validation scope verification..."

# Validate comprehensive analysis approach
if echo "$SYSTEM_CONTENT" | grep -q -i "comprehensive.*analysis"; then
    echo "✅ Comprehensive analysis approach specified"
else
    echo "❌ Missing comprehensive analysis requirement"
    exit 1
fi

# Validate gap identification capability
if echo "$SYSTEM_CONTENT" | grep -q -i "gap.*analysis\\|missing.*element"; then
    echo "✅ Gap identification capability specified"
else
    echo "❌ Missing gap identification capability"
    exit 1
fi

# Validate remediation guidance
if echo "$SYSTEM_CONTENT" | grep -q -i "remediation.*plan\\|actionable.*improvement"; then
    echo "✅ Remediation guidance capability specified"
else
    echo "❌ Missing remediation guidance capability"
    exit 1
fi

# Validate DRY principles check
if echo "$SYSTEM_CONTENT" | grep -q -i "dry.*principle\\|executable.*content.*duplication"; then
    echo "✅ DRY principles validation specified"
else
    echo "❌ Missing DRY principles validation"
    exit 1
fi

echo ""
echo "📊 Quality assurance validation..."

# Validate quality scoring capability
if echo "$SYSTEM_CONTENT" | grep -q -i "quality.*score\\|quantitative.*assessment"; then
    echo "✅ Quality scoring capability specified"
else
    echo "❌ Missing quality scoring capability"
    exit 1
fi

# Validate input variables documentation
INPUT_VARS=$(jq -r '.input_variables // {} | keys[]' "$PROMPT_FILE" 2>/dev/null || echo "")
if [ -n "$INPUT_VARS" ]; then
    echo "✅ Input variables documented"
else
    echo "❌ Missing input variables documentation"
    exit 1
fi

# Validate assumptions presence
ASSUMPTIONS=$(jq -r '.assumptions // [] | length' "$PROMPT_FILE")
if [ "$ASSUMPTIONS" -gt 0 ]; then
    echo "✅ Assumptions documented ($ASSUMPTIONS items)"
else
    echo "❌ Missing assumptions documentation"
    exit 1
fi

# Validate risks documentation
RISKS=$(jq -r '.risks_or_notes // [] | length' "$PROMPT_FILE")
if [ "$RISKS" -gt 0 ]; then
    echo "✅ Risks and limitations documented ($RISKS items)"
else
    echo "❌ Missing risks documentation"
    exit 1
fi

echo ""
echo "🎉 All tests passed! Documentation Validator prompt is valid and functional."
echo ""