#!/bin/bash

set -e

echo "Testing promptsmith prompt..."

# Test that the file exists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/promptsmith.json"
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

# Extract content for validation
SYSTEM_CONTENT=$(jq -r '.messages[] | select(.role == "system") | .content' "$PROMPT_FILE")
USER_CONTENT=$(jq -r '.messages[] | select(.role == "user") | .content' "$PROMPT_FILE")

# Test required JSON schema fields
REQUIRED_FIELDS=("target_model" "parameters" "messages")
for field in "${REQUIRED_FIELDS[@]}"; do
    if ! jq -e ".$field" "$PROMPT_FILE" >/dev/null 2>&1; then
        echo "❌ Missing required field: $field"
        exit 1
    fi
done
echo "✅ Required JSON schema fields present"

echo ""
echo "🔧 Testing prompt engineering functionality..."

# Validate PromptSmith role and expertise
if echo "$SYSTEM_CONTENT" | grep -q -i "promptsmith\|prompt.*engineer"; then
    echo "✅ PromptSmith role and expertise specified"
else
    echo "❌ Missing PromptSmith role specification"
    exit 1
fi

# Validate production-grade focus
if echo "$SYSTEM_CONTENT" | grep -q -i "production.*grade\|production.*prompt"; then
    echo "✅ Production-grade focus specified"
else
    echo "❌ Missing production-grade focus"
    exit 1
fi

# Validate GPT-5 targeting
if echo "$SYSTEM_CONTENT" | grep -q -i "GPT-5\|gpt.*5"; then
    echo "✅ GPT-5 targeting specified"
else
    echo "❌ Missing GPT-5 targeting specification"
    exit 1
fi

echo ""
echo "📝 Prompt structure validation..."

# Validate required output components
REQUIRED_COMPONENTS=("system.*user.*messages" "parameters" "assumptions" "risks")
for component in "${REQUIRED_COMPONENTS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$component"; then
        echo "✅ Output component specified: $component"
    else
        echo "❌ Missing output component: $component"
        exit 1
    fi
done

# Validate placeholder format
if echo "$USER_CONTENT" | grep -q "{{.*}}"; then
    echo "✅ Proper placeholder format used ({{LIKE_THIS}})"
else
    echo "❌ Missing or incorrect placeholder format"
    exit 1
fi

# Validate structured workflow
if echo "$SYSTEM_CONTENT" | grep -q -i "workflow.*restate.*triage"; then
    echo "✅ Structured workflow specified"
else
    echo "❌ Missing structured workflow"
    exit 1
fi

echo ""
echo "🎯 Prompt engineering standards..."

# Validate contradiction prevention
if echo "$SYSTEM_CONTENT" | grep -q -i "contradiction.*free\|avoid.*contradiction"; then
    echo "✅ Contradiction prevention specified"
else
    echo "❌ Missing contradiction prevention"
    exit 1
fi

# Validate gating questions capability
if echo "$SYSTEM_CONTENT" | grep -q -i "questions.*yaml\|focused.*question"; then
    echo "✅ Gating questions capability specified"
else
    echo "❌ Missing gating questions capability"
    exit 1
fi

# Validate agent controls inclusion
if echo "$SYSTEM_CONTENT" | grep -q -i "agent.*controls\|tool_preambles"; then
    echo "✅ Agent controls framework specified"
else
    echo "❌ Missing agent controls framework"
    exit 1
fi

echo ""
echo "📋 Template structure validation..."

# Validate input template sections
INPUT_SECTIONS=("REQUEST" "CONSTRAINTS" "AUDIENCE_TONE" "ENVIRONMENT" "EXAMPLES" "OUTPUT_CONTRACT")
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

# Validate optional vs required sections handling
if echo "$USER_CONTENT" | grep -q -i "optional"; then
    echo "✅ Optional sections marked appropriately"
else
    echo "❌ Missing optional section markings"
    exit 1
fi

echo ""
echo "🔍 Quality assurance validation..."

# Validate reasoning effort appropriate for prompt engineering
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for prompt engineering: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for prompt engineering: $REASONING_EFFORT"
    exit 1
fi

# Validate self-checking requirements
if echo "$SYSTEM_CONTENT" | grep -q -i "self.*check\|self.*validate"; then
    echo "✅ Self-checking requirements specified"
else
    echo "❌ Missing self-checking requirements"
    exit 1
fi

# Validate assumption handling
if echo "$SYSTEM_CONTENT" | grep -q -i "assumption\|logged.*assumption"; then
    echo "✅ Assumption handling specified"
else
    echo "❌ Missing assumption handling"
    exit 1
fi

# Validate risk awareness
RISKS=$(jq -r '.risks_or_notes // [] | length' "$PROMPT_FILE")
if [[ "$RISKS" -gt 0 ]]; then
    echo "✅ Risk awareness documented"
else
    echo "❌ Missing risk documentation"
    exit 1
fi

echo ""
echo "✅ PromptSmith prompt validation complete!"
echo "📊 Validated: JSON schema, prompt engineering standards, template structure, quality assurance, GPT-5 optimization"