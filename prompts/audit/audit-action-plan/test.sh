#!/bin/bash

set -e

echo "Testing audit-action-plan prompt..."

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
echo "🔍 Testing GitHub Issues & Project Planner functionality..."

# Validate GitHub Issues & Project Planner role
if echo "$SYSTEM_CONTENT" | grep -q -i "github.*issues.*project.*planner"; then
    echo "✅ GitHub Issues & Project Planner role specified"
else
    echo "❌ Missing GitHub Issues & Project Planner role"
    exit 1
fi

# Validate audit report processing capability
if echo "$SYSTEM_CONTENT" | grep -q -i "audit.*report.*findings.*prioritized.*actions.*yaml.*backlog"; then
    echo "✅ Audit report processing capability specified"
else
    echo "❌ Missing audit report processing capability"
    exit 1
fi

# Validate structured issue generation
if echo "$SYSTEM_CONTENT" | grep -q -i "deduplicated.*structured.*issues.*epics"; then
    echo "✅ Structured issue and epic generation specified"
else
    echo "❌ Missing structured issue generation"
    exit 1
fi

echo ""
echo "📋 Testing planning methodology validation..."

# Validate 6-step planning process
PLANNING_STEPS=("parse.*normalize.*audit" "structure.*epics.*workstreams.*dependencies" "author.*high.*quality.*issues" "provide.*project.*v2.*configuration" "emit.*exports.*gh.*cli.*jsonl.*csv" "maintain.*safety.*no.*destructive")
STEP_COUNT=0
for step in "${PLANNING_STEPS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$step"; then
        echo "✅ Planning step: $step"
        STEP_COUNT=$((STEP_COUNT + 1))
    fi
done

if [ $STEP_COUNT -ge 5 ]; then
    echo "✅ Comprehensive 6-step planning methodology specified"
else
    echo "❌ Incomplete planning methodology ($STEP_COUNT/6 steps)"
    exit 1
fi

# Validate priority management
if echo "$SYSTEM_CONTENT" | grep -q -i "priority.*balance.*<30%.*P0\|priority.*balance.*30%"; then
    echo "✅ Priority balance management (P0-P2, <30% P0) specified"
else
    echo "❌ Missing priority balance management"
    exit 1
fi

echo ""
echo "📊 Testing issue quality standards..."

# Validate issue quality requirements
QUALITY_REQUIREMENTS=("evidence.*driven.*references.*audit" "context.*acceptance.*criteria.*evidence.*risk" "deduplicate.*similar.*items.*cross.*link" "split.*large.*P0.*P1.*tasks")
for requirement in "${QUALITY_REQUIREMENTS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$requirement"; then
        echo "✅ Issue quality requirement: $requirement"
    else
        echo "❌ Missing quality requirement: $requirement"
        exit 1
    fi
done

# Validate category labeling system
if echo "$SYSTEM_CONTENT" | grep -q -i "category.*priority.*labels.*arch.*test.*ci.*security.*docs.*ops"; then
    echo "✅ Comprehensive category labeling system specified"
else
    echo "❌ Missing category labeling system"
    exit 1
fi

echo ""
echo "📝 Testing deliverable requirements..."

# Validate required output sections
REQUIRED_SECTIONS=("planning.*overview" "epic.*workstream.*topology" "issue.*specs.*yaml.*blocks" "exports.*gh.*cli.*rest.*jsonl.*projects.*csv" "rollout.*plan" "change.*log")
for section in "${REQUIRED_SECTIONS[@]}"; do
    if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "$section"; then
        echo "✅ Required section: $section"
    else
        echo "❌ Missing required section: $section"
        exit 1
    fi
done

# Validate export formats
if echo "$USER_CONTENT" | grep -q -i "exports.*gh_cli.*rest_jsonl"; then
    echo "✅ Multiple export formats specified"
else
    echo "❌ Missing export format options"
    exit 1
fi

echo ""
echo "🛡️ Testing safety and compliance validation..."

# Validate safety guardrails
if echo "$SYSTEM_CONTENT" | grep -q -i "read.*only.*reasoning.*output.*runnable.*artifacts"; then
    echo "✅ Read-only operation safety specified"
else
    echo "❌ Missing read-only safety constraint"
    exit 1
fi

# Validate secret protection
if echo "$SYSTEM_CONTENT" | grep -q -i "flag.*secrets.*pii\|maintain.*safety.*no.*destructive"; then
    echo "✅ Secret/PII protection and safety specified"
else
    echo "❌ Missing secret protection"
    exit 1
fi

# Validate GitHub integration awareness
if echo "$USER_CONTENT" | grep -q -i "gh_owner.*gh_repo\|project_name.*milestones"; then
    echo "✅ GitHub integration context specified"
else
    echo "❌ Missing GitHub integration context"
    exit 1
fi

echo ""
echo "🎯 Project management validation..."

# Validate comprehensive project configuration
PROJECT_FEATURES=("status.*workflow.*backlog.*progress.*review.*done" "target.*windows.*now.*30d.*60d.*90d" "estimate.*sizes.*xs.*s.*m.*l.*xl" "priority.*mapping.*p0.*p1.*p2")
for feature in "${PROJECT_FEATURES[@]}"; do
    if echo "$USER_CONTENT" | grep -q -i "$feature"; then
        echo "✅ Project feature: $feature"
    else
        echo "❌ Missing project feature: $feature"
        exit 1
    fi
done

# Validate bulk operation safeguards
if echo "$USER_CONTENT" | grep -q -i "max.*issues.*100"; then
    echo "✅ Bulk operation safeguards (MAX_ISSUES) specified"
else
    echo "❌ Missing bulk operation safeguards"
    exit 1
fi

echo ""
echo "🔍 Quality assurance validation..."

# Validate reasoning effort appropriate for complex planning
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for complex planning: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for planning: $REASONING_EFFORT"
    exit 1
fi

# Validate verbosity appropriate for structured output
VERBOSITY=$(jq -r '.parameters.verbosity // "not_specified"' "$PROMPT_FILE")
if [[ "$VERBOSITY" == "low" ]]; then
    echo "✅ Appropriate verbosity for structured output: $VERBOSITY"
else
    echo "❌ Inappropriate verbosity for issue generation: $VERBOSITY"
    exit 1
fi

# Validate comprehensive assumption and risk documentation
ASSUMPTIONS=$(jq -r '.assumptions // [] | length' "$PROMPT_FILE")
RISKS=$(jq -r '.risks_or_notes // [] | length' "$PROMPT_FILE")
if [[ "$ASSUMPTIONS" -gt 0 && "$RISKS" -gt 0 ]]; then
    echo "✅ Comprehensive assumptions and risks documented"
else
    echo "❌ Missing assumption or risk documentation"
    exit 1
fi

# Validate transformation workflow
if echo "$USER_CONTENT" | grep -q -i "transformation.*tasks.*produce.*output.*contract\|produce.*all.*output.*contract.*sections"; then
    echo "✅ Comprehensive transformation workflow specified"
else
    echo "❌ Missing transformation workflow"
    exit 1
fi

# Validate epic management
if echo "$USER_CONTENT" | grep -q -i "epic.*prefix.*\[EPIC\]"; then
    echo "✅ Epic management and naming convention specified"
else
    echo "❌ Missing epic management"
    exit 1
fi

echo ""
echo "✅ Audit-action-plan prompt validation complete!"
echo "📊 Validated: JSON schema, GitHub project planning, issue quality standards, safety guardrails, bulk operation controls"
