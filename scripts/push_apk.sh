#!/usr/bin/env bash
# Загрузка APK в https://github.com/Duck001-lab/COMPILED
# GITHUB_TOKEN=ghp_xxx bash scripts/push_apk.sh
set -euo pipefail

REPO_URL="https://github.com/Duck001-lab/COMPILED.git"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APK_SRC="${APK_SRC:-$ROOT/../app/build/outputs/apk/debug/CloudFireVPN.apk}"

if [[ ! -f "$APK_SRC" ]]; then
  echo "APK not found: $APK_SRC" >&2
  exit 1
fi

cp "$APK_SRC" "$ROOT/CloudFireVPN.apk"
cd "$ROOT"

if [[ ! -d .git ]]; then
  git init -b main
fi

if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  printf '%s\n' "$GITHUB_TOKEN" | gh auth login --hostname github.com --git-protocol https --with-token
  git remote remove origin 2>/dev/null || true
  git remote add origin "$REPO_URL"
fi

git add CloudFireVPN.apk
git -c user.email="${GIT_AUTHOR_EMAIL:-duck001@tatanota.de}" \
    -c user.name="${GIT_AUTHOR_NAME:-Duck001-lab}" \
    commit -m "Update CloudFireVPN APK" || true

git push -u origin main
echo "Public URL:"
echo "https://github.com/Duck001-lab/COMPILED/raw/main/CloudFireVPN.apk"
