# Set the output directory
$outputDir = "C:\LogExport"

# Create the output directory if it doesn't exist
if (!(Test-Path -Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Get current timestamp for file naming
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Export all Windows event logs
Get-WinEvent -ListLog * | ForEach-Object {
    $logName = $_.LogName
    $safeLogName = $logName -replace '[\\/:*?"<>|]', '_'
    $outputFile = Join-Path $outputDir "$safeLogName`_$timestamp.evtx"
    
    Write-Host "Exporting $logName to $outputFile"
    
    try {
        wevtutil epl $logName $outputFile
    } catch {
        Write-Warning "Failed to export $logName : $_"
    }
}

# Export system information
$sysInfoFile = Join-Path $outputDir "SystemInfo_$timestamp.txt"
Write-Host "Exporting system information to $sysInfoFile"
systeminfo > $sysInfoFile

# Export list of running processes
$processesFile = Join-Path $outputDir "RunningProcesses_$timestamp.csv"
Write-Host "Exporting list of running processes to $processesFile"
Get-Process | Export-Csv -Path $processesFile -NoTypeInformation

# Export network connections
$netConnectionsFile = Join-Path $outputDir "NetworkConnections_$timestamp.csv"
Write-Host "Exporting network connections to $netConnectionsFile"
Get-NetTCPConnection | Export-Csv -Path $netConnectionsFile -NoTypeInformation

# Export installed software
$softwareFile = Join-Path $outputDir "InstalledSoftware_$timestamp.csv"
Write-Host "Exporting list of installed software to $softwareFile"
Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor | Export-Csv -Path $softwareFile -NoTypeInformation

Write-Host "Log export completed. Files saved in $outputDir"