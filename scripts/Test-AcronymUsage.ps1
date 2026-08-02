param(
    [string]$RepositoryPath = (Get-Location).Path,
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"

$repo = (Resolve-Path $RepositoryPath).Path

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path `
        $repo `
        "quality-assurance\Acronym_Usage_Report.csv"
}

$outputDirectory = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

$indexPath = Join-Path $repo "ACRONYM_INDEX.csv"

if (-not (Test-Path -LiteralPath $indexPath -PathType Leaf)) {
    throw "Acronym index not found: $indexPath"
}

$approvedAcronyms = Import-Csv -LiteralPath $indexPath
$approvedLookup = @{}

foreach ($record in $approvedAcronyms) {
    $approvedLookup[$record.Acronym] = $record
}

$excludedDirectories = @(
    ".git",
    "release-output"
)

function Test-ExcludedPath {
    param([string]$FullName)

    foreach ($directory in $excludedDirectories) {
        $segment = [IO.Path]::DirectorySeparatorChar +
            $directory +
            [IO.Path]::DirectorySeparatorChar

        if ($FullName.Contains($segment)) {
            return $true
        }
    }

    return $false
}

$markdownFiles = Get-ChildItem -Path $repo -Recurse -File -Filter "*.md" |
    Where-Object {
        -not (Test-ExcludedPath -FullName $_.FullName)
    }

$pattern = '\b[A-Z][A-Z0-9]{1,9}\b'
$findings = New-Object System.Collections.Generic.List[object]

foreach ($file in $markdownFiles) {
    $content = Get-Content -LiteralPath $file.FullName
    $seenInFile = @{}

    for ($lineNumber = 0; $lineNumber -lt $content.Count; $lineNumber++) {
        $matches = [regex]::Matches($content[$lineNumber], $pattern)

        foreach ($match in $matches) {
            $acronym = $match.Value

            if ($seenInFile.ContainsKey($acronym)) {
                continue
            }

            $seenInFile[$acronym] = $true
            $approved = $approvedLookup.ContainsKey($acronym)

            $firstUsePattern = if ($approved) {
                [regex]::Escape(
                    $approvedLookup[$acronym].Full_Term
                ) + '\s*\(' + [regex]::Escape($acronym) + '\)'
            }
            else {
                ""
            }

            $firstUseDefined = $false

            if ($approved -and -not [string]::IsNullOrWhiteSpace($firstUsePattern)) {
                $fullText = $content -join "`n"
                $firstUseDefined = $fullText -match $firstUsePattern
            }

            $findings.Add(
                [pscustomobject]@{
                    File = [IO.Path]::GetRelativePath(
                        $repo,
                        $file.FullName
                    )
                    Acronym = $acronym
                    First_Line = $lineNumber + 1
                    In_Acronym_Index = $approved
                    Full_Term = if ($approved) {
                        $approvedLookup[$acronym].Full_Term
                    }
                    else {
                        ""
                    }
                    First_Use_Definition_Detected = $firstUseDefined
                    Review_Status = if (-not $approved) {
                        "Add to index or confirm false positive"
                    }
                    elseif (-not $firstUseDefined) {
                        "Review first-use definition"
                    }
                    else {
                        "Pass"
                    }
                }
            )
        }
    }
}

$findings |
    Sort-Object File, Acronym |
    Export-Csv `
        -LiteralPath $OutputPath `
        -NoTypeInformation `
        -Encoding UTF8

$unapproved = $findings |
    Where-Object { -not $_.In_Acronym_Index }

$firstUseIssues = $findings |
    Where-Object {
        $_.In_Acronym_Index -and
        -not $_.First_Use_Definition_Detected
    }

Write-Host ""
Write-Host "Acronym review completed."
Write-Host "Report: $OutputPath"
Write-Host "Unique file-acronym findings: $($findings.Count)"
Write-Host "Not in acronym index: $($unapproved.Count)"
Write-Host "First-use review findings: $($firstUseIssues.Count)"
Write-Host ""
Write-Host "Manual validation is required because uppercase words may be false positives."
