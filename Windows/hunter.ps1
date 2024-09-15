# Define the output CSV file
$outputFile = "C:\result.csv"

# Initialize an array to hold the results
$results = @()

# Get all drives on the system
$drives = Get-PSDrive -PSProvider FileSystem

# Loop through each drive and search for files with the .foxtrot25 extension
foreach ($drive in $drives) {
    Write-Host "Searching $($drive.Root)..."
    Get-ChildItem -Path $drive.Root -Recurse -Filter "*.foxtrot25" -ErrorAction SilentlyContinue | ForEach-Object {
        # Create a custom object for each file
        $fileInfo = [PSCustomObject]@{
            FullName          = $_.FullName
            CreationTime      = $_.CreationTime
            LastAccessTime    = $_.LastAccessTime
            LastWriteTime     = $_.LastWriteTime
        }
        # Add the custom object to the results array
        $results += $fileInfo
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path $outputFile -NoTypeInformation

Write-Host "Search completed. Results saved to $outputFile."