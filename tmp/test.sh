#!/bin/bash

set -e

echo "Testing documentation-validator prompt..."

# Test that the file exists
# Allow override via environment variable or first argument, default to relative path
PROMPT_FILE="${PROMPT_FILE:-${1:-./tmp/documentation-validator.json}}"
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

# Test required JSON schema fields
REQUIRED_FIELDS=("target_model" "parameters" "messages")
for field in "${REQUIRED_FIELDS[@]}"; do
    if ! jq -e ".$field" "$PROMPT_FILE" >/dev/null 2>&1; then
        echo "❌ Missing required field: $field"
        exit 1
    fi
done
echo "✅ Required JSON schema fields present"

# Test that role mentions documentation auditor
SYSTEM_CONTENT=$(jq -r '.messages[] | select(.role == "system") | .content' "$PROMPT_FILE")
if echo "$SYSTEM_CONTENT" | grep -q -i "technical.*documentation.*auditor"; then
    echo "✅ Technical Documentation Auditor role specified"
else
    echo "❌ Missing documentation auditor role"
    exit 1
fi

# Test validation framework presence
if echo "$SYSTEM_CONTENT" | grep -q -i "validation.*framework"; then
    echo "✅ Validation framework specified"
else
    echo "❌ Missing validation framework"
    exit 1
fi

# Test required placeholders
USER_CONTENT=$(jq -r '.messages[] | select(.role == "user") | .content' "$PROMPT_FILE")
REQUIRED_PLACEHOLDERS=("PROMPT_DIRECTORY" "JSON_CONTENT" "MD_CONTENT")
for placeholder in "${REQUIRED_PLACEHOLDERS[@]}"; do
    if echo "$USER_CONTENT" | grep -q "{{${placeholder}}}"; then
        echo "✅ Required placeholder: {{${placeholder}}}"
    else
        echo "❌ Missing required placeholder: {{${placeholder}}}"
        exit 1
    fi
done

# Test output structure requirements
REQUIRED_SECTIONS=("executive summary" "consistency analysis" "parameter validation")
for section in "${REQUIRED_SECTIONS[@]}"; do
    if ! echo "$USER_CONTENT" | grep -qi "$section"; then
        echo "❌ Missing required section: $section"
        exit 1
    fi
done
echo "✅ Comprehensive output structure specified"

echo ""
echo "✅ Documentation-validator prompt validation complete!"
echo "📊 Ready to validate prompt documentation consistency and quality"
