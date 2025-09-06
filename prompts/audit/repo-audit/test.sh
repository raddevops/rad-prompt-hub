#!/bin/bash

set -e

echo "Testing repo-audit prompt..."

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
echo "🔍 Testing repository audit functionality..."

# Validate senior repository auditor role
if echo "$SYSTEM_CONTENT" | grep -q -i "senior.*repository.*auditor.*improvement.*planner"; then
    echo "✅ Senior repository auditor and improvement planner role specified"
else
    echo "❌ Missing senior auditor role specification"
    exit 1
fi

# Validate read-only constraint awareness
if echo "$SYSTEM_CONTENT" | grep -q -i "read.*only.*mode\|read.*only.*no.*executing"; then
    echo "✅ Read-only mode constraint specified"
else
    echo "❌ Missing read-only constraint"
    exit 1
fi

# Validate comprehensive audit scope
if echo "$SYSTEM_CONTENT" | grep -q -i "documentation.*specs.*code.*completeness.*correctness.*testability"; then
    echo "✅ Comprehensive audit scope (docs, specs, code, testability) specified"
else
    echo "❌ Missing comprehensive audit scope"
    exit 1
fi

echo ""
echo "📋 Testing audit methodology validation..."

# Validate 6-step scanning method
SCAN_STEPS=("spine.*README.*docs" "build.*quality.*config" "CI.*CD.*workflow" "core.*code.*flow" "tests.*types.*structure" "security.*dependency")
STEP_COUNT=0
for step in "${SCAN_STEPS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$step"; then
        echo "✅ Scan methodology step: $step"
        STEP_COUNT=$((STEP_COUNT + 1))
    fi
done

if [ $STEP_COUNT -ge 5 ]; then
    echo "✅ Comprehensive 6-step scanning methodology specified"
else
    echo "❌ Incomplete scanning methodology ($STEP_COUNT/6 steps)"
    exit 1
fi

# Validate traceability analysis
if echo "$SYSTEM_CONTENT" | grep -q -i "trace.*requirement.*design.*implementation.*test.*gap"; then
    echo "✅ Requirements traceability analysis specified"
else
    echo "❌ Missing traceability analysis"
    exit 1
fi

echo ""
echo "📊 Testing assessment framework validation..."

# Validate 8-category scoring system
SCORING_CATEGORIES=("req.*traceability" "architecture.*soundness" "code.*quality" "test.*strategy" "CI.*CD.*gates" "docs.*onboarding" "security.*dependencies" "operational.*readiness")
for category in "${SCORING_CATEGORIES[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$category"; then
        echo "✅ Scoring category: $category"
    else
        echo "❌ Missing scoring category: $category"
        exit 1
    fi
done

# Validate 0-5 scoring scale
if echo "$SYSTEM_CONTENT" | grep -q -i "scoring.*0.*5"; then
    echo "✅ Scoring scale (0-5) with justification specified"
else
    echo "❌ Missing scoring scale specification"
    exit 1
fi

echo ""
echo "📝 Testing deliverable requirements..."

# Validate required deliverables
REQUIRED_DELIVERABLES=("audit.*action.*plan" "task.*backlog.*yaml" "copilot.*instructions" "executive.*summary" "current.*state.*overview" "prioritized.*action.*plan")
for deliverable in "${REQUIRED_DELIVERABLES[@]}"; do
    if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "$deliverable"; then
        echo "✅ Required deliverable: $deliverable"
    else
        echo "❌ Missing required deliverable: $deliverable"
        exit 1
    fi
done

# Validate executive summary constraint
if echo "$USER_CONTENT" | grep -q -i "executive.*summary.*≤.*12.*bullet"; then
    echo "✅ Executive summary constraint (≤12 bullets) specified"
else
    echo "❌ Missing executive summary constraint"
    exit 1
fi

echo ""
echo "🛡️ Testing security and compliance validation..."

# Validate security awareness
if echo "$SYSTEM_CONTENT" | grep -q -i "redact.*secret.*escalate.*critical"; then
    echo "✅ Security awareness (secret redaction, escalation) specified"
else
    echo "❌ Missing security awareness"
    exit 1
fi

# Validate evidence-based approach
if echo "$SYSTEM_CONTENT" | grep -q -i "cite.*evidence.*file.*path.*excerpt"; then
    echo "✅ Evidence-based approach with file citations specified"
else
    echo "❌ Missing evidence-based approach"
    exit 1
fi

# Validate legal boundary awareness
if echo "$SYSTEM_CONTENT" | grep -q -i "no.*legal.*assertion.*flag.*legal.*review"; then
    echo "✅ Legal boundary awareness specified"
else
    echo "❌ Missing legal boundary awareness"
    exit 1
fi

echo ""
echo "🎯 Quality methodology validation..."

# Validate code quality heuristics
QUALITY_HEURISTICS=("god.*object" "long.*function" "cyclic.*dep" "missing.*seam" "impure.*domain" "flaky.*test")
HEURISTIC_COUNT=0
for heuristic in "${QUALITY_HEURISTICS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$heuristic"; then
        HEURISTIC_COUNT=$((HEURISTIC_COUNT + 1))
    fi
done

if [ $HEURISTIC_COUNT -ge 4 ]; then
    echo "✅ Code quality heuristics specified ($HEURISTIC_COUNT/6 patterns)"
else
    echo "❌ Insufficient code quality heuristics ($HEURISTIC_COUNT/6 patterns)"
    exit 1
fi

# Validate scalability constraints
if echo "$SYSTEM_CONTENT" | grep -q -i "repo.*too.*large.*chunk.*coverage\|token.*budget.*risk"; then
    echo "✅ Scalability constraints and chunking strategy specified"
else
    echo "❌ Missing scalability constraints"
    exit 1
fi

echo ""
echo "🔍 Quality assurance validation..."

# Validate reasoning effort appropriate for comprehensive audit
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for comprehensive audit: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for comprehensive audit: $REASONING_EFFORT"
    exit 1
fi

# Validate verbosity appropriate for detailed analysis
VERBOSITY=$(jq -r '.parameters.verbosity // "not_specified"' "$PROMPT_FILE")
if [[ "$VERBOSITY" == "medium" ]]; then
    echo "✅ Appropriate verbosity for detailed analysis: $VERBOSITY"
else
    echo "❌ Inappropriate verbosity for audit reporting: $VERBOSITY"
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

# Validate prioritization framework
if echo "$USER_CONTENT" | grep -q -i "priority.*P0.*P2.*effort.*S.*M.*L.*impact.*low.*med.*high"; then
    echo "✅ Comprehensive prioritization framework specified"
else
    echo "❌ Missing comprehensive prioritization framework"
    exit 1
fi

# Validate output customization options
if echo "$USER_CONTENT" | grep -q -i "depth.*light.*standard.*deep\|deliverables.*set.*flags"; then
    echo "✅ Output customization options specified"
else
    echo "❌ Missing output customization options"
    exit 1
fi

echo ""
echo "✅ Repo-audit prompt validation complete!"
echo "📊 Validated: JSON schema, comprehensive audit methodology, security awareness, quality heuristics, scalability considerations"
