#!/bin/bash
# Generate file system timeline sorted by modification time
echo "Generating file system timeline..."
find / -type f -printf '%T+ %p\n' 2>/dev/null | sort > system_timeline_$(date +%Y%m%d_%H%M%S).txt
