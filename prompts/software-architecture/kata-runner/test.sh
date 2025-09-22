#!/bin/bash

# Test script for kata-runner prompt
# Validates JSON structure, required fields, and functionality

set -e

echo "🔍 Testing Kata Runner Prompt..."
echo "======================================================"

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

echo ""
echo "📋 Schema validation..."

# Run repository schema validation
python3 "$(git rev-parse --show-toplevel)/scripts/schema_validate_prompts.py" "$PROMPT_FILE"
echo "✅ Schema validation passed"

# Extract content for validation
SYSTEM_CONTENT=$(jq -r '.messages[] | select(.role == "system") | .content' "$PROMPT_FILE")
USER_CONTENT=$(jq -r '.messages[] | select(.role == "user") | .content' "$PROMPT_FILE")

echo ""
echo "🎯 Content validation..."

# Validate target model
TARGET_MODEL=$(jq -r '.target_model // "not_specified"' "$PROMPT_FILE")
if [[ "$TARGET_MODEL" == "gpt-5-thinking" ]]; then
    echo "✅ Appropriate target model: $TARGET_MODEL"
else
    echo "❌ Inappropriate target model: $TARGET_MODEL"
    exit 1
fi

# Validate parameters
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
VERBOSITY=$(jq -r '.parameters.verbosity // "not_specified"' "$PROMPT_FILE")
TEMPERATURE=$(jq -r '.parameters.temperature // "not_specified"' "$PROMPT_FILE")

if [[ "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for architectural design: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort: $REASONING_EFFORT"
    exit 1
fi

if [[ "$VERBOSITY" == "low" ]]; then
    echo "✅ Appropriate verbosity for artifact generation: $VERBOSITY"
else
    echo "❌ Inappropriate verbosity: $VERBOSITY"
    exit 1
fi

if [[ "$TEMPERATURE" == "0.2" ]]; then
    echo "✅ Appropriate temperature for deterministic output: $TEMPERATURE"
else
    echo "❌ Inappropriate temperature: $TEMPERATURE"
    exit 1
fi

echo ""
echo "🏗️ Architectural functionality validation..."

# Validate Kata Runner role
if echo "$SYSTEM_CONTENT" | grep -q -i "kata runner\|architectural-kata orchestrator"; then
    echo "✅ Kata Runner role defined"
else
    echo "❌ Missing Kata Runner role definition"
    exit 1
fi

# Validate ATAM methodology
if echo "$SYSTEM_CONTENT" | grep -q -i "ATAM"; then
    echo "✅ ATAM methodology referenced"
else
    echo "❌ Missing ATAM methodology reference"
    exit 1
fi

# Validate quality attribute scenarios
if echo "$SYSTEM_CONTENT" | grep -q -i "QAS\|quality.*attribute.*scenario"; then
    echo "✅ Quality attribute scenarios (QAS) capability"
else
    echo "❌ Missing QAS capability"
    exit 1
fi

# Validate candidate generation requirement
if echo "$SYSTEM_CONTENT" | grep -q "≥2.*candidate\|2–3.*candidate"; then
    echo "✅ Multiple candidate generation specified"
else
    echo "❌ Missing multiple candidate requirement"
    exit 1
fi

echo ""
echo "📁 Output artifact validation..."

# Validate required output files
REQUIRED_FILES=("index.md" "c4-context.md" "c4-container.md" "tradeoffs.md" "qa-scenarios.json" "fitness" "risks.md" "backlog.md" "dossier.json" "adr")
for file in "${REQUIRED_FILES[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q "$file"; then
        echo "✅ Required file specified: $file"
    else
        echo "❌ Missing required file: $file"
        exit 1
    fi
done

# Validate ADR (Architecture Decision Records) 
if echo "$SYSTEM_CONTENT" | grep -q -i "ADR\|architecture.*decision.*record"; then
    echo "✅ ADR capability specified"
else
    echo "❌ Missing ADR specification"
    exit 1
fi

# Validate fitness functions
if echo "$SYSTEM_CONTENT" | grep -q -i "fitness.*function"; then
    echo "✅ Fitness functions capability"
else
    echo "❌ Missing fitness functions capability"
    exit 1
fi

echo ""
echo "🔄 Process validation..."

# Validate 9-phase process components
PROCESS_PHASES=("Validate.*brief" "QAS.*Builder" "Candidate.*Generator" "Trade-off.*Analyst" "Decision.*ADR" "C4.*Communicator" "Fitness.*Function" "Backlog.*Risk" "Dossier")
for phase in "${PROCESS_PHASES[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$phase"; then
        echo "✅ Process phase present: $(echo "$phase" | cut -d'.' -f1)"
    else
        echo "❌ Missing process phase: $(echo "$phase" | cut -d'.' -f1)"
        exit 1
    fi
done

echo ""
echo "🎯 Quality gates validation..."

# Validate quality gates
QUALITY_GATES=("5.*QAS" "2.*candidate" "ADR.?0001" "walking.*skeleton" "3.*must.*have.*capabilities")
for gate in "${QUALITY_GATES[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q -i "$gate"; then
        echo "✅ Quality gate specified: $(echo "$gate" | cut -d'\\' -f1)"
    else
        echo "❌ Missing quality gate: $(echo "$gate" | cut -d'\\' -f1)"
        exit 1
    fi
done

echo ""
echo "📝 Input validation..."

# Validate required inputs
REQUIRED_INPUTS=("KATA_BRIEF_JSON" "REPO_ROOT" "MODE")
for input in "${REQUIRED_INPUTS[@]}"; do
    if echo "$USER_CONTENT" | grep -q "$input"; then
        echo "✅ Required input parameter: $input"
    else
        echo "❌ Missing input parameter: $input"
        exit 1
    fi
done

# Validate mode options
if echo "$USER_CONTENT" | grep -q "MODE=.*silent\|MODE=.*interview"; then
    echo "✅ Mode options specified"
else
    echo "❌ Missing mode options"
    exit 1
fi

echo ""
echo "📊 Output format validation..."

# Validate JSON output contract
if echo "$SYSTEM_CONTENT" | grep -q "Output Contract.*JSON\|exactly one.*JSON"; then
    echo "✅ JSON output contract specified"
else
    echo "❌ Missing JSON output contract"
    exit 1
fi

# Validate quality report structure
if echo "$SYSTEM_CONTENT" | grep -q "quality_report.*passed.*issues"; then
    echo "✅ Quality report structure defined"
else
    echo "❌ Missing quality report structure"
    exit 1
fi

echo ""
echo "⚡ Performance validation..."

# Check JSON optimization (large architectural prompts need careful structure)
FILE_SIZE=$(wc -c < "$PROMPT_FILE" | tr -d ' ')
if [[ "$FILE_SIZE" -lt 50000 ]]; then
    echo "✅ Well-optimized file size (${FILE_SIZE} bytes)"
else
    echo "⚠️  Large file size, consider optimization (${FILE_SIZE} bytes)"
fi

echo ""
echo "🎉 All tests passed! Kata Runner prompt is valid and functional."
echo ""