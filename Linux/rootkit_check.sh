#!/bin/bash
# Check for rootkit indicators
echo "Scanning for rootkits..."
rkhunter --checkall --sk --quiet
echo -e "\nChecking suspicious kernel modules:"
lsmod | grep -E 'hid|joydev'
