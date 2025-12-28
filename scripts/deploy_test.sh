#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="${ROOT_DIR}/app"
TARGET_DIR="${ROOT_DIR}/deploy/test"

mkdir -p "${TARGET_DIR}"

rsync -a --delete "${APP_DIR}/src/" "${TARGET_DIR}/src/"
rsync -a --delete "${APP_DIR}/test/" "${TARGET_DIR}/test/"
cp -f "${APP_DIR}/package.json" "${TARGET_DIR}/package.json"

COMMIT="${GIT_COMMIT:-${CI_COMMIT_SHA:-unknown}}"
PIPELINE="${BUILD_NUMBER:-${CI_PIPELINE_ID:-unknown}}"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

cat > "${TARGET_DIR}/DEPLOY_INFO.txt" <<EOF
deployed_at_utc=${DATE}
commit=${COMMIT}
pipeline=${PIPELINE}
EOF

echo "Deployed to ${TARGET_DIR}"
cat "${TARGET_DIR}/DEPLOY_INFO.txt"
