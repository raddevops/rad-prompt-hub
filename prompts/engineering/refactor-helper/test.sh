#!/bin/bash

set -e

echo "Testing refactor-helper prompt..."

# Test that the file exists
PROMPT_FILE="/Users/robertdozier/workspace/rad-prompt-hub/prompts/engineering/refactor-helper/refactor-helper.json"
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
echo "🔧 Testing refactor planning functionality..."

# Validate experienced engineer role
if echo "$SYSTEM_CONTENT" | grep -q -i "experienced.*engineer\|refactor"; then
    echo "✅ Experienced engineer refactoring role specified"
else
    echo "❌ Missing experienced engineer role specification"
    exit 1
fi

# Validate safe and incremental approach
if echo "$SYSTEM_CONTENT" | grep -q -i "safe.*incremental\|incremental.*refactor"; then
    echo "✅ Safe and incremental refactoring approach specified"
else
    echo "❌ Missing safe incremental approach"
    exit 1
fi

# Validate behavior preservation focus
if echo "$SYSTEM_CONTENT" | grep -q -i "maintain.*behavior\|externally.*observable.*behavior"; then
    echo "✅ Behavior preservation focus specified"
else
    echo "❌ Missing behavior preservation focus"
    exit 1
fi

echo ""
echo "📋 Testing refactor structure validation..."

# Validate required output sections
REQUIRED_SECTIONS=("Pain Points" "Strategies" "Refactor Plan" "Acceptance Criteria")
MISSING_SECTIONS=()
for section in "${REQUIRED_SECTIONS[@]}"; do
    if echo "$USER_CONTENT" | grep -q -i "$section"; then
        echo "✅ Output section specified: $section"
    else
        MISSING_SECTIONS+=("$section")
    fi
done

if [ ${#MISSING_SECTIONS[@]} -gt 0 ]; then
    echo "❌ Missing required sections: ${MISSING_SECTIONS[*]}"
    exit 1
fi

# Validate effort tagging system
if echo "$USER_CONTENT" | grep -q -i "effort.*tags.*LOW.*MED.*HIGH\|LOW/MED/HIGH"; then
    echo "✅ Effort tagging system (LOW/MED/HIGH) specified"
else
    echo "❌ Missing effort tagging system"
    exit 1
fi

# Validate risk assessment inclusion
if echo "$USER_CONTENT" | grep -q -i "risk.*included.*per.*strategy"; then
    echo "✅ Risk assessment per strategy specified"
else
    echo "❌ Missing risk assessment requirements"
    exit 1
fi

echo ""
echo "🎯 Testing refactoring methodology..."

# Validate surgical improvement focus
if echo "$SYSTEM_CONTENT" | grep -q -i "surgical.*improvement\|no.*large.*rewrite"; then
    echo "✅ Surgical improvement focus (no large rewrites) specified"
else
    echo "❌ Missing surgical improvement focus"
    exit 1
fi

# Validate strategy conciseness requirement
if echo "$SYSTEM_CONTENT" | grep -q -i "≤.*40.*word\|strategies.*≤.*40"; then
    echo "✅ Strategy conciseness requirement (≤40 words) specified"
else
    echo "❌ Missing strategy conciseness requirement"
    exit 1
fi

# Validate minimal value detection
if echo "$USER_CONTENT" | grep -q -i "minimal.*refactor.*value\|no.*meaningful.*improvement"; then
    echo "✅ Minimal value detection handling specified"
else
    echo "❌ Missing minimal value detection"
    exit 1
fi

echo ""
echo "📝 Code analysis validation..."

# Validate code input handling
if echo "$SYSTEM_CONTENT" | grep -q -i "ask.*for.*code\|code.*if.*absent"; then
    echo "✅ Code input handling specified"
else
    echo "❌ Missing code input handling"
    exit 1
fi

# Validate defect detection capability
if echo "$SYSTEM_CONTENT" | grep -q -i "defect.*flag.*separately\|reveal.*defect"; then
    echo "✅ Defect detection and flagging capability specified"
else
    echo "❌ Missing defect detection capability"
    exit 1
fi

# Validate senior developer audience focus
if echo "$USER_CONTENT" | grep -q -i "senior.*dev\|implementation.*oriented"; then
    echo "✅ Senior developer audience and implementation focus specified"
else
    echo "❌ Missing senior developer audience focus"
    exit 1
fi

echo ""
echo "🔍 Quality and safety validation..."

# Validate reasoning effort appropriate for refactoring
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "medium" || "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for refactoring: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for complex refactoring: $REASONING_EFFORT"
    exit 1
fi

# Validate side-effects awareness
if echo "$SYSTEM_CONTENT" | grep -q -i "side.*effect\|hidden.*side"; then
    echo "✅ Side-effects awareness mentioned"
elif jq -r '.risks_or_notes[]' "$PROMPT_FILE" | grep -q -i "side.*effect"; then
    echo "✅ Side-effects awareness documented in risks"
else
    echo "❌ Missing side-effects awareness"
    exit 1
fi

# Validate structured output requirements
if echo "$USER_CONTENT" | grep -q -i "markdown.*specified.*section\|table"; then
    echo "✅ Structured output format requirements specified"
else
    echo "❌ Missing structured output format requirements"
    exit 1
fi

# Validate phased planning approach
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "phased.*plan\|step"; then
    echo "✅ Phased planning approach specified"
else
    echo "❌ Missing phased planning approach"
    exit 1
fi

echo ""
echo "✅ Refactor-helper prompt validation complete!"
echo "📊 Validated: JSON schema, safe refactoring methodology, structured planning, behavior preservation, risk assessment"