#!/bin/bash

set -e

echo "Testing requirements-draft prompt..."

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
echo "📝 Testing requirements drafting functionality..."

# Validate product analyst role
if echo "$SYSTEM_CONTENT" | grep -q -i "product.*analyst\|requirements"; then
    echo "✅ Product analyst role specified"
else
    echo "❌ Missing product analyst role specification"
    exit 1
fi

# Validate structured requirements extraction focus
if echo "$SYSTEM_CONTENT" | grep -q -i "structured.*requirements.*raw.*notes"; then
    echo "✅ Structured requirements extraction from raw notes specified"
else
    echo "❌ Missing structured extraction focus"
    exit 1
fi

echo ""
echo "📋 Testing requirements structure validation..."

# Validate required output sections
REQUIRED_SECTIONS=("Goals" "Users" "Functional Requirements" "Non-Functional Requirements" "Assumptions" "Open Questions" "Risks")
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

# Validate functional requirements constraints
if echo "$SYSTEM_CONTENT" | grep -q -i "functional.*reqs.*≤.*10.*numbered.*testable"; then
    echo "✅ Functional requirements constraints (≤10, numbered, testable) specified"
else
    echo "❌ Missing functional requirements constraints"
    exit 1
fi

echo ""
echo "🎯 Product methodology validation..."

# Validate assumption marking system
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "mark.*inferred.*assumed\|inferred.*as.*assumed"; then
    echo "✅ Assumption marking system ((assumed)) specified"
else
    echo "❌ Missing assumption marking system"
    exit 1
fi

# Validate non-functional categorization
if echo "$SYSTEM_CONTENT" | grep -q -i "separate.*non.*functional.*categories"; then
    echo "✅ Non-functional requirements categorization specified"
else
    echo "❌ Missing non-functional categorization"
    exit 1
fi

# Validate clarification seeking for empty notes
if echo "$SYSTEM_CONTENT" | grep -q -i "ask.*clarification.*raw.*notes.*empty"; then
    echo "✅ Clarification seeking for empty notes specified"
else
    echo "❌ Missing clarification seeking capability"
    exit 1
fi

echo ""
echo "📊 Content validation..."

# Validate core component extraction
CORE_COMPONENTS=("goals" "roles" "functional" "non-functional" "assumptions")
for component in "${CORE_COMPONENTS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$component"; then
        echo "✅ Core component extraction: $component"
    else
        echo "❌ Missing core component: $component"
        exit 1
    fi
done

# Validate risk identification
if echo "$SYSTEM_CONTENT" | grep -q -i "top.*risk\|risk"; then
    echo "✅ Risk identification specified"
else
    echo "❌ Missing risk identification"
    exit 1
fi

# Validate open questions handling
if echo "$SYSTEM_CONTENT" | grep -q -i "open.*question"; then
    echo "✅ Open questions handling specified"
else
    echo "❌ Missing open questions handling"
    exit 1
fi

echo ""
echo "🎯 Quality and audience validation..."

# Validate product and engineering audience focus
if echo "$USER_CONTENT" | grep -q -i "product.*engineering\|concise.*unambiguous"; then
    echo "✅ Product and engineering audience focus specified"
else
    echo "❌ Missing product and engineering audience focus"
    exit 1
fi

# Validate testability requirement
if echo "$SYSTEM_CONTENT" | grep -q -i "testable"; then
    echo "✅ Testability requirement for functional requirements specified"
else
    echo "❌ Missing testability requirement"
    exit 1
fi

# Validate clarification seeking for missing core elements
if echo "$SYSTEM_CONTENT" | grep -q -i "seek.*clarification.*missing.*core.*goals.*users"; then
    echo "✅ Clarification seeking for missing core elements specified"
else
    echo "❌ Missing clarification seeking for core elements"
    exit 1
fi

echo ""
echo "🔍 Quality assurance validation..."

# Validate reasoning effort appropriate for requirements analysis
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "medium" || "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for requirements analysis: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for requirements work: $REASONING_EFFORT"
    exit 1
fi

# Validate over-assumption risk awareness
if echo "$SYSTEM_CONTENT" | grep -q -i "over.*assuming\|explicitly.*tagged"; then
    echo "✅ Over-assumption risk awareness specified"
elif jq -r '.risks_or_notes[]' "$PROMPT_FILE" | grep -q -i "over.*assuming"; then
    echo "✅ Over-assumption risks documented"
else
    echo "❌ Missing over-assumption risk awareness"
    exit 1
fi

# Validate structured output format
if echo "$USER_CONTENT" | grep -q -i "markdown.*section.*specified"; then
    echo "✅ Structured output format requirements specified"
else
    echo "❌ Missing structured output format requirements"
    exit 1
fi

echo ""
echo "✅ Requirements-draft prompt validation complete!"
echo "📊 Validated: JSON schema, product analysis methodology, requirements structure, assumption handling, quality assurance"