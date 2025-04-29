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

### timeline_generator.sh
Generates system file timeline sorted by modification time
```bash
./timeline_generator.sh  # Outputs system_timeline_[DATE].txt
```

### rootkit_check.sh 
Detects rootkits and suspicious kernel modules
```bash
sudo ./rootkit_check.sh
```

### triage_collector.sh
Comprehensive evidence collection script
```bash
sudo ./triage_collector.sh  # Collects:
                            # - Memory dump
                            # - Process listings
                            # - Network capture
                            # - System logs
```

## macOS Tools

### browser_artifact_collector.sh
Collects Safari browsing history
```bash
./browser_artifact_collector.sh  # Outputs to browser_artifacts/
```

### spotlight_search.swift
Searches file metadata for IOCs
```bash
swift spotlight_search.swift  # Looks for 'malicious'/'suspicious' patterns
```

## Windows Tools

### wmi_persistence_check.ps1
Detects WMI-based persistence mechanisms
```powershell
.\wmi_persistence_check.ps1
```

### prefetch_analyzer.ps1
Analyzes Prefetch execution history
```powershell
.\prefetch_analyzer.ps1
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
git clone https://github.com/yourorg/IncidentResponse
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
