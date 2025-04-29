#!/bin/bash
# Collect browser histories from Safari
echo "Collecting Safari history artifacts..."
mkdir -p browser_artifacts
sqlite3 ~/Library/Safari/History.db "SELECT * FROM history_items" > browser_artifacts/safari_history.txt
