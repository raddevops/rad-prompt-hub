#!/bin/bash

# Test script for kata-briefsmith prompt
# Validates JSON structure, required fields, and functionality

set -e

echo "🔍 Testing Kata Briefsmith Prompt..."
echo "======================================================"

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_NAME="$(basename "$SCRIPT_DIR")"

# Test that the file exists
PROMPT_FILE="$SCRIPT_DIR/$PROMPT_NAME.json"
if [ ! -f "$PROMPT_FILE" ]; then
    echo "❌ JSON file does not exist: $PROMPT_FILE"
    exit 1
fi
echo "✅ JSON file exists: $PROMPT_FILE"

# Test that the JSON is valid
if ! jq empty "$PROMPT_FILE" 2>/dev/null; then
    echo "❌ JSON syntax is invalid"
    exit 1
fi
echo "✅ JSON syntax is valid"

echo ""
echo "📋 Schema validation..."

# Run repository schema validation
python3 "$(git rev-parse --show-toplevel)/scripts/schema_validate_prompts.py" "$PROMPT_FILE"
echo "✅ Schema validation passed"

# Extract content for validation
SYSTEM_CONTENT=$(jq -r '.messages[] | select(.role == "system") | .content' "$PROMPT_FILE")
USER_CONTENT=$(jq -r '.messages[] | select(.role == "user") | .content' "$PROMPT_FILE")

echo ""
echo "🎯 Content validation..."

# Validate target model
TARGET_MODEL=$(jq -r '.target_model // "not_specified"' "$PROMPT_FILE")
if [[ "$TARGET_MODEL" == "gpt-5-thinking" ]]; then
    echo "✅ Appropriate target model: $TARGET_MODEL"
else
    echo "❌ Inappropriate target model: $TARGET_MODEL"
    exit 1
fi

# Validate parameters
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
VERBOSITY=$(jq -r '.parameters.verbosity // "not_specified"' "$PROMPT_FILE")

if [[ "$REASONING_EFFORT" == "medium" ]]; then
    echo "✅ Appropriate reasoning effort for briefing: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort: $REASONING_EFFORT"
    exit 1
fi

if [[ "$VERBOSITY" == "low" ]]; then
    echo "✅ Appropriate verbosity for concise output: $VERBOSITY"
else
    echo "❌ Inappropriate verbosity: $VERBOSITY"
    exit 1
fi

echo ""
echo "🏗️ Functionality validation..."

# Validate Briefsmith role
if echo "$SYSTEM_CONTENT" | grep -q -i "briefsmith"; then
    echo "✅ Briefsmith role defined"
else
    echo "❌ Missing Briefsmith role definition"
    exit 1
fi

# Validate interview mode capability
if echo "$USER_CONTENT" | grep -q "MODE=.*interview"; then
    echo "✅ Interview mode supported"
else
    echo "❌ Missing interview mode capability"
    exit 1
fi

# Validate silent mode capability
if echo "$USER_CONTENT" | grep -q "MODE=.*silent"; then
    echo "✅ Silent mode supported"
else
    echo "❌ Missing silent mode capability"
    exit 1
fi

# Validate required output components
REQUIRED_OUTPUTS=("kata_brief.json" "kata_brief.md" "open_questions.md" "seed_qas.json" "quality_report")
for output in "${REQUIRED_OUTPUTS[@]}"; do
    if echo "$USER_CONTENT" | grep -q "$output"; then
        echo "✅ Required output specified: $output"
    else
        echo "❌ Missing required output: $output"
        exit 1
    fi
done

# Validate JSON output format
if echo "$USER_CONTENT" | grep -q -i "single JSON object"; then
    echo "✅ JSON output format specified"
else
    echo "❌ Missing JSON output format specification"
    exit 1
fi

# Validate question limitation for interview mode
if echo "$USER_CONTENT" | grep -q "8.*questions"; then
    echo "✅ Question limitation specified"
else
    echo "❌ Missing question limitation for interview mode"
    exit 1
fi

echo ""
echo "📝 Architectural kata validation..."

# Validate architectural kata concepts
KATA_CONCEPTS=("brief" "kata" "interview" "quality")
for concept in "${KATA_CONCEPTS[@]}"; do
    if echo "$SYSTEM_CONTENT$USER_CONTENT" | grep -q -i "$concept"; then
        echo "✅ Architectural concept present: $concept"
    else
        echo "❌ Missing architectural concept: $concept"
        exit 1
    fi
done

# Validate input processing
if echo "$USER_CONTENT" | grep -q "RAW_INPUT"; then
    echo "✅ Raw input processing capability"
else
    echo "❌ Missing raw input processing"
    exit 1
fi

echo ""
echo "⚡ Performance validation..."

# Check if minified (architectural prompts can be longer but should still be optimized)
LC=$(wc -l < "$PROMPT_FILE" | tr -d ' ')
if [[ "$LC" -le 10 ]]; then
    echo "✅ Well-optimized JSON structure ($LC lines)"
else
    echo "⚠️  Consider optimizing JSON structure ($LC lines)"
fi

echo ""
echo "🎉 All tests passed! Kata Briefsmith prompt is valid and functional."
echo ""