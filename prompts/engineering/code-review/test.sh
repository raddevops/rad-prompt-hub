#!/bin/bash

# Test script for code-review prompt
# This script validates that the prompt performs structured code review functionality

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_NAME="$(basename "$SCRIPT_DIR")"

echo "Testing $PROMPT_NAME prompt..."

# Basic validation - check JSON structure
JSON_FILE="$SCRIPT_DIR/$PROMPT_NAME.json"
if [[ -f "$JSON_FILE" ]]; then
    echo "✅ JSON file exists: $JSON_FILE"
    
    # Validate JSON syntax
    if jq empty "$JSON_FILE" 2>/dev/null; then
        echo "✅ JSON syntax is valid"
        
        # Check required schema fields
        if jq -e '.target_model and .parameters.reasoning_effort and .messages' "$JSON_FILE" >/dev/null; then
            echo "✅ Required JSON schema fields present"
        else
            echo "❌ Missing required JSON schema fields"
            exit 1
        fi
        
        # Validate prompt-specific structure for code review
        if jq -e '.messages[] | select(.role == "system")' "$JSON_FILE" >/dev/null; then
            echo "✅ System message present"
        else
            echo "❌ Missing system message"
            exit 1
        fi
        
        if jq -e '.messages[] | select(.role == "user")' "$JSON_FILE" >/dev/null; then
            echo "✅ User message template present"
        else
            echo "❌ Missing user message template"
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

# Test core functionality expectations
echo ""
echo "🔍 Testing code review prompt functionality..."

# Check for code review specific content in system message
SYSTEM_CONTENT=$(jq -r '.messages[] | select(.role == "system") | .content' "$JSON_FILE")

# Validate code review sections are mentioned
if echo "$SYSTEM_CONTENT" | grep -q -i "summary\|strengths\|issues\|recommendations"; then
    echo "✅ Code review output sections specified"
else
    echo "❌ Missing code review output sections"
    exit 1
fi

# Check for guardrails
if echo "$SYSTEM_CONTENT" | grep -q -i "no speculative\|no chain-of-thought\|actionable"; then
    echo "✅ Code review guardrails present"
else
    echo "❌ Missing code review guardrails"
    exit 1
fi

# Check reasoning effort is appropriate for code review
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort' "$JSON_FILE")
if [[ "$REASONING_EFFORT" == "medium" || "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort: $REASONING_EFFORT"
else
    echo "⚠️  Reasoning effort may be too low for thorough code review: $REASONING_EFFORT"
fi

# Test variable placeholder structure
USER_CONTENT=$(jq -r '.messages[] | select(.role == "user") | .content' "$JSON_FILE")
if echo "$USER_CONTENT" | grep -q "DIFF\|diff\|code"; then
    echo "✅ Code/diff input placeholder found"
else
    echo "❌ Missing code/diff input placeholder"
    exit 1
fi

# Validate output contract mentions required sections
if echo "$USER_CONTENT" | grep -q -i "summary\|strengths\|issues\|recommendations\|risk"; then
    echo "✅ Required output sections specified in user message"
else
    echo "❌ Output sections not clearly specified"
    exit 1
fi

echo ""
echo "🧪 Advanced validation..."

# Check for risk assessment mention
if echo "$SYSTEM_CONTENT" | grep -q -i "risk\|security\|performance"; then
    echo "✅ Risk assessment capability present"
else
    echo "⚠️  Risk assessment not explicitly mentioned"
fi

# Validate conciseness requirements
if echo "$SYSTEM_CONTENT" | grep -q -i "concise\|specific\|brief"; then
    echo "✅ Conciseness requirements specified"
else
    echo "⚠️  Conciseness not explicitly required"
fi

echo ""
echo "✅ Code review prompt validation complete!"
echo "📊 Validated: JSON schema, code review sections, guardrails, placeholders, risk assessment"

exit 0