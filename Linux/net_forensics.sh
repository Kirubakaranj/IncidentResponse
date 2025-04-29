#!/bin/bash
# Linux Network Forensics Tool v1.0.0
# Correlates ss/netstat with process IDs and container IDs

# Configuration
OUTPUT_FORMAT="json"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Verify root privileges
if [ "$EUID" -ne 0 ]; then
  echo "{\"error\": \"This script must be run as root\"}" >&2
  exit 1
fi

# Get network connections
get_connections() {
  # Prefer ss if available, fallback to netstat
  if command -v ss &> /dev/null; then
    ss -tunap
  else
    netstat -tunap
  fi
}

# Get process and container info
get_process_info() {
  local pid=$1
  local info=()
  
  # Get process name
  info+=("$(ps -p $pid -o comm=)")
  
  # Get container ID if exists
  if [ -f /proc/$pid/cgroup ]; then
    container_id=$(grep -oP 'docker/\K[0-9a-f]{64}' /proc/$pid/cgroup | head -n1)
    info+=("${container_id:-none}")
  else
    info+=("none")
  fi
  
  echo "${info[@]}"
}

# Parse connections
parse_connections() {
  local connections=()
  
  while read -r line; do
    # Skip header lines
    [[ $line =~ ^(Active|State)|Recv-Q ]] && continue
    
    # Parse connection details
    if [[ $line =~ ([0-9]+)\/([^ ]+)$ ]]; then
      pid=${BASH_REMATCH[1]}
      process_name=${BASH_REMATCH[2]}
      read -r process_name container_id <<< "$(get_process_info $pid)"
      
      connections+=("$(printf '{"pid":%d,"process":"%s","container_id":"%s","connection":"%s"}' \
        "$pid" "$process_name" "$container_id" "${line%% *}")")
    fi
  done < <(get_connections)
  
  echo "${connections[@]}"
}

# Main execution
output=$(parse_connections)
if [ -z "$output" ]; then
  echo "{\"error\": \"No network connections found\"}" >&2
  exit 1
fi

# Output results
echo "{\"status\": \"success\", \"timestamp\": \"$TIMESTAMP\", \"connections\": [$(IFS=,; echo "${output[*]}")]}"
