# Analyze Prefetch files for execution history
Write-Host "Analyzing Prefetch Files..."
$prefetchPath = "$env:SystemRoot\Prefetch\*.pf"

Get-ChildItem $prefetchPath | ForEach-Object {
    $rawData = Get-Content $_.FullName -Encoding Byte -ReadCount 0
    $execCount = [System.BitConverter]::ToInt32($rawData[0x10..0x13], 0)
    $lastExec = [DateTime]::FromFileTime([System.BitConverter]::ToInt64($rawData[0x14..0x1B], 0))
    
    [PSCustomObject]@{
        Name = $_.Name
        LastExecution = $lastExec.ToString("yyyy-MM-dd HH:mm:ss")
        ExecutionCount = $execCount
        SizeMB = [math]::Round($_.Length / 1MB, 2)
    }
} | Format-Table -AutoSize
