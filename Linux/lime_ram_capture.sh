#!/bin/bash
# Linux Memory Capture Tool v1.0.0
# Uses LiME module for volatile memory acquisition

# Configuration
OUTPUT_DIR="/var/forensics/memory"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="${OUTPUT_DIR}/memory_${TIMESTAMP}.lime"

# Verify root privileges
if [ "$EUID" -ne 0 ]; then
  echo "{\"error\": \"This script must be run as root\"}" >&2
  exit 1
fi

# Create output directory
mkdir -p "${OUTPUT_DIR}" || {
  echo "{\"error\": \"Failed to create output directory ${OUTPUT_DIR}\"}" >&2
  exit 1
}

# Load LiME module
MODULE_PATH="/lib/modules/$(uname -r)/kernel/drivers/lime.ko"
if ! insmod "${MODULE_PATH}" "path=${OUTPUT_FILE} format=lime"; then
  echo "{\"error\": \"Failed to load LiME module\"}" >&2
  exit 1
fi

# Verify memory capture
if [ ! -f "${OUTPUT_FILE}" ]; then
  echo "{\"error\": \"Memory capture failed, no output file created\"}" >&2
  exit 1
fi

# Output success
echo "{\"status\": \"success\", \"output_file\": \"${OUTPUT_FILE}\", \"size\": \"$(du -h ${OUTPUT_FILE} | cut -f1)\"}"
