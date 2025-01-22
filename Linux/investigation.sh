#!/bin/bash

# filepath: /Users/kjayakumar/github/IncidentResponse/Linux/investigation.sh

# Set the output directory
outputDir="/home/username/LogExport"

# Create the output directory if it doesn't exist
if [ ! -d "$outputDir" ]; then
    mkdir -p "$outputDir"
fi

# Get current timestamp for file naming
timestamp=$(date +"%Y%m%d_%H%M%S")

# Copy system logs
logFiles=("/var/log/syslog" "/var/log/auth.log" "/var/log/kern.log")
for logFile in "${logFiles[@]}"; do
    if [ -f "$logFile" ]; then
        safeLogName=$(basename "$logFile" | sed 's/[\\/:*?"<>|]/_/g')
        outputFile="$outputDir/${safeLogName}_${timestamp}.log"
        
        echo "Copying $logFile to $outputFile"
        
        cp "$logFile" "$outputFile"
    else
        echo "Log file $logFile does not exist"
    fi
done

# Export system information
sysInfoFile="$outputDir/SystemInfo_${timestamp}.txt"
echo "Exporting system information to $sysInfoFile"
uname -a > "$sysInfoFile"
lshw >> "$sysInfoFile"

# Export list of running processes
processesFile="$outputDir/RunningProcesses_${timestamp}.csv"
echo "Exporting list of running processes to $processesFile"
ps aux --no-headers | awk '{print $1","$2","$3","$4","$11}' > "$processesFile"

# Export network connections
netConnectionsFile="$outputDir/NetworkConnections_${timestamp}.csv"
echo "Exporting network connections to $netConnectionsFile"
ss -tunapl | awk 'NR>1 {print $1","$2","$3","$4","$5","$6","$7}' > "$netConnectionsFile"

# Export installed software
installedSoftwareFile="$outputDir/InstalledSoftware_${timestamp}.txt"
echo "Exporting installed software to $installedSoftwareFile"
dpkg-query -l > "$installedSoftwareFile"

echo "Investigation completed. Results saved to $outputDir."