#!/bin/bash

# Test script for cajun-authentic-researcher prompt
# Validates authentic Cajun recipe research prompt structure and requirements

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
echo "🌶️  Testing Cajun authenticity components..."

# Extract system message for validation
SYSTEM_CONTENT=$(jq -r '.messages[] | select(.role == "system") | .content' "$JSON_FILE")

# Validate parish-specific references
if echo "$SYSTEM_CONTENT" | grep -q "New Iberia.*Avery Island.*Lafayette"; then
    echo "✅ Parish-specific references present (New Iberia, Avery Island, Lafayette)"
else
    echo "❌ Missing parish-specific references"
    exit 1
fi

# Check for canonical source citations
REQUIRED_SOURCES=("Marcelle Bienvenu" "John D. Folse" "Donald Link" "Isaac Toups")
MISSING_SOURCES=()
for source in "${REQUIRED_SOURCES[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q "$source"; then
        echo "✅ Canonical source cited: $source"
    else
        MISSING_SOURCES+=("$source")
    fi
done

if [[ ${#MISSING_SOURCES[@]} -gt 0 ]]; then
    echo "❌ Missing canonical sources: ${MISSING_SOURCES[*]}"
    exit 1
fi

# Validate additional authoritative sources
if echo "$SYSTEM_CONTENT" | grep -q "Southern Foodways Alliance.*UL Lafayette.*LSU"; then
    echo "✅ Additional archival sources referenced"
else
    echo "⚠️  Additional archival sources not fully specified"
fi

echo ""
echo "🔥 Testing heat and flavor architecture..."

# Check heat default and customization
if echo "$SYSTEM_CONTENT" | grep -q "Heat default.*4.*5"; then
    echo "✅ Default heat level specified (4–5/5)"
else
    echo "❌ Missing or incorrect heat default"
    exit 1
fi

# Validate user content for heat knobs
USER_CONTENT=$(jq -r '.messages[] | select(.role == "user") | .content' "$JSON_FILE")
if echo "$USER_CONTENT" | grep -q "HEAT={{"; then
    echo "✅ Heat customization knob available"
else
    echo "❌ Missing heat customization"
    exit 1
fi

# Check for pepper craft and layering
if echo "$SYSTEM_CONTENT" | grep -q -i "pepper.*bloom.*layer"; then
    echo "✅ Pepper craft and heat layering specified"
else
    echo "⚠️  Pepper craft not explicitly detailed"
fi

echo ""
echo "🥘 Testing celery-free trinity variant..."

# Validate celery-free default
if echo "$SYSTEM_CONTENT" | grep -q "Celery-free.*default"; then
    echo "✅ Celery-free default specified"
else
    echo "❌ Missing celery-free default"
    exit 1
fi

# Check trinity mapping
if echo "$SYSTEM_CONTENT" | grep -q "Onion.*Green bell pepper.*Parsley stems.*Fennel"; then
    echo "✅ Alternative trinity mapping provided (onion:pepper:parsley:fennel)"
else
    echo "❌ Missing trinity mapping details"
    exit 1
fi

# Validate trinity ratios
if echo "$SYSTEM_CONTENT" | grep -q "2.*:.*1.*:.*0.5.*:.*0.5"; then
    echo "✅ Trinity ratios specified"
else
    echo "⚠️  Trinity ratios not clearly specified"
fi

echo ""
echo "🛢️  Testing fat and oil preferences..."

# Validate anti-inflammatory oil default
if echo "$SYSTEM_CONTENT" | grep -q "anti-inflammatory oil"; then
    echo "✅ Anti-inflammatory oil preference stated"
else
    echo "⚠️  Anti-inflammatory focus not explicitly stated"
fi

# Check for oil options
if echo "$SYSTEM_CONTENT" | grep -q "extra-virgin olive oil.*avocado oil.*high-oleic"; then
    echo "✅ Multiple healthy oil options provided"
else
    echo "❌ Missing healthy oil options"
    exit 1
fi

# Validate oil selection rationale requirement
if echo "$SYSTEM_CONTENT" | grep -q "smoke point.*flavor.*neutrality"; then
    echo "✅ Oil selection rationale criteria specified"
else
    echo "⚠️  Oil selection rationale not fully specified"
fi

# Check user knobs for fat/oil customization
if echo "$USER_CONTENT" | grep -q "FAT={{" && echo "$USER_CONTENT" | grep -q "OIL={{"; then
    echo "✅ Fat and oil customization knobs available"
else
    echo "❌ Missing fat/oil customization"
    exit 1
fi

echo ""
echo "🔥 Testing smoke craft components..."

# Validate smoke default
if echo "$SYSTEM_CONTENT" | grep -q "Smoke default.*On.*medium-high"; then
    echo "✅ Smoke default specified (medium-high)"
else
    echo "❌ Missing or incorrect smoke default"
    exit 1
fi

# Check wood types
WOODS=("pecan" "oak" "hickory")
WOOD_COUNT=0
for wood in "${WOODS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$wood"; then
        WOOD_COUNT=$((WOOD_COUNT + 1))
    fi
done
# Check for fruit woods (can be "fruit woods" or "fruitwood")
if echo "$SYSTEM_CONTENT" | grep -q -i "fruit.*wood"; then
    WOOD_COUNT=$((WOOD_COUNT + 1))
fi

if [[ $WOOD_COUNT -ge 3 ]]; then
    echo "✅ Multiple wood types specified ($WOOD_COUNT/4)"
else
    echo "⚠️  Limited wood type options ($WOOD_COUNT/4)"
fi

# Validate smoke staging and timing
if echo "$SYSTEM_CONTENT" | grep -q -i "stage.*smoke.*clean.*blue.*bitter"; then
    echo "✅ Smoke staging and quality control specified"
else
    echo "⚠️  Smoke staging not fully specified"
fi

# Check user knobs for smoke customization
if echo "$USER_CONTENT" | grep -q "SMOKE={{" && echo "$USER_CONTENT" | grep -q "WOOD={{"; then
    echo "✅ Smoke and wood customization knobs available"
else
    echo "❌ Missing smoke customization"
    exit 1
fi

echo ""
echo "🍲 Testing technique and flavor architecture..."

# Validate roux mastery
if echo "$SYSTEM_CONTENT" | grep -q -i "roux.*mastery.*peanut.*chocolate"; then
    echo "✅ Roux progression specified"
else
    echo "❌ Missing roux mastery details"
    exit 1
fi

# Check fond and browning
if echo "$SYSTEM_CONTENT" | grep -q -i "fond.*brown.*sear.*deglaze"; then
    echo "✅ Fond development and deglazing specified"
else
    echo "⚠️  Fond development not fully specified"
fi

# Validate stock quality requirements
if echo "$SYSTEM_CONTENT" | grep -q -i "unsalted.*defatted.*stock"; then
    echo "✅ Stock quality requirements specified"
else
    echo "⚠️  Stock requirements not fully specified"
fi

# Check acid and herb finish
if echo "$SYSTEM_CONTENT" | grep -q -i "acid.*herb.*finish.*vinegar.*lemon"; then
    echo "✅ Acid and herb finishing techniques specified"
else
    echo "⚠️  Finishing techniques not fully specified"
fi

echo ""
echo "📋 Testing output contract..."

# Validate required output sections
REQUIRED_SECTIONS=("Research Summary" "Technique Notes" "Recipe" "Parish Variations" "Make-Ahead" "Quiet Salt Line")
MISSING_SECTIONS=()

for section in "${REQUIRED_SECTIONS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q "$section"; then
        echo "✅ Output section required: $section"
    else
        MISSING_SECTIONS+=("$section")
    fi
done

if [[ ${#MISSING_SECTIONS[@]} -gt 0 ]]; then
    echo "❌ Missing output sections: ${MISSING_SECTIONS[*]}"
    exit 1
fi

# Check for measurement specifications
if echo "$SYSTEM_CONTENT" | grep -q "grams.*cups"; then
    echo "✅ Dual measurement system required (grams + cups)"
else
    echo "⚠️  Dual measurements not specified"
fi

# Validate timestamp requirements
if echo "$SYSTEM_CONTENT" | grep -q "timestamp"; then
    echo "✅ Timestamp requirements specified"
else
    echo "⚠️  Timestamps not explicitly required"
fi

echo ""
echo "🧂 Testing minceur/anti-inflammatory rails..."

# Validate quiet salt approach
if echo "$SYSTEM_CONTENT" | grep -q "salt.*support.*not.*lead"; then
    echo "✅ Quiet salt philosophy specified"
else
    echo "❌ Missing quiet salt approach"
    exit 1
fi

# Check for non-salt flavor techniques
if echo "$SYSTEM_CONTENT" | grep -q "time.*brown.*smoke.*acid.*herb"; then
    echo "✅ Non-salt flavor building techniques specified"
else
    echo "⚠️  Non-salt techniques not fully enumerated"
fi

# Validate food safety requirements
if echo "$SYSTEM_CONTENT" | grep -q -i "food-safety.*temp.*cooling.*storage"; then
    echo "✅ Food safety requirements included"
else
    echo "⚠️  Food safety not explicitly required"
fi

echo ""
echo "🎯 Testing prompt parameters..."

# Check reasoning effort
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort' "$JSON_FILE")
if [[ "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ High reasoning effort for research: $REASONING_EFFORT"
else
    echo "⚠️  Reasoning effort not set to high: $REASONING_EFFORT"
fi

# Check temperature for consistency
TEMPERATURE=$(jq -r '.parameters.temperature' "$JSON_FILE")
if [[ $(awk "BEGIN {print ($TEMPERATURE <= 0.3)}") -eq 1 ]]; then
    echo "✅ Low temperature for consistent output: $TEMPERATURE"
else
    echo "⚠️  Temperature higher than expected: $TEMPERATURE"
fi

# Validate verbosity
VERBOSITY=$(jq -r '.parameters.verbosity' "$JSON_FILE")
if [[ "$VERBOSITY" == "low" ]]; then
    echo "✅ Low verbosity specified: $VERBOSITY"
else
    echo "⚠️  Verbosity not set to low: $VERBOSITY"
fi

echo ""
echo "✅ Cajun authentic researcher prompt validation complete!"
echo "📊 Validated: JSON schema, parish authenticity, canonical sources, celery-free trinity,"
echo "   anti-inflammatory approach, smoke craft, flavor architecture, output contract,"
echo "   minceur rails, and prompt parameters"

exit 0
