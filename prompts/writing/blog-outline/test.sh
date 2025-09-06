#!/bin/bash

# Test script for blog-outline prompt  
# This script validates that the prompt generates comprehensive blog outlines with SEO considerations

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
echo "📝 Testing blog outline prompt functionality..."

# Check system message for blog content strategy
SYSTEM_CONTENT=$(jq -r '.messages[] | select(.role == "system") | .content' "$JSON_FILE")

# Validate content strategy components
if echo "$SYSTEM_CONTENT" | grep -q -i "title.*option\|audience.*angle\|outline\|cta\|seo"; then
    echo "✅ Content strategy components specified"
else
    echo "❌ Missing content strategy components"
    exit 1
fi

# Check for SEO considerations
if echo "$SYSTEM_CONTENT" | grep -q -i "seo\|keyword\|search"; then
    echo "✅ SEO considerations mentioned"
else
    echo "❌ Missing SEO considerations"
    exit 1
fi

# Validate keyword categorization
if echo "$SYSTEM_CONTENT" | grep -q -i "primary.*long.*tail\|long.*tail.*primary"; then
    echo "✅ Keyword categorization (primary vs long-tail) specified"
else
    echo "⚠️  Keyword categorization not clearly specified"
fi

# Check user message template
USER_CONTENT=$(jq -r '.messages[] | select(.role == "user") | .content' "$JSON_FILE")

# Validate required output sections - check for the actual content in constraints
if echo "$USER_CONTENT" | grep -q -i "Sections:.*Title Options.*Audience.*Angle.*Outline.*CTA.*SEO Keywords"; then
    echo "✅ All required sections found in constraints format"
    SECTION_COUNT=5
else
    # Fallback to individual section checks
    REQUIRED_SECTIONS=("Title Options" "Audience" "Outline" "CTA" "SEO Keywords")
    SECTION_COUNT=0
    
    for section in "${REQUIRED_SECTIONS[@]}"; do
        if echo "$USER_CONTENT" | grep -q -i "$section"; then
            echo "✅ Output section specified: $section"
            ((SECTION_COUNT++))
        fi
    done
fi

if [[ $SECTION_COUNT -lt 4 ]]; then
    echo "❌ Missing critical output sections (found $SECTION_COUNT, need at least 4)"
    exit 1
fi

echo ""
echo "🎯 Content structure validation..."

# Check for hierarchical outline requirement
if echo "$SYSTEM_CONTENT" | grep -q -i "hierarchical\|heading\|structure\|markdown"; then
    echo "✅ Hierarchical outline structure specified"
else
    echo "⚠️  Hierarchical outline structure not clearly specified"
fi

# Validate topic input requirement
if echo "$SYSTEM_CONTENT" | grep -q -i "topic\|subject\|theme"; then
    echo "✅ Topic input handling found (in system message)"
elif echo "$USER_CONTENT" | grep -q -i "topic\|subject\|theme"; then
    echo "✅ Topic input placeholder found"
else
    echo "⚠️  Topic input not explicitly specified in template (handled via eagerness)"
fi

# Check for audience consideration
if echo "$SYSTEM_CONTENT" | grep -q -i "audience\|reader\|target"; then
    echo "✅ Audience consideration mentioned"
else
    echo "❌ Missing audience consideration"
    exit 1
fi

echo ""
echo "📈 SEO and engagement validation..."

# Check for engagement elements
if echo "$SYSTEM_CONTENT" | grep -q -i "engag\|hook\|value\|flow"; then
    echo "✅ Engagement elements mentioned"
else
    echo "⚠️  Engagement elements not explicitly mentioned"
fi

# Validate CTA (Call-to-Action) consideration
if echo "$SYSTEM_CONTENT" | grep -q -i "cta\|call.*action\|conversion"; then
    echo "✅ CTA considerations specified"
else
    echo "❌ Missing CTA considerations"
    exit 1
fi

# Check for content quality guardrails
if echo "$SYSTEM_CONTENT" | grep -q -i "filler\|value\|intent"; then
    echo "✅ Content quality guardrails present"
else
    echo "⚠️  Content quality guardrails not explicitly mentioned"
fi

echo ""
echo "🔍 Professional standards validation..."

# Check reasoning effort for content strategy
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort' "$JSON_FILE")
if [[ "$REASONING_EFFORT" == "medium" ]]; then
    echo "✅ Appropriate reasoning effort for content strategy: $REASONING_EFFORT"
else
    echo "⚠️  Reasoning effort unexpected for content strategy: $REASONING_EFFORT"
fi

# Validate assumption handling
if echo "$SYSTEM_CONTENT" | grep -q -i "assumption\|clarif"; then
    echo "✅ Assumption handling mentioned"
else
    echo "⚠️  Assumption handling not explicitly mentioned"
fi

# Check for professional tone requirements
if echo "$USER_CONTENT" | grep -q -i "professional\|authoritative\|clear"; then
    echo "✅ Professional tone requirements specified"
else
    echo "⚠️  Professional tone not explicitly required"
fi

echo ""
echo "✅ Blog outline prompt validation complete!"
echo "📊 Validated: JSON schema, content strategy, SEO considerations, outline structure, engagement elements"

exit 0