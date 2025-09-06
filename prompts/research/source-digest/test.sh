#!/bin/bash

set -e

echo "Testing source-digest prompt..."

# Test that the file exists
PROMPT_FILE="/Users/robertdozier/workspace/rad-prompt-hub/prompts/research/source-digest/source-digest.json"
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
echo "📊 Testing research synthesis functionality..."

# Validate research synthesis analyst role
if echo "$SYSTEM_CONTENT" | grep -q -i "research.*synthesis.*analyst\|source.*digest"; then
    echo "✅ Research synthesis analyst role specified"
else
    echo "❌ Missing research synthesis analyst role specification"
    exit 1
fi

# Validate structured source digest focus
if echo "$SYSTEM_CONTENT" | grep -q -i "structured.*source.*digest"; then
    echo "✅ Structured source digest focus specified"
else
    echo "❌ Missing structured digest focus"
    exit 1
fi

echo ""
echo "📋 Testing source digest structure validation..."

# Validate required output sections
REQUIRED_SECTIONS=("Sources" "Convergence" "Conflicts" "Gaps" "Next Research Steps")
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

# Validate source table structure
if echo "$USER_CONTENT" | grep -q -i "Source ID.*Claim.*Evidence.*Confidence.*Notes"; then
    echo "✅ Source table structure specified with required columns"
else
    echo "❌ Missing proper source table structure"
    exit 1
fi

echo ""
echo "🎯 Research methodology validation..."

# Validate confidence level system
if echo "$SYSTEM_CONTENT" | grep -q -i "confidence.*LOW.*MED.*HIGH.*justification"; then
    echo "✅ Confidence level system (LOW/MED/HIGH with justification) specified"
else
    echo "❌ Missing confidence level system"
    exit 1
fi

# Validate comprehensive extraction requirements
EXTRACTION_COMPONENTS=("claims" "evidence" "confidence levels" "convergence" "conflicts" "gaps")
for component in "${EXTRACTION_COMPONENTS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$component"; then
        echo "✅ Extraction component specified: $component"
    else
        echo "❌ Missing extraction component: $component"
        exit 1
    fi
done

echo ""
echo "📖 Source analysis validation..."

# Validate unclear source labeling
if echo "$SYSTEM_CONTENT" | grep -q -i "label.*unclear.*source"; then
    echo "✅ Unclear source labeling requirement specified"
else
    echo "❌ Missing unclear source labeling requirement"
    exit 1
fi

# Validate no fabricated evidence rule
if echo "$SYSTEM_CONTENT" | grep -q -i "no.*fabricated.*evidence"; then
    echo "✅ No fabricated evidence rule specified"
else
    echo "❌ Missing no fabricated evidence rule"
    exit 1
fi

# Validate source corpus requirement
if echo "$SYSTEM_CONTENT" | grep -q -i "ask.*for.*source.*list\|query.*missing.*source.*corpus"; then
    echo "✅ Source corpus requirement and handling specified"
else
    echo "❌ Missing source corpus requirement"
    exit 1
fi

echo ""
echo "🔍 Analysis quality validation..."

# Validate convergence analysis
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "convergence"; then
    echo "✅ Convergence analysis specified"
else
    echo "❌ Missing convergence analysis"
    exit 1
fi

# Validate conflict identification
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "conflict"; then
    echo "✅ Conflict identification specified"
else
    echo "❌ Missing conflict identification"
    exit 1
fi

# Validate gap analysis
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "gap"; then
    echo "✅ Gap analysis specified"
else
    echo "❌ Missing gap analysis"
    exit 1
fi

# Validate next research steps
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "next.*research.*step"; then
    echo "✅ Next research steps specified"
else
    echo "❌ Missing next research steps"
    exit 1
fi

echo ""
echo "📊 Quality assurance validation..."

# Validate reasoning effort appropriate for research synthesis
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "medium" || "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for research synthesis: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for synthesis work: $REASONING_EFFORT"
    exit 1
fi

# Validate analytical tone requirement
if echo "$USER_CONTENT" | grep -q -i "analytical.*neutral"; then
    echo "✅ Analytical and neutral tone specified"
else
    echo "❌ Missing analytical tone requirement"
    exit 1
fi

# Validate confidence precision risk awareness
if echo "$SYSTEM_CONTENT" | grep -q -i "ambiguous.*source.*confidence.*precision"; then
    echo "✅ Confidence precision risk awareness specified"
elif jq -r '.risks_or_notes[]' "$PROMPT_FILE" | grep -q -i "ambiguous.*source.*confidence"; then
    echo "✅ Confidence precision risks documented"
else
    echo "❌ Missing confidence precision risk awareness"
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
echo "✅ Source-digest prompt validation complete!"
echo "📊 Validated: JSON schema, research synthesis methodology, source analysis, confidence systems, quality assurance"