#!/bin/bash

set -e

echo "Testing provider-research prompt..."

# Test that the file exists
PROMPT_FILE="/Users/robertdozier/workspace/rad-prompt-hub/prompts/research/provider-research/provider-research.json"
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
echo "🏢 Testing provider research functionality..."

# Validate local provider research analyst role
if echo "$SYSTEM_CONTENT" | grep -q -i "local.*provider.*research.*scoring.*analyst"; then
    echo "✅ Local provider research and scoring analyst role specified"
else
    echo "❌ Missing provider research analyst role specification"
    exit 1
fi

# Validate comprehensive evaluation focus
if echo "$SYSTEM_CONTENT" | grep -q -i "research.*evaluate.*local.*provider"; then
    echo "✅ Comprehensive local provider evaluation focus specified"
else
    echo "❌ Missing comprehensive evaluation focus"
    exit 1
fi

echo ""
echo "📋 Testing deliverable structure validation..."

# Validate required deliverables
REQUIRED_DELIVERABLES=("Shortlist" "High-Risk list" "Provider Profiles" "Methodology" "dataset JSON")
MISSING_DELIVERABLES=()
for deliverable in "${REQUIRED_DELIVERABLES[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$deliverable"; then
        echo "✅ Deliverable specified: $deliverable"
    else
        MISSING_DELIVERABLES+=("$deliverable")
    fi
done

if [ ${#MISSING_DELIVERABLES[@]} -gt 0 ]; then
    echo "❌ Missing required deliverables: ${MISSING_DELIVERABLES[*]}"
    exit 1
fi

# Validate comprehensive workflow
if echo "$SYSTEM_CONTENT" | grep -q -i "workflow.*condensed.*intake.*discovery.*reviews.*scoring.*synthesis"; then
    echo "✅ Comprehensive 5-step workflow specified"
else
    echo "⚠️  Workflow steps present but not explicitly labeled as comprehensive"
fi

echo ""
echo "📊 Testing scoring framework validation..."

# Validate RCAS scoring system
if echo "$SYSTEM_CONTENT" | grep -q -i "RCAS.*0.*100.*>=.*12.*review"; then
    echo "✅ RCAS scoring system (0-100, >=12 reviews) specified"
else
    echo "❌ Missing RCAS scoring system"
    exit 1
fi

# Validate RCAS components and weights
RCAS_COMPONENTS=("history.*25" "recency.*20" "specificity.*25" "cross.*platform.*20" "owner.*response.*10")
for component in "${RCAS_COMPONENTS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$component"; then
        echo "✅ RCAS component specified: $component"
    else
        echo "❌ Missing RCAS component: $component"
        exit 1
    fi
done

# Validate UER framework
if echo "$SYSTEM_CONTENT" | grep -q -i "UER.*underserved.*expectation.*gap"; then
    echo "✅ UER (Underserved vs Expectation Gap) framework specified"
else
    echo "❌ Missing UER framework"
    exit 1
fi

# Validate Suitability scoring with weights
if echo "$SYSTEM_CONTENT" | grep -q -i "suitability.*weights.*sum.*100.*domain_expertise.*25"; then
    echo "✅ Suitability scoring framework with detailed weights specified"
else
    echo "❌ Missing suitability scoring framework"
    exit 1
fi

echo ""
echo "🔍 Source diversity and methodology validation..."

# Validate comprehensive source coverage
SOURCES=("BBB" "Google" "Yelp" "FB Pages" "forums" "subreddits" "directories" "associations" "news")
SOURCE_COUNT=0
for source in "${SOURCES[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$source"; then
        SOURCE_COUNT=$((SOURCE_COUNT + 1))
    fi
done

if [ $SOURCE_COUNT -ge 6 ]; then
    echo "✅ Comprehensive source diversity specified ($SOURCE_COUNT/9 sources)"
else
    echo "❌ Insufficient source diversity ($SOURCE_COUNT/9 sources)"
    exit 1
fi

# Validate deduplication methodology
if echo "$SYSTEM_CONTENT" | grep -q -i "dedupe.*name.*address.*phone"; then
    echo "✅ Provider deduplication methodology specified"
else
    echo "❌ Missing deduplication methodology"
    exit 1
fi

# Validate review sampling methodology
if echo "$SYSTEM_CONTENT" | grep -q -i "positive.*negative.*last.*36.*months"; then
    echo "✅ Review sampling methodology with recency weighting specified"
else
    echo "❌ Missing review sampling methodology"
    exit 1
fi

echo ""
echo "🎯 Quality and risk validation..."

# Validate citation requirements
if echo "$SYSTEM_CONTENT" | grep -q -i "cite.*every.*non.*obvious.*claim.*URL.*retrieval.*date"; then
    echo "✅ Comprehensive citation requirements specified"
else
    echo "❌ Missing citation requirements"
    exit 1
fi

# Validate quote length limits
if echo "$SYSTEM_CONTENT" | grep -q -i "quote.*snippet.*≤.*25.*word"; then
    echo "✅ Quote length limits specified"
else
    echo "❌ Missing quote length limits"
    exit 1
fi

# Validate high-risk criteria
if echo "$SYSTEM_CONTENT" | grep -q -i "high.*risk.*>=.*2.*independent.*signal"; then
    echo "✅ High-risk validation criteria (>=2 independent signals) specified"
else
    echo "❌ Missing high-risk validation criteria"
    exit 1
fi

# Validate radius expansion logic
if echo "$SYSTEM_CONTENT" | grep -q -i "expand.*radius.*60.*90.*label.*expansion"; then
    echo "✅ Radius expansion logic with clear labeling specified"
else
    echo "❌ Missing radius expansion logic"
    exit 1
fi

echo ""
echo "🔍 Quality assurance validation..."

# Validate reasoning effort appropriate for complex research
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for complex provider research: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for complex research: $REASONING_EFFORT"
    exit 1
fi

# Validate business stakeholder audience
if echo "$USER_CONTENT" | grep -q -i "business.*stakeholder.*selecting.*long.*term.*partner"; then
    echo "✅ Business stakeholder audience for long-term partnership specified"
else
    echo "❌ Missing business stakeholder audience specification"
    exit 1
fi

# Validate risk awareness
ASSUMPTIONS=$(jq -r '.assumptions // [] | length' "$PROMPT_FILE")
RISKS=$(jq -r '.risks_or_notes // [] | length' "$PROMPT_FILE")
if [[ "$ASSUMPTIONS" -gt 0 && "$RISKS" -gt 0 ]]; then
    echo "✅ Comprehensive assumptions and risks documented"
else
    echo "❌ Missing assumption or risk documentation"
    exit 1
fi

# Validate dataset output format
if echo "$USER_CONTENT" | grep -q -i "markdown.*report.*embedded.*JSON.*dataset.*fenced.*code.*block"; then
    echo "✅ Dataset output format (Markdown + embedded JSON) specified"
else
    echo "❌ Missing dataset output format specification"
    exit 1
fi

# Validate astroturfing risk awareness
if jq -r '.risks_or_notes[]' "$PROMPT_FILE" | grep -q -i "astroturfed.*reviews.*RCAS"; then
    echo "✅ Astroturfing risk awareness documented"
else
    echo "❌ Missing astroturfing risk awareness"
    exit 1
fi

echo ""
echo "✅ Provider-research prompt validation complete!"
echo "📊 Validated: JSON schema, comprehensive research methodology, multi-framework scoring, source diversity, quality assurance"