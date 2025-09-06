#!/bin/bash

set -e

echo "Testing executive-summary prompt..."

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
echo "📊 Testing executive summary prompt functionality..."

# Validate executive summary components
if echo "$SYSTEM_CONTENT" | grep -q -i "executive.*summary\|executive.*communications"; then
    echo "✅ Executive summary role specified"
else
    echo "❌ Missing executive summary role specification"
    exit 1
fi

# Validate required output sections
REQUIRED_SECTIONS=("Objective" "Key Findings" "Decisions" "Risks" "Next Steps" "Word Count")
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

echo ""
echo "📝 Executive communication validation..."

# Validate word count constraint
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "250.*word\|word.*cap\|word.*limit"; then
    echo "✅ Word count constraint specified"
else
    echo "❌ Missing word count constraint"
    exit 1
fi

# Validate executive audience focus
if echo "$USER_CONTENT" | grep -q -i "executive\|decision.*oriented"; then
    echo "✅ Executive audience focus specified"
else
    echo "❌ Missing executive audience specification"
    exit 1
fi

# Validate quantitative data prioritization
if echo "$SYSTEM_CONTENT" | grep -q -i "quant.*prioritized\|quantitative.*data"; then
    echo "✅ Quantitative data prioritization specified"
else
    echo "❌ Missing quantitative data prioritization"
    exit 1
fi

echo ""
echo "🎯 Content structure validation..."

# Validate conciseness requirements
if echo "$SYSTEM_CONTENT" | grep -q -i "concise\|≤.*word"; then
    echo "✅ Conciseness requirements specified"
else
    echo "❌ Missing conciseness requirements"
    exit 1
fi

# Validate source text input handling
if echo "$SYSTEM_CONTENT" | grep -q -i "source_text\|source.*text"; then
    echo "✅ Source text input handling found"
else
    echo "⚠️  Source text input handling not explicitly specified"
fi

# Validate decision-making focus
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "decision\|key finding"; then
    echo "✅ Decision-making focus specified"
else
    echo "❌ Missing decision-making focus"
    exit 1
fi

echo ""
echo "📈 Professional standards validation..."

# Validate reasoning effort appropriate for executive communication
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "medium" || "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for executive summary: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for executive communication: $REASONING_EFFORT"
    exit 1
fi

# Validate risk awareness
if echo "$SYSTEM_CONTENT" | grep -q -i "risk\|absence.*data\|qualitative.*only"; then
    echo "✅ Risk awareness and data limitations mentioned"
else
    echo "❌ Missing risk awareness for data limitations"
    exit 1
fi

# Validate professional tone requirements
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "jargon\|objective\|professional"; then
    echo "✅ Professional communication standards specified"
else
    echo "❌ Missing professional communication standards"
    exit 1
fi

echo ""
echo "✅ Executive summary prompt validation complete!"
echo "📊 Validated: JSON schema, executive communication standards, required sections, conciseness, quantitative focus"