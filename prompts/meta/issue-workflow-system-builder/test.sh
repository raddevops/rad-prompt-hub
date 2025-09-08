#!/bin/bash

# Test script for issue-workflow-system-builder prompt
# Validates JSON structure, required fields, and system building functionality

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/issue-workflow-system-builder.json"

echo "🏗️  Testing Issue Workflow System Builder Prompt..."
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
    echo "✅ Appropriate reasoning effort for system building: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for complex system architecture: $REASONING_EFFORT"
    exit 1
fi

if [[ "$VERBOSITY" == "low" ]]; then
    echo "✅ Appropriate verbosity for actionable artifacts: $VERBOSITY"
else
    echo "❌ Suboptimal verbosity for concise system implementation: $VERBOSITY"
    exit 1
fi

echo ""
echo "🎯 Role and functionality validation..."

# Validate system builder role
if echo "$SYSTEM_CONTENT" | grep -q -i "github.*copilot.*coding.*agent"; then
    echo "✅ GitHub Copilot Coding Agent role specified"
else
    echo "❌ Missing GitHub Copilot Coding Agent role specification"
    exit 1
fi

# Validate issue analysis capability
if echo "$SYSTEM_CONTENT" | grep -q -i "issue.*pattern.*analysis"; then
    echo "✅ Issue pattern analysis capability specified"
else
    echo "❌ Missing issue pattern analysis capability"
    exit 1
fi

# Validate system creation capability
if echo "$SYSTEM_CONTENT" | grep -q -i "system.*prompts.*promptsmith"; then
    echo "✅ PromptSmith-based system creation specified"
else
    echo "❌ Missing PromptSmith system creation capability"
    exit 1
fi

# Validate workflow automation focus
if echo "$SYSTEM_CONTENT" | grep -q -i "workflow.*automation.*system"; then
    echo "✅ Workflow automation system building specified"
else
    echo "❌ Missing workflow automation system building"
    exit 1
fi

echo ""
echo "📋 Input template validation..."

# Validate input template sections
INPUT_SECTIONS=("REPOSITORY_PATH" "OPEN_ISSUES_DATA" "EXISTING_COMPONENTS" "REPOSITORY_STANDARDS" "INTEGRATION_REQUIREMENTS" "SYSTEM_SCOPE")
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
echo "🔍 System architecture validation..."

# Validate system architecture approach
if echo "$SYSTEM_CONTENT" | grep -q -i "system.*architecture.*approach"; then
    echo "✅ System architecture approach specified"
else
    echo "❌ Missing system architecture approach"
    exit 1
fi

# Validate workflow phases
if echo "$SYSTEM_CONTENT" | grep -q -i "workflow.*phases"; then
    echo "✅ Structured workflow phases specified"
else
    echo "❌ Missing workflow phases specification"
    exit 1
fi

# Validate repository standards compliance
if echo "$SYSTEM_CONTENT" | grep -q -i "repository.*standards\\|3.*file.*structure"; then
    echo "✅ Repository standards compliance specified"
else
    echo "❌ Missing repository standards compliance"
    exit 1
fi

# Validate integration requirements
if echo "$SYSTEM_CONTENT" | grep -q -i "integration.*ci.*cd\\|github.*actions"; then
    echo "✅ CI/CD integration capabilities specified"
else
    echo "❌ Missing CI/CD integration capabilities"
    exit 1
fi

echo ""
echo "🛠️ Implementation validation..."

# Validate minimal change principle
if echo "$SYSTEM_CONTENT" | grep -q -i "minimal.*modification\\|surgical.*change"; then
    echo "✅ Minimal modification principles specified"
else
    echo "❌ Missing minimal modification principles"
    exit 1
fi

# Validate existing infrastructure usage
if echo "$SYSTEM_CONTENT" | grep -q -i "existing.*repository.*infrastructure"; then
    echo "✅ Existing infrastructure utilization specified"
else
    echo "❌ Missing existing infrastructure utilization"
    exit 1
fi

# Validate validation and testing requirements
if echo "$SYSTEM_CONTENT" | grep -q -i "comprehensive.*testing\\|validation"; then
    echo "✅ Comprehensive testing requirements specified"
else
    echo "❌ Missing comprehensive testing requirements"
    exit 1
fi

echo ""
echo "📊 Quality assurance validation..."

# Validate input variables documentation
INPUT_VARS=$(jq -r '.input_variables // {} | keys[]' "$PROMPT_FILE" 2>/dev/null || echo "")
if [ -n "$INPUT_VARS" ]; then
    echo "✅ Input variables documented"
    
    # Check for key variables
    if echo "$INPUT_VARS" | grep -q "REPOSITORY_PATH"; then
        echo "✅ Repository path variable documented"
    else
        echo "❌ Missing repository path variable"
        exit 1
    fi
    
    if echo "$INPUT_VARS" | grep -q "OPEN_ISSUES_DATA"; then
        echo "✅ Issues data variable documented"
    else
        echo "❌ Missing issues data variable"
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
echo "🎉 All tests passed! Issue Workflow System Builder prompt is valid and functional."
echo ""