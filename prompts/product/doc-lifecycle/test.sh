#!/bin/bash

set -e

echo "Testing doc-lifecycle prompt..."

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
    echo "❌ JSON file is not valid JSON: $PROMPT_FILE"
    exit 1
fi
echo "✅ JSON file is valid JSON"

# Test required fields
echo "Testing required JSON structure..."

# Test name field
NAME=$(jq -r '.name // empty' "$PROMPT_FILE")
if [ -z "$NAME" ]; then
    echo "❌ Missing required field: name"
    exit 1
fi
echo "✅ Has name: $NAME"

# Test version field
VERSION=$(jq -r '.version // empty' "$PROMPT_FILE")
if [ -z "$VERSION" ]; then
    echo "❌ Missing required field: version"
    exit 1
fi
echo "✅ Has version: $VERSION"

# Test messages array
MESSAGES_COUNT=$(jq '.messages | length' "$PROMPT_FILE")
if [ "$MESSAGES_COUNT" -eq 0 ]; then
    echo "❌ Messages array is empty"
    exit 1
fi
echo "✅ Has $MESSAGES_COUNT messages"

# Test system message exists
SYSTEM_MSG=$(jq -r '.messages[0].role // empty' "$PROMPT_FILE")
if [ "$SYSTEM_MSG" != "system" ]; then
    echo "❌ First message should be system role"
    exit 1
fi
echo "✅ Has system message"

# Test user message exists
USER_MSG=$(jq -r '.messages[1].role // empty' "$PROMPT_FILE")
if [ "$USER_MSG" != "user" ]; then
    echo "❌ Second message should be user role"
    exit 1
fi
echo "✅ Has user message"

# Test model field
MODEL=$(jq -r '.model // empty' "$PROMPT_FILE")
if [ -z "$MODEL" ]; then
    echo "❌ Missing required field: model"
    exit 1
fi
echo "✅ Has model: $MODEL"

# Test parameters exist
PARAMS=$(jq '.parameters // empty' "$PROMPT_FILE")
if [ -z "$PARAMS" ] || [ "$PARAMS" = "null" ]; then
    echo "❌ Missing parameters object"
    exit 1
fi
echo "✅ Has parameters object"

# Test documentation-specific content
echo "Testing doc-lifecycle specific content..."

# Check for Diátaxis framework mentions
SYSTEM_CONTENT=$(jq -r '.messages[0].content' "$PROMPT_FILE")
if [[ ! "$SYSTEM_CONTENT" =~ "Diátaxis" ]]; then
    echo "❌ System message should mention Diátaxis framework"
    exit 1
fi
echo "✅ References Diátaxis framework"

# Check for lifecycle types
if [[ ! "$SYSTEM_CONTENT" =~ "prd" ]] || [[ ! "$SYSTEM_CONTENT" =~ "adr" ]] || [[ ! "$SYSTEM_CONTENT" =~ "runbook" ]]; then
    echo "❌ System message should mention lifecycle document types (prd, adr, runbook, etc.)"
    exit 1
fi
echo "✅ References lifecycle document types"

# Check for documentation types
if [[ ! "$SYSTEM_CONTENT" =~ "tutorial" ]] || [[ ! "$SYSTEM_CONTENT" =~ "how-to" ]] || [[ ! "$SYSTEM_CONTENT" =~ "reference" ]] || [[ ! "$SYSTEM_CONTENT" =~ "explanation" ]]; then
    echo "❌ System message should mention all four Diátaxis types"
    exit 1
fi
echo "✅ References all Diátaxis documentation types"

# Check user message has required placeholders
USER_CONTENT=$(jq -r '.messages[1].content' "$PROMPT_FILE")
if [[ ! "$USER_CONTENT" =~ "{{DOC_ROOT_OR_URL}}" ]]; then
    echo "❌ User message should contain {{DOC_ROOT_OR_URL}} placeholder"
    exit 1
fi
echo "✅ Has DOC_ROOT_OR_URL placeholder"

if [[ ! "$USER_CONTENT" =~ "{{GLOBS_EG" ]]; then
    echo "❌ User message should contain file pattern placeholders"
    exit 1
fi
echo "✅ Has file pattern placeholders"

# Check for JSON output specification
if [[ ! "$USER_CONTENT" =~ "return exactly this JSON" ]]; then
    echo "❌ User message should specify JSON output format"
    exit 1
fi
echo "✅ Specifies JSON output format"

# Test parameters are appropriate for documentation analysis
TEMP=$(jq -r '.parameters.temperature // empty' "$PROMPT_FILE")
if [ -n "$TEMP" ]; then
    # Temperature should be low for consistent analysis
    TEMP_FLOAT=$(echo "$TEMP" | bc -l 2>/dev/null || echo "0.5")
    if (( $(echo "$TEMP_FLOAT > 0.3" | bc -l 2>/dev/null || echo "1") )); then
        echo "⚠️  Temperature $TEMP might be high for documentation analysis (consider ≤0.3)"
    else
        echo "✅ Temperature $TEMP is appropriate for consistent analysis"
    fi
fi

REASONING=$(jq -r '.parameters.reasoning_effort // empty' "$PROMPT_FILE")
if [ -n "$REASONING" ] && [ "$REASONING" != "null" ]; then
    echo "✅ Has reasoning_effort: $REASONING"
fi

VERBOSITY=$(jq -r '.parameters.verbosity // empty' "$PROMPT_FILE")
if [ -n "$VERBOSITY" ] && [ "$VERBOSITY" != "null" ]; then
    echo "✅ Has verbosity: $VERBOSITY"
fi

echo ""
echo "🎉 All tests passed for doc-lifecycle prompt!"
echo "📁 Prompt file: $PROMPT_FILE"
echo "📝 Name: $NAME"
echo "🔢 Version: $VERSION"
echo "🤖 Model: $MODEL"
echo "💬 Messages: $MESSAGES_COUNT"