#!/bin/bash

# Test script for user-story prompt
# This script validates that the prompt generates canonical user stories with INVEST principles

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_NAME="$(basename "$SCRIPT_DIR")"

echo "Testing $PROMPT_NAME prompt..."

# Basic validation - check JSON structure
JSON_FILE="$SCRIPT_DIR/$PROMPT_NAME.json"
if [[ -f "$JSON_FILE" ]]; then
    echo "✅ JSON file exists: $JSON_FILE"
    
    # Validate JSON syntax and schema
    if jq empty "$JSON_FILE" 2>/dev/null; then
        echo "✅ JSON syntax is valid"
        
        if jq -e '.target_model and .parameters.reasoning_effort and .messages' "$JSON_FILE" >/dev/null; then
            echo "✅ Required JSON schema fields present"
        else
            echo "❌ Missing required JSON schema fields"
            exit 1
        fi
    else
        echo "❌ Invalid JSON syntax"
        exit 1
    fi
else
    echo "❌ JSON file not found"
    exit 1
fi

echo ""
echo "🔍 Testing user story prompt functionality..."

# Check system message for user story specific content
SYSTEM_CONTENT=$(jq -r '.messages[] | select(.role == "system") | .content' "$JSON_FILE")

# Validate canonical user story format is specified
if echo "$SYSTEM_CONTENT" | grep -q "As a.*I want.*so that\|role.*capability.*benefit"; then
    echo "✅ Canonical user story format specified"
else
    echo "❌ Missing canonical user story format (As a... I want... so that...)"
    exit 1
fi

# Check for required output sections
if echo "$SYSTEM_CONTENT" | grep -q -i "rationale\|acceptance.*criteria\|dependencies\|estimation"; then
    echo "✅ Required user story sections specified"
else
    echo "❌ Missing required user story output sections"
    exit 1
fi

# Validate acceptance criteria mention
if echo "$SYSTEM_CONTENT" | grep -q -i "gherkin\|given.*when.*then\|atomic"; then
    echo "✅ Gherkin acceptance criteria format specified"
else
    echo "❌ Missing Gherkin acceptance criteria specification"
    exit 1
fi

# Check user message template
USER_CONTENT=$(jq -r '.messages[] | select(.role == "user") | .content' "$JSON_FILE")

# Validate input placeholder
if echo "$USER_CONTENT" | grep -q -i "feature.*description\|feature.*summary\|story"; then
    echo "✅ Feature description input placeholder found"
else
    echo "❌ Missing feature description input"
    exit 1
fi

# Check for comprehensive output sections
REQUIRED_SECTIONS=("User Story" "Rationale" "Acceptance Criteria" "Dependencies" "Estimation")
MISSING_SECTIONS=()

for section in "${REQUIRED_SECTIONS[@]}"; do
    if echo "$USER_CONTENT" | grep -q -i "$section"; then
        echo "✅ Output section specified: $section"
    else
        MISSING_SECTIONS+=("$section")
    fi
done

if [[ ${#MISSING_SECTIONS[@]} -gt 0 ]]; then
    echo "⚠️  Missing output sections: ${MISSING_SECTIONS[*]}"
fi

echo ""
echo "🧪 INVEST principles validation..."

# Check for INVEST principle alignment
if echo "$SYSTEM_CONTENT" | grep -q -i "atomic\|independent\|negotiable\|estimat\|small\|testable"; then
    echo "✅ INVEST principles referenced"
else
    echo "⚠️  INVEST principles not explicitly mentioned"
fi

# Validate role specification
if echo "$SYSTEM_CONTENT" | grep -q -i "role\|actor\|persona\|user"; then
    echo "✅ User role specification mentioned"
else
    echo "❌ Missing user role specification"
    exit 1
fi

# Check reasoning effort for product work
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort' "$JSON_FILE")
if [[ "$REASONING_EFFORT" == "medium" ]]; then
    echo "✅ Appropriate reasoning effort for user story work: $REASONING_EFFORT"
else
    echo "⚠️  Reasoning effort unexpected for user story: $REASONING_EFFORT"
fi

echo ""
echo "🎯 Agile methodology validation..."

# Check for agile-specific content
if echo "$SYSTEM_CONTENT" | grep -q -i "sprint\|backlog\|agile\|scrum"; then
    echo "✅ Agile methodology awareness present"
else
    echo "⚠️  Agile methodology not explicitly referenced"
fi

# Validate estimation factors
if echo "$SYSTEM_CONTENT" | grep -q -i "complexity\|effort\|size\|point"; then
    echo "✅ Estimation factors mentioned"
else
    echo "⚠️  Estimation factors not specified"
fi

echo ""
echo "✅ User story prompt validation complete!"
echo "📊 Validated: JSON schema, canonical format, INVEST principles, output sections, agile methodology"

exit 0