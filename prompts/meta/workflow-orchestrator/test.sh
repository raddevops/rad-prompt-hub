#!/bin/bash

# Test script for workflow-orchestrator prompt
# Validates JSON structure, required fields, and orchestration functionality

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/workflow-orchestrator.json"

echo "🎼 Testing Workflow Orchestrator Prompt..."
echo "======================================================"

# Check if prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo "❌ Prompt file not found: $PROMPT_FILE"
    exit 1
fi

echo "✅ Prompt file exists: $PROMPT_FILE"

# Validate JSON syntax
if ! jq . "$PROMPT_FILE" > /dev/null 2>&1; then
    echo "❌ Invalid JSON syntax"
    exit 1
fi

echo "✅ Valid JSON syntax"

# Extract content for validation
SYSTEM_CONTENT=$(jq -r '.messages[0].content // empty' "$PROMPT_FILE")
USER_CONTENT=$(jq -r '.messages[1].content // empty' "$PROMPT_FILE")

echo ""
echo "📋 Schema validation..."

# Validate required fields
REQUIRED_FIELDS=("name" "target_model" "parameters" "messages")
for field in "${REQUIRED_FIELDS[@]}"; do
    if jq -e ".$field" "$PROMPT_FILE" > /dev/null; then
        echo "✅ Required field present: $field"
    else
        echo "❌ Missing required field: $field"
        exit 1
    fi
done

# Validate parameters
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
VERBOSITY=$(jq -r '.parameters.verbosity // "not_specified"' "$PROMPT_FILE")

if [[ "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for orchestration: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for workflow coordination: $REASONING_EFFORT"
    exit 1
fi

if [[ "$VERBOSITY" == "medium" ]]; then
    echo "✅ Appropriate verbosity for workflow reporting: $VERBOSITY"
else
    echo "❌ Suboptimal verbosity for progress tracking: $VERBOSITY"
    exit 1
fi

echo ""
echo "🎯 Role and functionality validation..."

# Validate orchestrator role
if echo "$SYSTEM_CONTENT" | grep -q -i "workflow.*orchestrator"; then
    echo "✅ Workflow Orchestrator role specified"
else
    echo "❌ Missing Workflow Orchestrator role"
    exit 1
fi

# Validate multi-prompt coordination
if echo "$SYSTEM_CONTENT" | grep -q -i "documentation.*validator.*promptsmith"; then
    echo "✅ Multi-prompt coordination capability specified"
else
    echo "❌ Missing multi-prompt coordination capability"
    exit 1
fi

# Validate phase management
if echo "$SYSTEM_CONTENT" | grep -q -i "phase.*management\\|workflow.*phase"; then
    echo "✅ Workflow phase management specified"
else
    echo "❌ Missing workflow phase management"
    exit 1
fi

# Validate quality assurance
if echo "$SYSTEM_CONTENT" | grep -q -i "quality.*assurance\\|quality.*standard"; then
    echo "✅ Quality assurance capabilities specified"
else
    echo "❌ Missing quality assurance capabilities"
    exit 1
fi

echo ""
echo "📋 Input template validation..."

# Validate input template sections
INPUT_SECTIONS=("TARGET_PROMPT_PATH" "WORKFLOW_SCOPE" "QUALITY_STANDARDS" "PHASE_CONTROL" "CUSTOM_REQUIREMENTS")
MISSING_INPUT_SECTIONS=()
for section in "${INPUT_SECTIONS[@]}"; do
    if echo "$USER_CONTENT" | grep -q "$section"; then
        echo "✅ Input template section: $section"
    else
        MISSING_INPUT_SECTIONS+=("$section")
    fi
done

if [ ${#MISSING_INPUT_SECTIONS[@]} -gt 0 ]; then
    echo "❌ Missing input template sections: ${MISSING_INPUT_SECTIONS[*]}"
    exit 1
fi

# Validate optional sections handling
if echo "$USER_CONTENT" | grep -q -i "optional"; then
    echo "✅ Optional sections marked appropriately"
else
    echo "❌ Missing optional section markings"
    exit 1
fi

echo ""
echo "🔄 Workflow phases validation..."

# Validate 4-phase structure
PHASES=("Phase 1.*Documentation.*Validation" "Phase 2.*Prompt.*Enhancement" "Phase 3.*Documentation.*Update" "Phase 4.*Final.*Validation")
for phase in "${PHASES[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$phase"; then
        echo "✅ Workflow phase specified: $(echo "$phase" | cut -d'.' -f1-2)"
    else
        echo "❌ Missing workflow phase: $(echo "$phase" | cut -d'.' -f1-2)"
        exit 1
    fi
done

# Validate sequential execution
if echo "$SYSTEM_CONTENT" | grep -q -i "sequential.*execution\\|phases.*sequentially"; then
    echo "✅ Sequential execution specified"
else
    echo "❌ Missing sequential execution requirement"
    exit 1
fi

# Validate status reporting
if echo "$SYSTEM_CONTENT" | grep -q -i "status.*reporting\\|progress.*tracking"; then
    echo "✅ Status reporting capabilities specified"
else
    echo "❌ Missing status reporting capabilities"
    exit 1
fi

echo ""
echo "🎼 Orchestration rules validation..."

# Validate actionable findings requirement
if echo "$SYSTEM_CONTENT" | grep -q -i "actionable.*findings\\|actionable.*recommendation"; then
    echo "✅ Actionable findings requirement specified"
else
    echo "❌ Missing actionable findings requirement"
    exit 1
fi

# Validate metrics tracking
if echo "$SYSTEM_CONTENT" | grep -q -i "validation.*score\\|metrics.*track"; then
    echo "✅ Metrics tracking capabilities specified"
else
    echo "❌ Missing metrics tracking capabilities"
    exit 1
fi

# Validate repository standards compliance
if echo "$SYSTEM_CONTENT" | grep -q -i "repository.*standard\\|schema.*compliance"; then
    echo "✅ Repository standards compliance specified"
else
    echo "❌ Missing repository standards compliance"
    exit 1
fi

# Validate backward compatibility
if echo "$SYSTEM_CONTENT" | grep -q -i "backward.*compatibility"; then
    echo "✅ Backward compatibility requirement specified"
else
    echo "❌ Missing backward compatibility requirement"
    exit 1
fi

echo ""
echo "📊 Quality assurance validation..."

# Validate input variables documentation
INPUT_VARS=$(jq -r '.input_variables // {} | keys[]' "$PROMPT_FILE" 2>/dev/null || echo "")
if [ -n "$INPUT_VARS" ]; then
    echo "✅ Input variables documented"
    
    # Check for key variables
    if echo "$INPUT_VARS" | grep -q "TARGET_PROMPT_PATH"; then
        echo "✅ Target prompt path variable documented"
    else
        echo "❌ Missing target prompt path variable"
        exit 1
    fi
    
    if echo "$INPUT_VARS" | grep -q "WORKFLOW_SCOPE"; then
        echo "✅ Workflow scope variable documented"
    else
        echo "❌ Missing workflow scope variable"
        exit 1
    fi
else
    echo "❌ Missing input variables documentation"
    exit 1
fi

# Validate assumptions presence
ASSUMPTIONS=$(jq -r '.assumptions // [] | length' "$PROMPT_FILE")
if [ "$ASSUMPTIONS" -gt 0 ]; then
    echo "✅ Assumptions documented ($ASSUMPTIONS items)"
else
    echo "❌ Missing assumptions documentation"
    exit 1
fi

# Validate risks documentation
RISKS=$(jq -r '.risks_or_notes // [] | length' "$PROMPT_FILE")
if [ "$RISKS" -gt 0 ]; then
    echo "✅ Risks and limitations documented ($RISKS items)"
else
    echo "❌ Missing risks documentation"
    exit 1
fi

# Validate parameter reasoning
if jq -e '.parameter_reasoning' "$PROMPT_FILE" > /dev/null; then
    echo "✅ Parameter reasoning documented"
else
    echo "❌ Missing parameter reasoning documentation"
    exit 1
fi

echo ""
echo "🎉 All tests passed! Workflow Orchestrator prompt is valid and functional."
echo ""