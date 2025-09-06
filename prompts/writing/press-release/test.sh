#!/bin/bash

set -e

echo "Testing press-release prompt..."

# Test that the file exists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/press-release.json"
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
echo "📰 Testing press release prompt functionality..."

# Validate corporate communications role
if echo "$SYSTEM_CONTENT" | grep -q -i "corporate.*communications\|press.*release"; then
    echo "✅ Corporate communications role specified"
else
    echo "❌ Missing corporate communications role specification"
    exit 1
fi

# Validate required output sections
REQUIRED_SECTIONS=("Headline" "Subheadline" "Release Body" "Quotes" "Boilerplate" "Media Contact")
MISSING_SECTIONS=()
for section in "${REQUIRED_SECTIONS[@]}"; do
    if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "$section"; then
        echo "✅ Output section specified: $section"
    else
        MISSING_SECTIONS+=("$section")
    fi
done

if [ ${#MISSING_SECTIONS[@]} -gt 0 ]; then
    echo "❌ Missing required sections: ${MISSING_SECTIONS[*]}"
    exit 1
fi

# Validate optional CTA section mentioned
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "CTA\|call.*action"; then
    echo "✅ Optional CTA section mentioned"
else
    echo "⚠️  Optional CTA section not mentioned"
fi

echo ""
echo "📝 Press release structure validation..."

# Validate headline constraints
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "headline.*≤.*12.*word\|headline.*12.*word"; then
    echo "✅ Headline word constraint specified (≤12 words)"
else
    echo "❌ Missing headline word constraint"
    exit 1
fi

# Validate opening paragraph constraints
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "opening.*≤.*80.*word\|opening.*80.*word"; then
    echo "✅ Opening paragraph constraint specified (≤80 words)"
else
    echo "❌ Missing opening paragraph constraint"
    exit 1
fi

# Validate 5W1H structure
if echo "$SYSTEM_CONTENT" | grep -q -i "who.*what.*when.*where.*why\|5W"; then
    echo "✅ 5W1H structure specified for opening"
else
    echo "❌ Missing 5W1H structure for opening"
    exit 1
fi

echo ""
echo "🎯 Professional journalism standards..."

# Validate factual tone requirements
if echo "$SYSTEM_CONTENT" | grep -q -i "neutral.*factual\|factual.*tone\|unverifiable.*claims"; then
    echo "✅ Factual tone and verification standards specified"
else
    echo "❌ Missing factual tone requirements"
    exit 1
fi

# Validate quote handling
if echo "$SYSTEM_CONTENT" | grep -q -i "placeholder.*quote\|quote.*placeholder"; then
    echo "✅ Quote placeholder handling specified"
else
    echo "❌ Missing quote placeholder handling"
    exit 1
fi

# Validate media audience focus
if echo "$USER_CONTENT" | grep -q -i "press.*media\|industry.*media"; then
    echo "✅ Media audience focus specified"
else
    echo "❌ Missing media audience specification"
    exit 1
fi

echo ""
echo "📈 Input and content validation..."

# Validate product details input handling
if echo "$SYSTEM_CONTENT" | grep -q -i "product_details\|product.*details"; then
    echo "✅ Product details input handling found"
else
    echo "⚠️  Product details input handling not explicitly specified"
fi

# Validate professional standards
if echo "$USER_CONTENT" | grep -q -i "professional\|factual"; then
    echo "✅ Professional communication standards specified"
else
    echo "❌ Missing professional communication standards"
    exit 1
fi

echo ""
echo "🔍 Risk management validation..."

# Validate reasoning effort appropriate for press release
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "medium" || "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for press release: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for press communication: $REASONING_EFFORT"
    exit 1
fi

# Validate risk awareness for missing information
if echo "$SYSTEM_CONTENT" | grep -q -i "placeholder\|missing.*details\|generic"; then
    echo "✅ Risk awareness for missing information mentioned"
else
    echo "❌ Missing risk awareness for incomplete information"
    exit 1
fi

# Validate structured format requirements
if echo "$SYSTEM_CONTENT $USER_CONTENT" | grep -q -i "structured\|markdown.*section"; then
    echo "✅ Structured format requirements specified"
else
    echo "❌ Missing structured format requirements"
    exit 1
fi

echo ""
echo "✅ Press release prompt validation complete!"
echo "📊 Validated: JSON schema, press release structure, journalism standards, word constraints, factual tone"