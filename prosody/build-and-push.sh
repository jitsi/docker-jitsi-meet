#!/usr/bin/env bash
set -euo pipefail

# ── Config (override via env) ────────────────────────────────────────────────
AWS_REGION="${AWS_REGION:-us-east-1}"
ACCOUNT_ID="${ACCOUNT_ID:-233718569638}"
REPO="${REPO:-portal-dev-jitsi}"

# Upstream base args (used only if your Dockerfile consumes them)
BASE_TAG="${BASE_TAG:-stable}"      # e.g. stable, stable-10314
JITSI_REPO="${JITSI_REPO:-jitsi}"

# Build behavior
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"   # multi-arch so it runs on both x86_64 & Graviton
NO_CACHE="${NO_CACHE:-true}"                        # set to false to allow caching

DATE_TAG="$(date +%Y%m%d-%H%M%S)"
GIT_TAG="$(git rev-parse --short HEAD 2>/dev/null || echo nogit)"
TAG="prod-${DATE_TAG}-${GIT_TAG}"

ECR="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
IMAGE="${ECR}/${REPO}:${TAG}"

log()  { printf "\033[1;32m➤ %s\033[0m\n" "$*"; }
err()  { printf "\033[1;31m✖ %s\033[0m\n" "$*" >&2; }

command -v aws >/dev/null    || { err "aws CLI not found"; exit 1; }
command -v docker >/dev/null || { err "docker not found"; exit 1; }

# ── Buildx setup ─────────────────────────────────────────────────────────────
if ! docker buildx ls | grep -q 'jitsi-builder'; then
  log "Creating docker buildx builder 'jitsi-builder'…"
  docker buildx create --name jitsi-builder --use >/dev/null
else
  docker buildx use jitsi-builder >/dev/null
fi

# ── ECR login ────────────────────────────────────────────────────────────────
log "Logging into ECR ${ECR}…"
aws ecr get-login-password --region "$AWS_REGION" \
  | docker login --username AWS --password-stdin "$ECR" >/dev/null

# ── Build & push (multi-arch) ───────────────────────────────────────────────
log "Building and pushing ${IMAGE} for platforms: ${PLATFORMS}"

build_args=(
  --platform "${PLATFORMS}"
  --pull
  -t "${IMAGE}"
  --push
  --provenance=false
  --build-arg "BASE_TAG=${BASE_TAG}"
  --build-arg "JITSI_REPO=${JITSI_REPO}"
)

if [ "${NO_CACHE}" = "true" ]; then
  build_args+=( --no-cache )
fi

docker buildx build "${build_args[@]}" .

# ── Print digest & next steps ────────────────────────────────────────────────
DIGEST="$(aws ecr describe-images \
  --region "$AWS_REGION" \
  --repository-name "$REPO" \
  --image-ids imageTag="$TAG" \
  --query 'imageDetails[0].imageDigest' --output text)"

log "Pushed image:"
echo "  Tag:    ${IMAGE}"
echo "  Digest: ${ECR}/${REPO}@${DIGEST}"

cat <<EOF

Update your ECS task definition (web container) to use either:

  "image": "${IMAGE}"

or pin immutably:

  "image": "${ECR}/${REPO}@${DIGEST}"

Tips:
- Override platforms:   PLATFORMS=linux/amd64 ./build-and-push.sh
- Allow cache:          NO_CACHE=false ./build-and-push.sh
- Change repo/region:   REPO=portal-prod-jitsi AWS_REGION=us-east-1 ./build-and-push.sh
EOF
