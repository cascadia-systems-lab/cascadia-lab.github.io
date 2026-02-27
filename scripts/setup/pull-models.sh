#!/usr/bin/env bash
#
# pull-models.sh - Download Ollama models for the specified node tier
#
# Usage: ./pull-models.sh <tier> [--ollama-host <host>]
#        tier: micro | small | medium | large
#
# Description:
#   Downloads and registers the appropriate LLM models for this node's
#   hardware tier. Must be run during node provisioning — NOT during task
#   execution (to avoid timing variability in research runs).
#
#   Model weights are stored in Ollama's local model directory.
#   After running this script, update downloaded_models in node_profile.yaml.
#
# Prerequisites:
#   - Ollama installed and running (ollama serve)
#   - Internet access for model downloads
#   - Sufficient disk space for the tier's models
#
# Disk space requirements (approximate):
#   micro:  ~4 GB  (1B-3B models)
#   small:  ~12 GB (3B-7B models)
#   medium: ~25 GB (7B-13B models)
#   large:  ~45 GB (13B-70B models)
#

set -euo pipefail

# -----------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------

OLLAMA_HOST="${OLLAMA_HOST:-localhost:11434}"
TIER="${1:-}"
DRY_RUN=false

# Model definitions by tier
declare -A MODELS_MICRO=(
  ["phi3.5:3.8b-mini-instruct-q4_K_M"]="Small, fast model for micro-tier nodes"
  ["llama3.2:1b-instruct-q8_0"]="Ultra-small model for very memory-constrained nodes"
)

declare -A MODELS_SMALL=(
  ["phi3.5:3.8b-mini-instruct-q4_K_M"]="Small, fast model (shared with micro)"
  ["mistral:7b-instruct-q4_K_M"]="Primary 7B research model — Q4 quantization"
  ["llama3.1:8b-instruct-q4_K_M"]="Alternative 7B model — Llama family"
)

declare -A MODELS_MEDIUM=(
  ["mistral:7b-instruct-q8_0"]="Primary 7B model — Q8 for higher quality"
  ["llama3.1:8b-instruct-q8_0"]="Alternative 7B Q8"
  ["mistral-nemo:12b-instruct-2407-q4_K_M"]="12B model for medium-tier nodes"
)

declare -A MODELS_LARGE=(
  ["mistral-nemo:12b-instruct-2407-q8_0"]="12B model — Q8 quality"
  ["llama3.1:70b-instruct-q4_K_M"]="70B model for high-RAM nodes (requires 40+ GB)"
)

# -----------------------------------------------------------------------
# Utility functions
# -----------------------------------------------------------------------

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

info()  { log "INFO:  $*"; }
warn()  { log "WARN:  $*"; }
error() { log "ERROR: $*"; }

die() {
    error "$@"
    exit 1
}

usage() {
    sed -n '/^#/p' "$0" | head -25 | cut -c3-
    echo ""
    echo "Usage: $0 <tier> [--ollama-host <host>] [--dry-run]"
    echo ""
    echo "Tiers: micro | small | medium | large"
    exit 0
}

check_ollama() {
    info "Checking Ollama availability at ${OLLAMA_HOST}..."
    if ! curl -sf "http://${OLLAMA_HOST}/api/tags" > /dev/null 2>&1; then
        die "Ollama not reachable at http://${OLLAMA_HOST}/api/tags. Is 'ollama serve' running?"
    fi
    info "Ollama is reachable."
}

pull_model() {
    local model="$1"
    local description="$2"

    info "Pulling: ${model} (${description})"

    if [[ "$DRY_RUN" == true ]]; then
        info "[DRY RUN] Would pull: ${model}"
        return 0
    fi

    if ollama pull "${model}"; then
        info "Successfully pulled: ${model}"
    else
        warn "Failed to pull: ${model} — skipping"
    fi
}

print_downloaded_yaml() {
    echo ""
    echo "--- Update your node_profile.yaml with these downloaded_models: ---"
    echo ""
    echo "downloaded_models:"
    for model in "${!MODELS_TO_PULL[@]}"; do
        echo "  - \"${model}\""
    done
    echo ""
}

# -----------------------------------------------------------------------
# Argument parsing
# -----------------------------------------------------------------------

while [[ $# -gt 0 ]]; do
    case "$1" in
        micro|small|medium|large)
            TIER="$1"
            shift
            ;;
        --ollama-host)
            OLLAMA_HOST="$2"
            shift 2
            ;;
        --dry-run|-d)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            die "Unknown argument: $1. Use --help for usage."
            ;;
    esac
done

[[ -z "$TIER" ]] && die "Tier is required. Usage: $0 <tier>. Tiers: micro | small | medium | large"

# -----------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------

info "Starting model pull for tier: ${TIER}"
[[ "$DRY_RUN" == true ]] && info "DRY RUN mode — no models will be downloaded"

check_ollama

declare -A MODELS_TO_PULL

case "$TIER" in
    micro)
        for k in "${!MODELS_MICRO[@]}"; do MODELS_TO_PULL["$k"]="${MODELS_MICRO[$k]}"; done
        ;;
    small)
        for k in "${!MODELS_MICRO[@]}"; do MODELS_TO_PULL["$k"]="${MODELS_MICRO[$k]}"; done
        for k in "${!MODELS_SMALL[@]}"; do MODELS_TO_PULL["$k"]="${MODELS_SMALL[$k]}"; done
        ;;
    medium)
        for k in "${!MODELS_SMALL[@]}"; do MODELS_TO_PULL["$k"]="${MODELS_SMALL[$k]}"; done
        for k in "${!MODELS_MEDIUM[@]}"; do MODELS_TO_PULL["$k"]="${MODELS_MEDIUM[$k]}"; done
        ;;
    large)
        for k in "${!MODELS_MEDIUM[@]}"; do MODELS_TO_PULL["$k"]="${MODELS_MEDIUM[$k]}"; done
        for k in "${!MODELS_LARGE[@]}"; do MODELS_TO_PULL["$k"]="${MODELS_LARGE[$k]}"; done
        ;;
    *)
        die "Unknown tier: ${TIER}. Valid tiers: micro | small | medium | large"
        ;;
esac

info "Models to pull: ${#MODELS_TO_PULL[@]}"
echo ""

for model in "${!MODELS_TO_PULL[@]}"; do
    pull_model "$model" "${MODELS_TO_PULL[$model]}"
done

info "Model pull complete for tier: ${TIER}"

print_downloaded_yaml

info "Next step: Update downloaded_models in config/node_profile.yaml"
