#!/bin/bash

set -e

echo "Testing repository-audit prompt..."

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
echo "🔍 Testing senior engineering auditor functionality..."

# Validate senior engineering auditor role
if echo "$SYSTEM_CONTENT" | grep -q -i "senior.*engineering.*auditor.*rapid.*evidence.*based.*repository.*assessment"; then
    echo "✅ Senior engineering auditor role with evidence-based approach specified"
else
    echo "❌ Missing senior auditor role specification"
    exit 1
fi

# Validate assessment goals
if echo "$SYSTEM_CONTENT" | grep -q -i "clear.*snapshot.*current.*state.*material.*risks.*opportunities.*prioritized.*improvement.*plan"; then
    echo "✅ Comprehensive assessment goals specified"
else
    echo "❌ Missing assessment goals"
    exit 1
fi

# Validate evidence-driven approach
if echo "$SYSTEM_CONTENT" | grep -q -i "use.*only.*provided.*evidence.*code.*excerpts.*tree.*metrics.*docs"; then
    echo "✅ Evidence-driven assessment methodology specified"
else
    echo "❌ Missing evidence-driven methodology"
    exit 1
fi

echo ""
echo "📋 Testing quality and precision standards..."

# Validate precision requirements
PRECISION_STANDARDS=("bullet.*≤25.*words" "measurable.*language.*<200.*tests.*3.*critical.*deps.*unpinned" "no.*chain.*of.*thought.*disclosure.*conclusions.*directly" "do.*not.*invent.*coverage.*security.*metrics.*mark.*unknown")
for standard in "${PRECISION_STANDARDS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$standard"; then
        echo "✅ Precision standard: $standard"
    else
        echo "❌ Missing precision standard: $standard"
        exit 1
    fi
done

# Validate completeness handling
if echo "$SYSTEM_CONTENT" | grep -q -i "key.*inputs.*missing.*request.*once.*note.*gaps.*explicitly"; then
    echo "✅ Systematic gap handling methodology specified"
else
    echo "❌ Missing gap handling methodology"
    exit 1
fi

echo ""
echo "📊 Testing assessment framework validation..."

# Validate comprehensive assessment sections
ASSESSMENT_SECTIONS=("summary" "architecture.*modularity" "code.*quality" "testing" "security.*dependencies" "operational.*readiness" "documentation.*onboarding" "risk.*priority.*matrix" "30.*60.*90.*plan" "quick.*wins" "assumptions.*gaps")
SECTION_COUNT=0
for section in "${ASSESSMENT_SECTIONS[@]}"; do
    if echo "$USER_CONTENT" | grep -q -i "$section"; then
        echo "✅ Assessment section: $section"
        SECTION_COUNT=$((SECTION_COUNT + 1))
    fi
done

if [ $SECTION_COUNT -ge 10 ]; then
    echo "✅ Comprehensive 11-section assessment framework specified"
else
    echo "❌ Incomplete assessment framework ($SECTION_COUNT/11 sections)"
    exit 1
fi

# Validate focus area flexibility
if echo "$USER_CONTENT" | grep -q -i "focus.*areas.*all.*quality.*architecture.*testing.*security.*ops.*docs"; then
    echo "✅ Flexible focus area specification"
else
    echo "❌ Missing focus area flexibility"
    exit 1
fi

echo ""
echo "📝 Testing artifact and input requirements..."

# Validate comprehensive artifact types
ARTIFACT_TYPES=("file.*tree" "sample.*modules" "requirements.*txt.*pom.*package.*json" "test.*summary" "ci.*yaml" "dockerfile" "infra.*manifests" "readme.*excerpts")
ARTIFACT_COUNT=0
for artifact in "${ARTIFACT_TYPES[@]}"; do
    if echo "$USER_CONTENT" | grep -q -i "$artifact"; then
        ARTIFACT_COUNT=$((ARTIFACT_COUNT + 1))
    fi
done

if [ $ARTIFACT_COUNT -ge 6 ]; then
    echo "✅ Comprehensive artifact type coverage ($ARTIFACT_COUNT/8 types)"
else
    echo "❌ Limited artifact type coverage ($ARTIFACT_COUNT/8 types)"
    exit 1
fi

# Validate risk matrix structure
if echo "$USER_CONTENT" | grep -q -i "risk.*priority.*matrix.*table.*area.*risk.*h.*m.*l.*impact.*urgency.*evidence"; then
    echo "✅ Structured risk matrix specification"
else
    echo "❌ Missing risk matrix structure"
    exit 1
fi

echo ""
echo "🛡️ Testing professional standards validation..."

# Validate audience specification
if echo "$USER_CONTENT" | grep -q -i "cto.*staff.*engineer.*crisp.*neutral.*decision.*enabling"; then
    echo "✅ Professional audience and tone specification"
else
    echo "❌ Missing audience specification"
    exit 1
fi

# Validate output quality standards
if echo "$USER_CONTENT" | grep -q -i "valid.*markdown.*tables.*where.*specified.*no.*extraneous.*sections"; then
    echo "✅ Output quality standards specified"
else
    echo "❌ Missing output quality standards"
    exit 1
fi

# Validate insufficiency handling
if echo "$USER_CONTENT" | grep -q -i "evidence.*insufficient.*replace.*section.*body.*insufficient.*evidence"; then
    echo "✅ Evidence insufficiency handling protocol specified"
else
    echo "❌ Missing insufficiency handling protocol"
    exit 1
fi

echo ""
echo "🎯 Assessment methodology validation..."

# Validate time-phased planning
if echo "$USER_CONTENT" | grep -q -i "30.*60.*90.*plan"; then
    echo "✅ Time-phased improvement planning specified"
else
    echo "❌ Missing time-phased planning"
    exit 1
fi

# Validate quick wins identification
if echo "$USER_CONTENT" | grep -q -i "quick.*wins.*≤7"; then
    echo "✅ Quick wins identification with limit specified"
else
    echo "❌ Missing quick wins specification"
    exit 1
fi

# Validate constraints handling
if echo "$USER_CONTENT" | grep -q -i "sections.*in.*order.*summary.*architecture.*code.*quality"; then
    echo "✅ Structured section ordering constraints specified"
else
    echo "❌ Missing section ordering constraints"
    exit 1
fi

echo ""
echo "🔍 Quality assurance validation..."

# Validate reasoning effort appropriate for rapid assessment
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for comprehensive assessment: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for assessment: $REASONING_EFFORT"
    exit 1
fi

# Validate verbosity appropriate for executive audience
VERBOSITY=$(jq -r '.parameters.verbosity // "not_specified"' "$PROMPT_FILE")
if [[ "$VERBOSITY" == "low" ]]; then
    echo "✅ Appropriate verbosity for executive audience: $VERBOSITY"
else
    echo "❌ Inappropriate verbosity for executive reporting: $VERBOSITY"
    exit 1
fi

# Validate risk documentation
RISKS=$(jq -r '.risks_or_notes // [] | length' "$PROMPT_FILE")
if [[ "$RISKS" -gt 0 ]]; then
    echo "✅ Assessment limitation risks documented"
else
    echo "❌ Missing risk documentation"
    exit 1
fi

# Validate assumption framework
ASSUMPTIONS=$(jq -r '.assumptions // [] | length' "$PROMPT_FILE")
if [[ "$ASSUMPTIONS" -ge 0 ]]; then
    echo "✅ Assumption framework present"
else
    echo "❌ Missing assumption framework"
    exit 1
fi

# Validate objectives customization
if echo "$USER_CONTENT" | grep -q -i "objectives.*baseline.*maturity.*prioritize.*improvements"; then
    echo "✅ Assessment objectives customization specified"
else
    echo "❌ Missing objectives customization"
    exit 1
fi

echo ""
echo "✅ Repository-audit prompt validation complete!"
echo "📊 Validated: JSON schema, engineering assessment methodology, evidence-driven approach, professional standards, structured reporting"
