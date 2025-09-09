#!/bin/bash

# Test script for github-issue-automation-system prompt
# Validates JSON structure, required fields, and comprehensive automation functionality

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/github-issue-automation-system.json"

echo "🤖 Testing GitHub Issue Automation System Prompt..."
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
    echo "✅ Appropriate reasoning effort for system automation: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for complex system creation: $REASONING_EFFORT"
    exit 1
fi

if [[ "$VERBOSITY" == "low" ]]; then
    echo "✅ Appropriate verbosity for implementation artifacts: $VERBOSITY"
else
    echo "❌ Suboptimal verbosity for actionable system deployment: $VERBOSITY"
    exit 1
fi

echo ""
echo "🎯 Role and functionality validation..."

# Validate GitHub Copilot Agent role
if echo "$SYSTEM_CONTENT" | grep -q -i "github.*copilot.*coding.*agent"; then
    echo "✅ GitHub Copilot Coding Agent role specified"
else
    echo "❌ Missing GitHub Copilot Coding Agent role"
    exit 1
fi

# Validate issue analysis capability
if echo "$SYSTEM_CONTENT" | grep -q -i "issue.*pattern.*analysis"; then
    echo "✅ Issue pattern analysis capability specified"
else
    echo "❌ Missing issue pattern analysis capability"
    exit 1
fi

# Validate automation system creation
if echo "$SYSTEM_CONTENT" | grep -q -i "automation.*system.*creation"; then
    echo "✅ Automation system creation capability specified"
else
    echo "❌ Missing automation system creation capability"
    exit 1
fi

# Validate PromptSmith integration
if echo "$SYSTEM_CONTENT" | grep -q -i "promptsmith.*integration"; then
    echo "✅ PromptSmith integration specified"
else
    echo "❌ Missing PromptSmith integration capability"
    exit 1
fi

echo ""
echo "📋 Input template validation..."

# Validate input template sections
INPUT_SECTIONS=("REPOSITORY_PATH" "GITHUB_ACCOUNT_INFO" "OPEN_ISSUES_JSON" "REPOSITORY_STANDARDS" "INTEGRATION_REQUIREMENTS" "IMPLEMENTATION_SCOPE" "CUSTOM_CONSTRAINTS")
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
echo "🏗️ Implementation strategy validation..."

# Validate 6-phase implementation strategy
PHASES=("Phase 1.*Repository.*Issue.*Analysis" "Phase 2.*System.*Architecture.*Design" "Phase 3.*Component.*Implementation" "Phase 4.*System.*Integration.*Testing" "Phase 5.*Issue.*Workflow.*Updates" "Phase 6.*Deployment.*Validation")
for phase in "${PHASES[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$phase"; then
        echo "✅ Implementation phase specified: $(echo "$phase" | cut -d'.' -f1-2)"
    else
        echo "❌ Missing implementation phase: $(echo "$phase" | cut -d'.' -f1-2)"
        exit 1
    fi
done

# Validate repository integration rules
if echo "$SYSTEM_CONTENT" | grep -q -i "repository.*integration.*rules"; then
    echo "✅ Repository integration rules specified"
else
    echo "❌ Missing repository integration rules"
    exit 1
fi

# Validate system architecture components
if echo "$SYSTEM_CONTENT" | grep -q -i "system.*architecture.*components"; then
    echo "✅ System architecture components specified"
else
    echo "❌ Missing system architecture components"
    exit 1
fi

echo ""
echo "🔧 Core objectives validation..."

# Validate comprehensive objectives
OBJECTIVES=("Issue.*Pattern.*Analysis" "System.*Architecture" "Component.*Implementation" "Workflow.*Integration" "Issue.*Automation" "Quality.*Assurance")
for objective in "${OBJECTIVES[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$objective"; then
        echo "✅ Core objective specified: $(echo "$objective" | sed 's/\.\*//' | sed 's/.*\.//')"
    else
        echo "❌ Missing core objective: $(echo "$objective" | sed 's/\.\*//' | sed 's/.*\.//')"
        exit 1
    fi
done

# Validate quality standards
if echo "$SYSTEM_CONTENT" | grep -q -i "quality.*standards"; then
    echo "✅ Quality standards requirements specified"
else
    echo "❌ Missing quality standards requirements"
    exit 1
fi

# Validate 3-file structure compliance
if echo "$SYSTEM_CONTENT" | grep -q -i "3.*file.*structure"; then
    echo "✅ 3-file structure compliance specified"
else
    echo "❌ Missing 3-file structure compliance"
    exit 1
fi

echo ""
echo "📊 Quality assurance validation..."

# Validate input variables documentation
INPUT_VARS=$(jq -r '.input_variables // {} | keys[]' "$PROMPT_FILE" 2>/dev/null || echo "")
if [ -n "$INPUT_VARS" ]; then
    echo "✅ Input variables documented"
    
    # Check for key variables
    REQUIRED_VARS=("REPOSITORY_PATH" "GITHUB_ACCOUNT_INFO" "OPEN_ISSUES_JSON" "REPOSITORY_STANDARDS" "INTEGRATION_REQUIREMENTS")
    for var in "${REQUIRED_VARS[@]}"; do
        if echo "$INPUT_VARS" | grep -q "$var"; then
            echo "✅ Required variable documented: $var"
        else
            echo "❌ Missing required variable: $var"
            exit 1
        fi
    done
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

# Validate mission statement
if echo "$SYSTEM_CONTENT" | grep -q -i "mission"; then
    echo "✅ Mission statement specified"
else
    echo "❌ Missing mission statement"
    exit 1
fi

echo ""
echo "🎉 All tests passed! GitHub Issue Automation System prompt is valid and comprehensive."
echo ""