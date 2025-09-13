#!/bin/bash

set -e

echo "Testing add-copilot-instructions prompt..."

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
echo "🔍 Testing codebase auditor functionality..."

# Validate codebase auditor role
if echo "$SYSTEM_CONTENT" | grep -q -i "codebase.*auditor\|copilot.*best.*practices"; then
    echo "✅ Codebase auditor and Copilot integration role specified"
else
    echo "❌ Missing codebase auditor role specification"
    exit 1
fi

# Validate dual capability (audit + integration)
if echo "$SYSTEM_CONTENT" | grep -q -i "examine.*project.*read.*internalize.*apply"; then
    echo "✅ Dual capability (audit + integration) specified"
else
    echo "❌ Missing dual capability specification"
    exit 1
fi

# Validate minimal back-and-forth focus
if echo "$SYSTEM_CONTENT" | grep -q -i "minimal.*back.*forth\|implementation.*ready"; then
    echo "✅ Minimal back-and-forth efficiency focus specified"
else
    echo "❌ Missing efficiency focus"
    exit 1
fi

echo ""
echo "📋 Testing deliverable structure validation (JSON contract)..."

# Validate JSON output contract keys in user content
REQUIRED_KEYS=("repo_snapshot" "best_practices" "mapping" "prioritized_changes" "prompts_library" "verification_plan" "pr_plan" "open_questions")
MISSING_KEYS=()
for key in "${REQUIRED_KEYS[@]}"; do
    if echo "$USER_CONTENT" | grep -q "$key"; then
        echo "✅ Output key specified: $key"
    else
        MISSING_KEYS+=("$key")
    fi
done

if [ ${#MISSING_KEYS[@]} -gt 0 ]; then
    echo "❌ Missing required output keys in JSON contract: ${MISSING_KEYS[*]}"
    exit 1
fi

# Validate prioritization framework reference
if echo "$USER_CONTENT" | grep -q -i "P0\|P1\|P2\|prioritized_changes"; then
    echo "✅ Prioritization framework (P0/P1/P2) referenced"
else
    echo "❌ Missing prioritization framework reference"
    exit 1
fi

echo ""
echo "🎯 Testing methodology validation..."

# Validate explicit and deterministic approach
if echo "$SYSTEM_CONTENT" | grep -q -i "explicit.*deterministic\|checklist.*table.*file.*path"; then
    echo "✅ Explicit and deterministic methodology specified"
else
    echo "❌ Missing explicit methodology requirements"
    exit 1
fi

# Validate no chain-of-thought requirement
if echo "$SYSTEM_CONTENT" | grep -q -i "no chain.*thought\|conclusions.*steps.*artifacts"; then
    echo "✅ No chain-of-thought requirement specified"
else
    echo "❌ Missing no chain-of-thought requirement"
    exit 1
fi

# Validate scope discipline for large repos
if echo "$SYSTEM_CONTENT" | grep -q -i "scope discipline\|sample.*representative.*module"; then
    echo "✅ Scope discipline for large repositories specified"
else
    echo "❌ Missing scope discipline guidance"
    exit 1
fi

echo ""
echo "🔒 Security and safety validation..."

# Validate security guardrails
if echo "$SYSTEM_CONTENT" | grep -q -i "never invent.*secret\|don't.*suggest.*disabling.*security"; then
    echo "✅ Security guardrails specified"
else
    echo "❌ Missing security guardrails"
    exit 1
fi

# Validate unsafe pattern detection
if echo "$SYSTEM_CONTENT" | grep -q -i "flag unsafe pattern"; then
    echo "✅ Unsafe pattern detection specified"
else
    echo "❌ Missing unsafe pattern detection"
    exit 1
fi

echo ""
echo "📝 Template and input validation..."

# Validate comprehensive input template
INPUT_SECTIONS=("REPO_LOCATION" "PROJECT_SUMMARY" "LANGS_AND_FRAMEWORKS" "CONSTRAINTS" "PRIORITY_AREAS")
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

# Validate Copilot best practices URL handling
if echo "$USER_CONTENT" | grep -q -i "copilot.*best.*practices.*source\|docs\.github\.com.*copilot"; then
    echo "✅ Copilot best practices URL handling specified"
else
    echo "❌ Missing Copilot best practices URL handling"
    exit 1
fi

# Validate network access handling
if echo "$USER_CONTENT" | grep -q -i "network_access\|fetch.*read.*page"; then
    echo "✅ Network access and URL fetching handling specified"
else
    echo "❌ Missing network access handling"
    exit 1
fi

# Validate tool availability handling
if echo "$USER_CONTENT" | grep -q -i "tools_available\|max_scan_depth\|file_globs"; then
    echo "✅ Tool availability and scanning constraints specified"
else
    echo "❌ Missing tool availability handling"
    exit 1
fi

echo ""
echo "🔍 Quality assurance validation..."

# Validate reasoning effort appropriate for complex auditing
REASONING_EFFORT=$(jq -r '.parameters.reasoning_effort // "not_specified"' "$PROMPT_FILE")
if [[ "$REASONING_EFFORT" == "high" ]]; then
    echo "✅ Appropriate reasoning effort for codebase auditing: $REASONING_EFFORT"
else
    echo "❌ Inappropriate reasoning effort for complex auditing: $REASONING_EFFORT"
    exit 1
fi

# Validate assumption and risk documentation
ASSUMPTIONS=$(jq -r '.assumptions // [] | length' "$PROMPT_FILE")
RISKS=$(jq -r '.risks_or_notes // [] | length' "$PROMPT_FILE")
if [[ "$ASSUMPTIONS" -gt 0 && "$RISKS" -gt 0 ]]; then
    echo "✅ Assumptions and risks documented"
else
    echo "❌ Missing assumption or risk documentation"
    exit 1
fi

# Validate success criteria and verification
if echo "$USER_CONTENT" | grep -q -i "success criteria\|immediately usable\|minimal yet effective"; then
    echo "✅ Success criteria and verification standards specified"
else
    echo "❌ Missing success criteria"
    exit 1
fi

echo ""
echo "🧱 Output format guardrails (JSON-only/minified)..."

# Validate system enforces JSON-only, no markdown, no code fences, minified
if echo "$SYSTEM_CONTENT" | grep -qi "JSON only" && echo "$SYSTEM_CONTENT" | grep -qi "no markdown" && echo "$SYSTEM_CONTENT" | grep -qi "no code fences" && echo "$SYSTEM_CONTENT" | grep -qi "single minified line"; then
    echo "✅ System enforces JSON-only, no markdown/code fences, minified output"
else
    echo "❌ Missing JSON-only/minified guardrails in system message"
    exit 1
fi

# Validate user content mentions single minified JSON object
if echo "$USER_CONTENT" | grep -qi "single minified JSON object"; then
    echo "✅ User contract specifies single minified JSON object"
else
    echo "❌ User contract missing minified JSON object specification"
    exit 1
fi

# Validate prompt file is minified (1 physical line)
LINE_COUNT=$(wc -l < "$PROMPT_FILE" | tr -d ' ')
if [ "$LINE_COUNT" -le 2 ]; then
    echo "✅ Prompt JSON is minified (lines: $LINE_COUNT)"
else
    echo "❌ Prompt JSON not minified (lines: $LINE_COUNT)"
    exit 1
fi

echo ""
echo "✅ Add-copilot-instructions prompt validation complete!"
echo "📊 Validated: JSON schema, codebase audit methodology, security guardrails, JSON-only output contract, minification, quality assurance"

echo ""
echo "🆕 Fast & Safe Behaviors & Version checks..."

# Validate version bump
VERSION=$(jq -r '.version // "unknown"' "$PROMPT_FILE")
if [ "$VERSION" != "2.1.0" ]; then
    echo "❌ Version mismatch (expected 2.1.0, got $VERSION)"
    exit 1
fi
echo "✅ Version is 2.1.0"

# Validate presence of Fast & Safe Behaviors header
if echo "$SYSTEM_CONTENT" | grep -q -i "Fast & Safe Behaviors"; then
    echo "✅ Fast & Safe Behaviors header present"
else
    echo "❌ Missing Fast & Safe Behaviors header"
    exit 1
fi

# Validate presence of several representative behaviors
REP_BEHAVIORS=("Plan-Then-Act" "Deterministic Output Contract" "Output Self-Test")
for beh in "${REP_BEHAVIORS[@]}"; do
    if echo "$SYSTEM_CONTENT" | grep -q "$beh"; then
        echo "✅ Behavior present: $beh"
    else
        echo "❌ Missing behavior: $beh"
        exit 1
    fi
done

echo ""
echo "✅ Extended validation: version & Fast & Safe Behaviors confirmed"
