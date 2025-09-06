#!/bin/bash

set -e

echo "Testing literature-review prompt..."

# Test that the file exists
PROMPT_FILE="/Users/robertdozier/workspace/rad-prompt-hub/prompts/research/literature-review/literature-review.json"
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
echo "📚 Testing academic literature review functionality..."

# Validate academic research analyst role
if echo "$SYSTEM_CONTENT" | grep -q -i "academic.*research.*analyst\|literature"; then
    echo "✅ Academic research analyst role specified"
else
    echo "❌ Missing academic research analyst role specification"
    exit 1
fi

# Validate synthesis focus
if echo "$SYSTEM_CONTENT" | grep -q -i "synthesizing.*literature\|cluster.*source.*theme"; then
    echo "✅ Literature synthesis focus specified"
else
    echo "❌ Missing literature synthesis focus"
    exit 1
fi

echo ""
echo "📋 Testing literature review structure validation..."

# Validate required output sections
REQUIRED_SECTIONS=("Thematic Overview" "Theme Summaries" "Source Table" "Methodological Critique" "Gaps" "Suggested Research Questions")
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
if echo "$USER_CONTENT" | grep -q -i "Source ID.*Theme.*Method.*Key Finding.*Limitations"; then
    echo "✅ Source table structure specified with required columns"
else
    echo "❌ Missing proper source table structure"
    exit 1
fi

echo ""
echo "📖 Academic methodology validation..."

# Validate theme summary constraints
if echo "$SYSTEM_CONTENT" | grep -q -i "theme.*summaries.*≤.*120.*word"; then
    echo "✅ Theme summary word constraint (≤120 words) specified"
else
    echo "❌ Missing theme summary word constraint"
    exit 1
fi

# Validate no fabricated statistics rule
if echo "$SYSTEM_CONTENT" | grep -q -i "no.*fabricated.*stats"; then
    echo "✅ No fabricated statistics rule specified"
else
    echo "❌ Missing no fabricated statistics rule"
    exit 1
fi

# Validate methodological analysis
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "critique.*method\|methodological.*critique"; then
    echo "✅ Methodological critique requirement specified"
else
    echo "❌ Missing methodological critique requirement"
    exit 1
fi

echo ""
echo "🔍 Research analysis validation..."

# Validate gap identification
if echo "$SYSTEM_CONTENT" | grep -q -i "gaps.*research.*question\|list.*gaps"; then
    echo "✅ Gap identification and research questions specified"
else
    echo "❌ Missing gap identification requirement"
    exit 1
fi

# Validate source content handling
if echo "$SYSTEM_CONTENT" | grep -q -i "ask.*for.*excerpt\|query.*missing.*source"; then
    echo "✅ Source content handling (excerpts) specified"
else
    echo "❌ Missing source content handling"
    exit 1
fi

# Validate academic audience focus
if echo "$USER_CONTENT" | grep -q -i "academic.*analytic\|objective.*concise"; then
    echo "✅ Academic audience and objective tone specified"
else
    echo "❌ Missing academic audience specification"
    exit 1
fi

echo ""
echo "📊 Data quality validation..."

# Validate sample size tracking
if echo "$SYSTEM_CONTENT" | grep -q -i "sample.*size.*if.*present"; then
    echo "✅ Sample size tracking specified"
else
    echo "❌ Missing sample size tracking"
    exit 1
fi

# Validate limitations documentation
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "limitation"; then
    echo "✅ Limitations documentation required"
else
    echo "❌ Missing limitations documentation requirement"
    exit 1
fi

# Validate key findings extraction
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "key.*finding"; then
    echo "✅ Key findings extraction specified"
else
    echo "❌ Missing key findings extraction"
    exit 1
fi

echo ""
echo "🔍 Quality assurance validation..."

# Validate reasoning effort appropriate for literature review
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for literature review: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for academic synthesis: $REASONING_EFFORT"
    exit 1
fi

# Validate quality degradation awareness
if echo "$SYSTEM_CONTENT" | grep -q -i "excerpt.*sparse.*theme.*quality\|gaps.*flagged"; then
    echo "✅ Quality degradation awareness specified"
elif jq -r '.risks_or_notes[]' "$PROMPT_FILE" | grep -q -i "excerpt.*sparse\|theme.*quality"; then
    echo "✅ Quality degradation risks documented"
else
    echo "❌ Missing quality degradation awareness"
    exit 1
fi

# Validate structured academic output
if echo "$USER_CONTENT" | grep -q -i "markdown.*section.*specified"; then
    echo "✅ Structured academic output format specified"
else
    echo "❌ Missing structured output format requirements"
    exit 1
fi

echo ""
echo "✅ Literature-review prompt validation complete!"
echo "📊 Validated: JSON schema, academic methodology, literature synthesis, source analysis, gap identification, quality assurance"