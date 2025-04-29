#!/bin/bash
# Unified evidence collection script
echo "Starting system triage..."
mkdir -p evidence/{memory,process,network,logs}

# Memory capture
echo "Capturing memory..."
sudo insmod LiME/lime.ko "path=evidence/memory/memdump_$(date +%s).lime"

# Process analysis
echo "Collecting process info..."
ps aux > evidence/process/pslist.txt
lsof -n > evidence/process/open_handles.txt

# Network capture 
echo "Capturing network traffic (500 packets)..."
tcpdump -c 500 -w evidence/network/capture_$(date +%s).pcap

# Log collection
echo "Gathering system logs..."
cp /var/log/{auth.log,syslog,kern.log} evidence/logs/
