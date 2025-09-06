#!/bin/bash

# Test script for experiment-plan prompt
# This script validates that the prompt generates scientifically rigorous experiment designs

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
echo "🔬 Testing experiment plan prompt functionality..."

# Check system message for experiment design content
SYSTEM_CONTENT=$(jq -r '.messages[] | select(.role == "system") | .content' "$JSON_FILE")

# Validate scientific method components
REQUIRED_COMPONENTS=("objective" "hypothes" "variables" "procedure" "analysis")
MISSING_COMPONENTS=()

for component in "${REQUIRED_COMPONENTS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$component"; then
        echo "✅ Scientific component specified: $component"
    else
        MISSING_COMPONENTS+=("$component")
    fi
done

if [[ ${#MISSING_COMPONENTS[@]} -gt 0 ]]; then
    echo "❌ Missing critical scientific components: ${MISSING_COMPONENTS[*]}"
    exit 1
fi

# Check for hypothesis specification (null and alternative)
if echo "$SYSTEM_CONTENT" | grep -q -i "null.*alternative\|alternative.*null"; then
    echo "✅ Null and alternative hypotheses specified"
else
    echo "❌ Missing null and alternative hypothesis specification"
    exit 1
fi

# Validate statistical considerations
if echo "$SYSTEM_CONTENT" | grep -q -i "sample.*size\|power\|significance\|statistical"; then
    echo "✅ Statistical considerations mentioned"
else
    echo "⚠️  Statistical considerations not explicitly mentioned"
fi

# Check user message template
USER_CONTENT=$(jq -r '.messages[] | select(.role == "user") | .content' "$JSON_FILE")

# Validate required output sections - check for the actual content in constraints
if echo "$USER_CONTENT" | grep -q -i "Sections:.*Objective.*Hypotheses.*Variables.*Groups.*Metrics.*Thresholds.*Procedure.*Risks.*Mitigations.*Sample Size.*Analysis Plan"; then
    echo "✅ All required sections found in constraints format"
    SECTION_COUNT=9
else
    # Fallback to individual section checks
    REQUIRED_SECTIONS=("Objective" "Hypotheses" "Variables" "Groups" "Metrics" "Procedure" "Risks" "Sample Size" "Analysis Plan")
    SECTION_COUNT=0
    
    for section in "${REQUIRED_SECTIONS[@]}"; do
        if echo "$USER_CONTENT" | grep -q -i "$section"; then
            echo "✅ Output section specified: $section"
            ((SECTION_COUNT++))
        fi
    done
fi

if [[ $SECTION_COUNT -lt 7 ]]; then
    echo "❌ Missing critical output sections (found $SECTION_COUNT, need at least 7)"
    exit 1
fi

echo ""
echo "🧪 Scientific rigor validation..."

# Check for experimental controls
if echo "$SYSTEM_CONTENT" | grep -q -i "control\|baseline\|comparison"; then
    echo "✅ Experimental controls mentioned"
else
    echo "⚠️  Experimental controls not explicitly mentioned"
fi

# Validate bias consideration
if echo "$SYSTEM_CONTENT" | grep -q -i "bias\|confound\|validity"; then
    echo "✅ Bias/validity considerations present"
else
    echo "⚠️  Bias considerations not explicitly mentioned"
fi

# Check reasoning effort for research work
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort' "$JSON_FILE")
if [[ "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ High reasoning effort appropriate for experiment design"
else
    echo "⚠️  Reasoning effort may be too low for rigorous experiment design: $REASONING_EFFORT"
fi

echo ""
echo "📊 Methodology validation..."

# Check for metrics and measurement
if echo "$SYSTEM_CONTENT" | grep -q -i "metric\|measure\|threshold\|outcome"; then
    echo "✅ Measurement methodology specified"
else
    echo "❌ Missing measurement methodology"
    exit 1
fi

# Validate risk assessment
if echo "$SYSTEM_CONTENT" | grep -q -i "risk\|mitigation\|limitation"; then
    echo "✅ Risk assessment mentioned"
else
    echo "❌ Missing risk assessment"
    exit 1
fi

# Check for ethical considerations
if echo "$SYSTEM_CONTENT" | grep -q -i "ethic\|consent\|harm"; then
    echo "✅ Ethical considerations present"
else
    echo "⚠️  Ethical considerations not explicitly mentioned"
fi

echo ""
echo "🎯 Input validation..."

# Check for objective input
if echo "$USER_CONTENT" | grep -q -i "objective\|goal\|purpose"; then
    echo "✅ Objective input placeholder found"
else
    echo "❌ Missing objective input specification"
    exit 1
fi

echo ""
echo "✅ Experiment plan prompt validation complete!"
echo "📊 Validated: JSON schema, scientific method, hypotheses, statistical considerations, measurement methodology"

exit 0