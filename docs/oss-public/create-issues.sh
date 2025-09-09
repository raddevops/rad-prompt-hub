#!/usr/bin/env bash
# Idempotently create labels, milestones, and issues from issues.jsonl
# Requires: gh, jq
set -euo pipefail

: "${ORG_OR_USER:?ORG_OR_USER required}"
: "${REPO:?REPO required}"

REPO_SLUG="${ORG_OR_USER}/${REPO}"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
PROJECT_BOARD="${PROJECT_BOARD:-}"

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ensure_label() {
  local name="$1" color="$2" desc="$3"
  if ! gh label list -R "$REPO_SLUG" --limit 200 | awk -F'\t' '{print $1}' | grep -qx "$name"; then
    gh label create "$name" -R "$REPO_SLUG" --color "$color" --description "$desc" >/dev/null
  fi
}

ensure_milestone() {
  local title="$1"
  # Query all milestones (open+closed) and check if title exists
  local ms_json
  ms_json=$(gh api \
    -H "Accept: application/vnd.github+json" \
    "/repos/${ORG_OR_USER}/${REPO}/milestones?state=all&per_page=100")
  local existing
  existing=$(jq -r --arg t "$title" 'first(.[] | select(.title == $t)) | @base64' <<<"$ms_json" || true)
  if [[ -n "$existing" ]]; then
    local obj state number
    obj=$(echo "$existing" | base64 --decode)
    state=$(jq -r '.state' <<<"$obj")
    number=$(jq -r '.number' <<<"$obj")
    if [[ "$state" != "open" ]]; then
      # Reopen closed milestone
      gh api -X PATCH \
        -H "Accept: application/vnd.github+json" \
        "/repos/${ORG_OR_USER}/${REPO}/milestones/${number}" \
        -f state=open >/dev/null
    fi
  else
    # Create new milestone
    gh api -X POST \
      -H "Accept: application/vnd.github+json" \
      "/repos/${ORG_OR_USER}/${REPO}/milestones" \
      -f title="$title" >/dev/null
  fi
}

echo "== Ensuring labels =="
jq -c '.[]' "$here/labels.json" | while read -r lbl; do
  name=$(jq -r '.name' <<<"$lbl")
  color=$(jq -r '.color' <<<"$lbl")
  desc=$(jq -r '.description' <<<"$lbl")
  ensure_label "$name" "$color" "$desc"
done

echo "== Ensuring milestones =="
while IFS= read -r ms || [[ -n "$ms" ]]; do
  [[ -z "$ms" ]] && continue
  ensure_milestone "$ms"
done < "$here/milestones.txt"

echo "== Creating issues =="
# Portable title->number map via JSONL temp file
MAP_FILE="$(mktemp)"
i=0
while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" ]] && continue
  title=$(jq -r '.title' <<<"$line")
  body=$(jq -r '.body' <<<"$line")
  milestone=$(jq -r '.milestone' <<<"$line")
  labels=$(jq -r '.labels | join(",")' <<<"$line")
  assignees=$(jq -r '.assignees | join(",")' <<<"$line")

  tmpbody="$(mktemp)"; printf "%s\n" "$body" > "$tmpbody"
  args=(issue create -R "$REPO_SLUG" --title "$title" --body-file "$tmpbody" --label "$labels" --milestone "$milestone")
  [[ -n "$assignees" ]] && args+=("--assignee" "$assignees")
  issue_url=$(gh "${args[@]}")
  rm -f "$tmpbody"
  num=$(sed -E 's#.*/issues/([0-9]+).*#\1#' <<<"$issue_url")
  printf '{"title":%s,"number":%s}\n' "$(jq -Rs . <<<"$title")" "$(jq -n --arg n "$num" '$n|tonumber')" >> "$MAP_FILE"
  echo "Created #$num: $title"
  ((i++))
done < "$here/issues.jsonl"

echo "== Linking dependencies via comments =="
# second pass to add dependency comments
while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" ]] && continue
  title=$(jq -r '.title' <<<"$line")
  depends=$(jq -c '.depends_on_titles' <<<"$line")
  [[ "$depends" == "[]" ]] && continue
  num=$(jq -r --arg t "$title" 'select(.title==$t) | .number' "$MAP_FILE" | head -n1)
  [[ -z "$num" ]] && continue
  while IFS= read -r dep_title; do
    dep_num=$(jq -r --arg t "$dep_title" 'select(.title==$t) | .number' "$MAP_FILE" | head -n1)
    [[ -z "$dep_num" ]] && continue
    gh issue comment -R "$REPO_SLUG" "$num" --body "Depends on #$dep_num — $dep_title"
  done < <(jq -r '.[]' <<<"$depends")
done < "$here/issues.jsonl"

rm -f "$MAP_FILE"

if [[ -n "$PROJECT_BOARD" ]]; then
  echo "== Project board integration (manual example) =="
  echo "Example: gh project item-add \"$PROJECT_BOARD\" --owner \"$ORG_OR_USER\" --url https://github.com/$REPO_SLUG/issues/NUMBER"
fi

echo "Done. Created $i issues."
