#!/bin/bash

set -e

echo "Testing acceptance-criteria prompt..."

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
echo "📝 Testing acceptance criteria functionality..."

# Validate product quality analyst role
if echo "$SYSTEM_CONTENT" | grep -q -i "product.*quality.*analyst\|acceptance.*criteria"; then
    echo "✅ Product quality analyst role specified"
else
    echo "❌ Missing product quality analyst role specification"
    exit 1
fi

# Validate testable criteria focus
if echo "$SYSTEM_CONTENT" | grep -q -i "clear.*testable.*acceptance.*criteria"; then
    echo "✅ Clear and testable acceptance criteria focus specified"
else
    echo "❌ Missing testable criteria focus"
    exit 1
fi

echo ""
echo "📋 Testing acceptance criteria structure validation..."

# Validate required output sections
REQUIRED_SECTIONS=("Criteria" "Mandatory" "Optional" "Edge Cases" "Traceability")
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

# Validate Gherkin format requirement
if echo "$USER_CONTENT" | grep -q -i "gherkin.*given.*when.*then"; then
    echo "✅ Gherkin format (Given/When/Then) requirement specified"
else
    echo "❌ Missing Gherkin format requirement"
    exit 1
fi

echo ""
echo "🎯 Quality methodology validation..."

# Validate atomic and non-overlapping scenarios
if echo "$SYSTEM_CONTENT" | grep -q -i "scenario.*atomic.*non.*overlapping"; then
    echo "✅ Atomic and non-overlapping scenarios requirement specified"
else
    echo "❌ Missing atomic scenarios requirement"
    exit 1
fi

# Validate edge case and negative testing labeling
if echo "$SYSTEM_CONTENT" | grep -q -i "label.*edge.*negative"; then
    echo "✅ Edge case and negative testing labeling specified"
else
    echo "❌ Missing edge case labeling requirement"
    exit 1
fi

# Validate mandatory vs optional separation
if echo "$SYSTEM_CONTENT" | grep -q -i "mandatory.*optional.*separated"; then
    echo "✅ Mandatory vs optional criteria separation specified"
else
    echo "❌ Missing mandatory/optional separation"
    exit 1
fi

echo ""
echo "📊 Traceability and transformation validation..."

# Validate traceability mapping
if echo "$SYSTEM_CONTENT" | grep -q -i "traceability.*mapping\|provide.*traceability.*table"; then
    echo "✅ Traceability mapping requirement specified"
else
    echo "❌ Missing traceability mapping requirement"
    exit 1
fi

# Validate story transformation capability
if echo "$SYSTEM_CONTENT" | grep -q -i "transform.*user.*story.*feature.*description"; then
    echo "✅ Story transformation capability specified"
else
    echo "❌ Missing story transformation capability"
    exit 1
fi

# Validate structured scenario output
if echo "$SYSTEM_CONTENT" | grep -q -i "structured.*gherkin.*scenario"; then
    echo "✅ Structured Gherkin scenarios specified"
else
    echo "❌ Missing structured scenarios requirement"
    exit 1
fi

echo ""
echo "🎯 Input validation and clarification..."

# Validate story clarification capability
if echo "$SYSTEM_CONTENT" | grep -q -i "ask.*clarification.*story.*absent"; then
    echo "✅ Story clarification capability specified"
else
    echo "❌ Missing story clarification capability"
    exit 1
fi

# Validate core story elements identification
if echo "$SYSTEM_CONTENT" | grep -q -i "actor.*trigger.*outcome"; then
    echo "✅ Core story elements (actor, trigger, outcome) specified"
else
    echo "❌ Missing core story elements identification"
    exit 1
fi

# Validate product and QA audience focus
if echo "$USER_CONTENT" | grep -q -i "product.*QA.*stakeholder.*precise.*verification"; then
    echo "✅ Product and QA stakeholder audience with verification focus specified"
else
    echo "❌ Missing product and QA audience specification"
    exit 1
fi

echo ""
echo "🔍 Quality assurance validation..."

# Validate reasoning effort appropriate for criteria generation
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "medium" || "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for criteria generation: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for quality analysis: $REASONING_EFFORT"
    exit 1
fi

# Validate ambiguous input handling
if echo "$SYSTEM_CONTENT" | grep -q -i "ambiguous.*input.*inferred.*scenario"; then
    echo "✅ Ambiguous input handling specified"
elif jq -r '.risks_or_notes[]' "$PROMPT_FILE" | grep -q -i "ambiguous.*input.*inferred"; then
    echo "✅ Ambiguous input risks documented"
else
    echo "❌ Missing ambiguous input handling"
    exit 1
fi

# Validate structured output format
if echo "$USER_CONTENT" | grep -q -i "markdown.*section.*specified"; then
    echo "✅ Structured output format requirements specified"
else
    echo "❌ Missing structured output format requirements"
    exit 1
fi

# Validate edge case coverage
if echo "$SYSTEM_CONTENT" | grep -q -i "edge.*case"; then
    echo "✅ Edge case coverage requirement specified"
else
    echo "❌ Missing edge case coverage requirement"
    exit 1
fi

echo ""
echo "✅ Acceptance-criteria prompt validation complete!"
echo "📊 Validated: JSON schema, quality analysis methodology, Gherkin format, traceability mapping, verification standards"