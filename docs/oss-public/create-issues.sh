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
  if ! gh milestone list -R "$REPO_SLUG" --state open | awk -F'\t' '{print $1}' | grep -qx "$title"; then
    gh milestone create "$title" -R "$REPO_SLUG" >/dev/null
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
# Map title->number to support dependency comments
declare -A TITLE_TO_NUM
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
  TITLE_TO_NUM["$title"]="$num"
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
  num="${TITLE_TO_NUM[$title]}"
  for dep_title in $(jq -r '.[]' <<<"$depends"); do
    dep_num="${TITLE_TO_NUM[$dep_title]:-}"
    [[ -z "$dep_num" ]] && continue
    gh issue comment -R "$REPO_SLUG" "$num" --body "Depends on #$dep_num — $dep_title"
  done
done < "$here/issues.jsonl"

if [[ -n "$PROJECT_BOARD" ]]; then
  echo "== Project board integration (manual example) =="
  echo "Example: gh project item-add \"$PROJECT_BOARD\" --owner \"$ORG_OR_USER\" --url https://github.com/$REPO_SLUG/issues/NUMBER"
fi

echo "Done. Created $i issues."
