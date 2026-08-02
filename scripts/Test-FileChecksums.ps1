param(
    [Parameter(Mandatory = $true)]
    [string]$ChecksumFile,

    [string]$BasePath = ""
)

$ErrorActionPreference = "Stop"

$checksumPath = (Resolve-Path $ChecksumFile).Path

if ([string]::IsNullOrWhiteSpace($BasePath)) {
    $BasePath = Split-Path -Parent $checksumPath
}

$resolvedBase = (Resolve-Path $BasePath).Path
$records = Import-Csv -LiteralPath $checksumPath

$results = foreach ($record in $records) {
    $candidate = Join-Path $resolvedBase $record.RelativePath

    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        [pscustomobject]@{
            RelativePath = $record.RelativePath
            ExpectedHash = $record.SHA256
            ActualHash   = ""
            Status       = "Missing"
        }

        continue
    }

    $actualHash = (
        Get-FileHash -LiteralPath $candidate -Algorithm SHA256
    ).Hash

    [pscustomobject]@{
        RelativePath = $record.RelativePath
        ExpectedHash = $record.SHA256
        ActualHash   = $actualHash
        Status       = if ($actualHash -eq $record.SHA256) {
            "Match"
        }
        else {
            "Mismatch"
        }
    }
}

$failed = $results |
    Where-Object { $_.Status -ne "Match" }

$results |
    Format-Table -AutoSize

if ($failed) {
    throw "Checksum verification failed for $($failed.Count) item(s)."
}

Write-Host ""
Write-Host "All checksums match."
