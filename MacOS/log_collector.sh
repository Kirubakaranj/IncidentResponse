#!/bin/bash
# macOS Unified Logging Collector v1.0.0
# Queries macOS's logging system for security events

# Configuration
LOG_LEVELS=("default" "info" "debug" "error" "fault")
SECURITY_PREDICATES=(
  "process == \"loginwindow\""
  "subsystem == \"com.apple.security\""
  "eventMessage CONTAINS[c] \"auth\""
  "eventMessage CONTAINS[c] \"security\""
  "eventMessage CONTAINS[c] \"password\""
)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Verify macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "{\"error\": \"This script must be run on macOS\"}" >&2
  exit 1
fi

# Build log query
build_query() {
  local predicates=()
  for pred in "${SECURITY_PREDICATES[@]}"; do
    predicates+=("--predicate \"$pred\"")
  done
  echo "${predicates[@]}"
}

# Collect logs
collect_logs() {
  local query=$(build_query)
  local logs=()
  
  for level in "${LOG_LEVELS[@]}"; do
    while read -r line; do
      timestamp=$(echo "$line" | awk '{print $1, $2}')
      process=$(echo "$line" | awk -F']' '{print $2}' | awk '{print $1}')
      message=$(echo "$line" | awk -F']' '{print $3}' | sed 's/^ *//')
      
      logs+=("$(printf '{"timestamp":"%s","process":"%s","message":"%s"}' \
        "$timestamp" "$process" "$message")")
    done < <(eval log show --style syslog --level $level $query --info --debug --last 1h)
  done
  
  echo "${logs[@]}"
}

# Main execution
output=$(collect_logs)
if [ -z "$output" ]; then
  echo "{\"error\": \"No security logs found\"}" >&2
  exit 1
fi

# Output results
echo "{\"status\": \"success\", \"timestamp\": \"$TIMESTAMP\", \"logs\": [$(IFS=,; echo "${output[*]}")]}"
