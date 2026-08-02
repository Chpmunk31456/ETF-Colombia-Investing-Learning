param(
    [string]$RepositoryRoot = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$markdownFiles = Get-ChildItem `
    -Path $RepositoryRoot `
    -Recurse `
    -File `
    -Filter "*.md" |
    Where-Object {
        $_.FullName -notmatch "\\.git\\" -and
        $_.FullName -notmatch "\\release-output\\"
    }

$results = New-Object System.Collections.Generic.List[object]
$hasFailure = $false

foreach ($file in $markdownFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $status = "PASS"
    $details = "Markdown structure check passed."

    if ([string]::IsNullOrWhiteSpace($content)) {
        $status = "FAIL"
        $details = "File is empty."
    }
    elseif ($content -notmatch "(?m)^#\s+\S") {
        $status = "FAIL"
        $details = "No level-one Markdown heading found."
    }
    elseif ($content -match "(?i)(api[_-]?key|secret[_-]?key|password)\s*[:=]\s*\S+") {
        $status = "FAIL"
        $details = "Possible embedded credential detected."
    }

    if ($status -eq "FAIL") {
        $hasFailure = $true
    }

    $results.Add([pscustomobject]@{
        File = $file.FullName.Substring($RepositoryRoot.Length).TrimStart("\")
        Status = $status
        Details = $details
    })
}

$results | Sort-Object File | Format-Table -AutoSize

if ($hasFailure) {
    Write-Error "One or more Markdown quality checks failed."
    exit 1
}

Write-Host ""
Write-Host "Markdown quality checks passed for $($markdownFiles.Count) file(s)."
