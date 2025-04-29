#!/bin/bash
# macOS File Integrity Monitor v1.0.0
# Uses mtree to validate system directory structures

# Configuration
BASELINE_DIR="/var/db/mtree"
BASELINE_FILE="$BASELINE_DIR/system.mtree"
TARGET_DIRS=(
    "/bin"
    "/sbin"
    "/usr/bin"
    "/usr/sbin"
    "/usr/lib"
    "/usr/libexec"
    "/usr/local/bin"
)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Verify macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "{\"error\": \"This script must be run on macOS\"}" >&2
  exit 1
fi

# Verify root privileges
if [ "$EUID" -ne 0 ]; then
  echo "{\"error\": \"This script must be run as root\"}" >&2
  exit 1
fi

# Create baseline if it doesn't exist
create_baseline() {
  mkdir -p "$BASELINE_DIR"
  for dir in "${TARGET_DIRS[@]}"; do
    if [ -d "$dir" ]; then
      mtree -c -K cksum -p "$dir" >> "$BASELINE_FILE"
    fi
  done
}

# Verify integrity
verify_integrity() {
  local discrepancies=()
  
  while read -r line; do
    if [[ $line =~ ^(\./.*)\s+(.*)$ ]]; then
      path=${BASH_REMATCH[1]}
      details=${BASH_REMATCH[2]}
      
      discrepancies+=("$(printf '{"path":"%s","details":"%s"}' \
        "$path" "$details")")
    fi
  done < <(mtree -f "$BASELINE_FILE" -p / 2>&1 | grep -E '^(\./.*)\s+(.*)$')
  
  echo "${discrepancies[@]}"
}

# Main execution
if [ ! -f "$BASELINE_FILE" ]; then
  create_baseline
  echo "{\"status\": \"success\", \"message\": \"Created new baseline\"}"
  exit 0
fi

output=$(verify_integrity)
if [ -z "$output" ]; then
  echo "{\"status\": \"success\", \"message\": \"No discrepancies found\"}"
else
  echo "{\"status\": \"success\", \"timestamp\": \"$TIMESTAMP\", \"discrepancies\": [$(IFS=,; echo "${output[*]}")]}"
fi
