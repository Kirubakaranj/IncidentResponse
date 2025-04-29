# Windows Event Log Triage v1.0.0
# Parses Security/Sysmon logs for common IoC patterns

param (
    [int]$Hours = 24
)

# Common IoC patterns
$iocPatterns = @(
    "powershell.*-nop.*-w.*hidden",
    "schtasks.*/create",
    "certutil.*-urlcache",
    "regsvr32.*/s.*scrobj.dll",
    "rundll32.*javascript",
    "wmic.*process.*call.*create",
    "mshta.*http",
    "bitsadmin.*/transfer",
    "net.*user.*/add",
    "net.*localgroup.*administrators.*/add"
)

# Get events from last X hours
$events = Get-WinEvent -FilterHashtable @{
    LogName = @("Security", "Microsoft-Windows-Sysmon/Operational")
    StartTime = (Get-Date).AddHours(-$Hours)
} -ErrorAction SilentlyContinue

# Analyze events
$results = @()
foreach ($event in $events) {
    $message = $event.Message
    $matches = @()
    
    foreach ($pattern in $iocPatterns) {
        if ($message -match $pattern) {
            $matches += $pattern
        }
    }
    
    if ($matches.Count -gt 0) {
        $results += [PSCustomObject]@{
            TimeCreated = $event.TimeCreated.ToString("o")
            EventID = $event.Id
            LogName = $event.LogName
            MatchedPatterns = $matches
            Message = $message
        }
    }
}

# Output results
if ($results.Count -gt 0) {
    $results | ConvertTo-Json -Depth 3
} else {
    [PSCustomObject]@{
        Status = "Success"
        Message = "No IoC matches found"
    } | ConvertTo-Json
}
