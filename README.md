# Incident Response Toolkit

Cross-platform forensic tools for incident response investigations.

## Directory Structure
```
.
├── Linux/              # Linux-specific forensic tools
├── MacOS/              # macOS investigation scripts  
├── Windows/            # Windows forensic utilities
├── CrossPlatform/      # Tools working across OSes
└── README.md           # This documentation
```

## Linux Tools

### lime_ram_capture.sh
Capture physical memory using LiME kernel module
```bash
sudo ./lime_ram_capture.sh -o memdump.lime -f raw
```

### timeline_generator.sh
Generate filesystem timeline sorted by modification time
```bash
sudo ./timeline_generator.sh -d /var/log -o var_log_timeline.csv
```

### process_analyzer.py
Advanced process inspection and analysis
```bash
python3 process_analyzer.py --pid 1234  # Analyze specific process
python3 process_analyzer.py --all --csv processes.csv  # System-wide audit
```

### net_forensics.sh
Network connection forensic analysis
```bash
sudo ./net_forensics.sh -p tcp -o network_report.txt
```

### rootkit_check.sh 
Rootkit detection and kernel module verification
```bash
sudo ./rootkit_check.sh --full-scan --report rootkit_scan.log
```

### triage_collector.sh
Comprehensive evidence collection
```bash
sudo ./triage_collector.sh --memory --network --output /mnt/evidence
```

### investigation.sh
Main Linux triage workflow controller
```bash
sudo ./investigation.sh --case CASE123 --preserve-memory --log-level debug
```

## macOS Tools

### browser_artifact_collector.sh
Collects Safari browsing history and downloads
```bash
./browser_artifact_collector.sh --output-dir /evidence  # Custom output directory
```

### spotlight_search.swift
Search file metadata for IOCs using Spotlight
```bash
swift spotlight_search.swift -i ioc_list.txt  # Search using predefined IOC list
```

### startup_check.swift
Analyze launch agents/daemons and login items
```bash
swift startup_check.swift --json  # Output in JSON format
swift startup_check.swift --compare-snapshot baseline.json  # Compare to known good state
```

### log_collector.sh
Collect unified logging system data
```bash
sudo ./log_collector.sh --timeframe "last 24h"  # Collect logs from specific period
```

### mtree_checker.sh
File integrity checker using mtree format
```bash
./mtree_checker.sh create  # Create baseline
./mtree_checker.sh verify  # Check against baseline
```

### investigation.sh
Main macOS triage workflow controller
```bash
sudo ./investigation.sh --case CASE456 --collect-memory
```

## Windows Tools

### eventlog_analyzer.ps1
Analyze and correlate Windows Event Logs
```powershell
.\eventlog_analyzer.ps1 -Channel Security -EventID 4624,4625 -Output report.csv
```

### autorun_audit.ps1
Audit auto-start locations and scheduled tasks
```powershell
.\autorun_audit.ps1 -VerifyCertificates -HashAlgorithm SHA256
```

### wmi_persistence_check.ps1
Detect WMI-based persistence mechanisms
```powershell
.\wmi_persistence_check.ps1 -DeepScan -OutputJSON persistence_objects.json
```

### prefetch_analyzer.ps1
Analyze Prefetch file execution history
```powershell
.\prefetch_analyzer.ps1 -Timeline -LastAccessTime "2025-04-28"
```

### hunter.ps1
Advanced threat hunting module
```powershell
.\hunter.ps1 -Indicator Process -Name "malware.exe" -KillProcess
```

### investigation.ps1
Windows triage workflow controller
```powershell
.\investigation.ps1 -FullSystemScan -OutputDirectory .\evidence
```

### filetimeconverter.py
Convert Windows FILETIME timestamps
```bash
python filetimeconverter.py 133490699610000000
# Output: 2025-04-29 16:46:01 UTC
```

## Cross-Platform Tools

### yara_scanner.py
Malware detection using YARA rules
```bash
python yara_scanner.py suspicious_file.exe
```

### aws_incident_response.py
EC2 forensic snapshot tool
```bash
python aws_incident_response.py i-1234567890abcdef0 us-west-2
```

## Dependencies

```bash
# Install required packages
pip install yara-python boto3
brew install yara         # macOS
sudo apt install yara     # Linux
```

## Getting Started

1. Clone repository
```bash
git clone https://github.com/Kirubakaranj/IncidentResponse
cd IncidentResponse
```

2. Install dependencies
```bash
pip install -r requirements.txt  # Python tools
```

3. Update YARA rules
```bash
# Add custom rules to CrossPlatform/yara_rules/
```

## Contribution
Add new tools to appropriate platform directory and update this README.
