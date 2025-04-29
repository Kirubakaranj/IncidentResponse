# Windows AutoRun Investigator v1.0.0
# Checks all autostart locations with digital signature verification

# Common autostart locations
$autostartPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup",
    "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Startup",
    "HKLM:\SYSTEM\CurrentControlSet\Services"
)

# Get autostart entries
$results = @()
foreach ($path in $autostartPaths) {
    if ($path -match "^HK") {
        # Registry entries
        try {
            $entries = Get-ItemProperty -Path $path -ErrorAction Stop
            foreach ($entry in $entries.PSObject.Properties) {
                if ($entry.Name -notmatch "PS") {
                    $filePath = $entry.Value
                    if ($filePath -match "^\".*\"") {
                        $filePath = $filePath -replace "^\"|\"$", ""
                    }
                    
                    $results += Get-FileInfo -Path $filePath -Source $path
                }
            }
        } catch {
            continue
        }
    } else {
        # Startup folder entries
        if (Test-Path $path) {
            $files = Get-ChildItem -Path $path -Recurse -File
            foreach ($file in $files) {
                $results += Get-FileInfo -Path $file.FullName -Source $path
            }
        }
    }
}

# Get file information
function Get-FileInfo {
    param (
        [string]$Path,
        [string]$Source
    )
    
    $fileInfo = @{
        Path = $Path
        Source = $Source
        Exists = Test-Path $Path
    }
    
    if ($fileInfo.Exists) {
        $file = Get-Item -Path $Path
        $fileInfo["LastWriteTime"] = $file.LastWriteTime.ToString("o")
        $fileInfo["Size"] = $file.Length
        $fileInfo["Hash"] = (Get-FileHash -Path $Path -Algorithm SHA256).Hash
        
        # Get signature information
        $sig = Get-AuthenticodeSignature -FilePath $Path
        $fileInfo["SignatureStatus"] = $sig.Status
        $fileInfo["IsSigned"] = $sig.Status -eq "Valid"
        $fileInfo["SignerCertificate"] = if ($sig.SignerCertificate) {
            @{
                Subject = $sig.SignerCertificate.Subject
                Thumbprint = $sig.SignerCertificate.Thumbprint
                NotAfter = $sig.SignerCertificate.NotAfter.ToString("o")
            }
        } else {
            $null
        }
    }
    
    return [PSCustomObject]$fileInfo
}

# Output results
$results | ConvertTo-Json -Depth 3
