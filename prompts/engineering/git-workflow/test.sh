#!/bin/bash

set -e

echo "Testing git-workflow prompt..."

# Test that the file exists
PROMPT_FILE="/Users/robertdozier/workspace/rad-prompt-hub/prompts/engineering/git-workflow/git-workflow.json"
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
echo "🔧 Testing Git workflow advisory functionality..."

# Validate release engineering advisor role
if echo "$SYSTEM_CONTENT" | grep -q -i "release.*engineering.*advisor\|git.*collaboration"; then
    echo "✅ Release engineering advisor role specified"
else
    echo "❌ Missing release engineering advisor role specification"
    exit 1
fi

# Validate workflow optimization focus
if echo "$SYSTEM_CONTENT" | grep -q -i "optimizing.*git.*collaboration.*model"; then
    echo "✅ Git collaboration model optimization focus specified"
else
    echo "❌ Missing workflow optimization focus"
    exit 1
fi

echo ""
echo "📋 Testing Git workflow structure validation..."

# Validate required output sections
REQUIRED_SECTIONS=("Context Summary" "Recommended Model" "Branch Types" "Commit Convention" "PR Policy" "Automation" "Risks")
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

# Validate model justification constraint
if echo "$USER_CONTENT" | grep -q -i "model.*justification.*≤.*120.*word"; then
    echo "✅ Model justification length constraint (≤120 words) specified"
else
    echo "❌ Missing model justification length constraint"
    exit 1
fi

echo ""
echo "🎯 Engineering methodology validation..."

# Validate team context alignment
if echo "$SYSTEM_CONTENT" | grep -q -i "align.*model.*release.*cadence.*team.*size"; then
    echo "✅ Team context alignment (release cadence + team size) specified"
else
    echo "❌ Missing team context alignment"
    exit 1
fi

# Validate actionable guidance focus
if echo "$SYSTEM_CONTENT" | grep -q -i "actionable.*concise"; then
    echo "✅ Actionable and concise guidance focus specified"
else
    echo "❌ Missing actionable guidance focus"
    exit 1
fi

# Validate no dogma approach
if echo "$SYSTEM_CONTENT" | grep -q -i "no dogma.*justify.*trade.*off"; then
    echo "✅ No dogma approach with trade-off justification specified"
else
    echo "❌ Missing no dogma approach"
    exit 1
fi

echo ""
echo "📊 Workflow component validation..."

# Validate comprehensive workflow components
WORKFLOW_COMPONENTS=("branching.*strategy" "branch.*roles" "protection" "commit.*standard" "PR.*standard" "automation")
for component in "${WORKFLOW_COMPONENTS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$component"; then
        echo "✅ Workflow component specified: $component"
    else
        echo "❌ Missing workflow component: $component"
        exit 1
    fi
done

# Validate risk awareness
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "risk.*note\|risk"; then
    echo "✅ Risk identification and notation specified"
else
    echo "❌ Missing risk identification"
    exit 1
fi

echo ""
echo "🎯 Context and audience validation..."

# Validate engineering leads audience
if echo "$USER_CONTENT" | grep -q -i "engineering.*lead.*pragmatic.*evidence.*based"; then
    echo "✅ Engineering leads audience with pragmatic, evidence-based tone specified"
else
    echo "❌ Missing engineering leads audience specification"
    exit 1
fi

# Validate team context clarification capability
if echo "$SYSTEM_CONTENT" | grep -q -i "ask.*clarifying.*question.*team.*context.*missing"; then
    echo "✅ Team context clarification capability specified"
else
    echo "❌ Missing team context clarification capability"
    exit 1
fi

# Validate context factors awareness
if echo "$SYSTEM_CONTENT" | grep -q -i "size.*cadence.*CI.*maturity"; then
    echo "✅ Key context factors (size, cadence, CI maturity) specified"
else
    echo "❌ Missing key context factors"
    exit 1
fi

echo ""
echo "🔍 Quality and standards validation..."

# Validate reasoning effort appropriate for workflow design
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "medium" || "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for workflow design: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for workflow design: $REASONING_EFFORT"
    exit 1
fi

# Validate over-generalization risk awareness
if echo "$SYSTEM_CONTENT" | grep -q -i "insufficient.*context.*over.*generalization"; then
    echo "✅ Over-generalization risk awareness specified"
elif jq -r '.risks_or_notes[]' "$PROMPT_FILE" | grep -q -i "insufficient.*context.*over.*generalization"; then
    echo "✅ Over-generalization risks documented"
else
    echo "❌ Missing over-generalization risk awareness"
    exit 1
fi

# Validate exact section naming requirement
if echo "$USER_CONTENT" | grep -q -i "markdown.*section.*exactly.*named.*specified"; then
    echo "✅ Exact section naming requirement specified"
else
    echo "❌ Missing exact section naming requirement"
    exit 1
fi

# Validate CI integration awareness
if echo "$USER_CONTENT" | grep -q -i "CI.*available\|standard.*git.*hosting"; then
    echo "✅ CI integration and Git hosting awareness specified"
else
    echo "❌ Missing CI integration awareness"
    exit 1
fi

echo ""
echo "✅ Git-workflow prompt validation complete!"
echo "📊 Validated: JSON schema, release engineering methodology, workflow components, team context alignment, quality standards"