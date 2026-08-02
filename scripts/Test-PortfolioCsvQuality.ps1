param(
    [string]$RepositoryRoot = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$csvFiles = Get-ChildItem `
    -Path $RepositoryRoot `
    -Recurse `
    -File `
    -Filter "*.csv" |
    Where-Object {
        $_.FullName -notmatch "\\.git\\" -and
        $_.FullName -notmatch "\\release-output\\"
    }

$results = New-Object System.Collections.Generic.List[object]
$hasFailure = $false

foreach ($file in $csvFiles) {
    $status = "PASS"
    $details = "CSV parsed successfully."
    $rowCount = 0
    $columnCount = 0

    try {
        $headerLine = Get-Content -Path $file.FullName -TotalCount 1

        if ([string]::IsNullOrWhiteSpace($headerLine)) {
            throw "Missing CSV header."
        }

        $headers = $headerLine -split ","
        $columnCount = $headers.Count

        if ($headers.Count -ne ($headers | Select-Object -Unique).Count) {
            throw "Duplicate CSV header detected."
        }

        if (($headers | Where-Object { [string]::IsNullOrWhiteSpace($_) }).Count -gt 0) {
            throw "Blank CSV header detected."
        }

        $rows = @(Import-Csv -Path $file.FullName)
        $rowCount = $rows.Count

        foreach ($row in $rows) {
            $propertyCount = @($row.PSObject.Properties).Count

            if ($propertyCount -ne $columnCount) {
                throw "Imported row does not match expected column count."
            }
        }
    }
    catch {
        $status = "FAIL"
        $details = $_.Exception.Message
        $hasFailure = $true
    }

    $results.Add([pscustomobject]@{
        File = $file.FullName.Substring($RepositoryRoot.Length).TrimStart("\")
        Status = $status
        Columns = $columnCount
        DataRows = $rowCount
        Details = $details
    })
}

$results | Sort-Object File | Format-Table -AutoSize

if ($hasFailure) {
    Write-Error "One or more CSV quality checks failed."
    exit 1
}

Write-Host ""
Write-Host "CSV quality checks passed for $($csvFiles.Count) file(s)."
