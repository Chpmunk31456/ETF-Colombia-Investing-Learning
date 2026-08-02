param(
    [string]$RepositoryRoot = (Resolve-Path "$PSScriptRoot\..").Path,
    [int]$ExpectedLessonCount = 65
)

$ErrorActionPreference = "Stop"
$failures = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

$requiredDirectories = @(
    "01-etf-fundamentals",
    "02-colombia-investments",
    "03-cross-border-tax",
    "04-research-notes",
    "05-comparisons",
    "06-risk-and-scam-checks",
    "07-foreclosure-and-distressed-property",
    "templates",
    "scripts",
    "quality-assurance",
    ".github\workflows",
    "release-tools"
)

$requiredFiles = @(
    "VERSION",
    "RELEASE_NOTES_v1.0.0.md",
    "CURRICULUM_COMPLETION_STATUS.md",
    "quality-assurance\01_Final_Curriculum_Audit_Publication_Package_and_Version_1_0_Release.md",
    "quality-assurance\Final_Curriculum_Lesson_Inventory.csv",
    "templates\Version_1_Final_Curriculum_Audit_Checklist.md",
    "templates\Release_Candidate_Approval_Record.md"
)

foreach ($directory in $requiredDirectories) {
    $path = Join-Path $RepositoryRoot $directory

    if (-not (Test-Path -LiteralPath $path -PathType Container)) {
        $failures.Add("Missing required directory: $directory")
    }
}

foreach ($file in $requiredFiles) {
    $path = Join-Path $RepositoryRoot $file

    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        $failures.Add("Missing required file: $file")
    }
}

$versionPath = Join-Path $RepositoryRoot "VERSION"

if (Test-Path -LiteralPath $versionPath) {
    $version = (Get-Content -LiteralPath $versionPath -Raw).Trim()

    if ($version -ne "1.0.0") {
        $failures.Add("VERSION must contain 1.0.0 but contains '$version'.")
    }
}

$markdownFiles = @(
    Get-ChildItem `
        -Path $RepositoryRoot `
        -Recurse `
        -File `
        -Filter "*.md" |
    Where-Object {
        $_.FullName -notmatch "\\.git\\" -and
        $_.FullName -notmatch "\\release-output\\"
    }
)

$csvFiles = @(
    Get-ChildItem `
        -Path $RepositoryRoot `
        -Recurse `
        -File `
        -Filter "*.csv" |
    Where-Object {
        $_.FullName -notmatch "\\.git\\" -and
        $_.FullName -notmatch "\\release-output\\"
    }
)

$possibleSecrets = @(
    "(?i)api[_-]?key\s*[:=]\s*['""][^'""]+",
    "(?i)secret[_-]?key\s*[:=]\s*['""][^'""]+",
    "(?i)password\s*[:=]\s*['""][^'""]+",
    "(?i)access[_-]?token\s*[:=]\s*['""][^'""]+",
    "-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----"
)

$textFiles = @(
    Get-ChildItem `
        -Path $RepositoryRoot `
        -Recurse `
        -File |
    Where-Object {
        $_.Extension -in @(".md", ".csv", ".ps1", ".yml", ".yaml", ".txt", ".json") -and
        $_.FullName -notmatch "\\.git\\" -and
        $_.FullName -notmatch "\\release-output\\"
    }
)

foreach ($file in $textFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw

    foreach ($pattern in $possibleSecrets) {
        if ($content -match $pattern) {
            $relative = $file.FullName.Substring($RepositoryRoot.Length).TrimStart("\")
            $failures.Add("Possible embedded credential in: $relative")
            break
        }
    }
}

$placeholderPattern = "(?im)^\s*(TODO|TBD|FIXME|REPLACE ME)\s*[:\-]?"

foreach ($file in $markdownFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw

    if ($content -match $placeholderPattern) {
        $relative = $file.FullName.Substring($RepositoryRoot.Length).TrimStart("\")
        $warnings.Add("Possible unresolved placeholder in: $relative")
    }
}

$lessonInventoryPath = Join-Path `
    $RepositoryRoot `
    "quality-assurance\Final_Curriculum_Lesson_Inventory.csv"

if (Test-Path -LiteralPath $lessonInventoryPath) {
    $lessonInventory = @(Import-Csv -LiteralPath $lessonInventoryPath)

    if ($lessonInventory.Count -gt 0 -and $lessonInventory.Count -ne $ExpectedLessonCount) {
        $failures.Add(
            "Completed lesson inventory contains $($lessonInventory.Count) rows; expected $ExpectedLessonCount."
        )
    }

    if ($lessonInventory.Count -eq 0) {
        $warnings.Add(
            "Final curriculum lesson inventory contains only headers and requires manual completion."
        )
    }
}

$gitCommand = Get-Command git -ErrorAction SilentlyContinue

if (-not $gitCommand) {
    $failures.Add("Git is not available in PATH.")
}
else {
    Push-Location $RepositoryRoot

    try {
        $insideRepository = git rev-parse --is-inside-work-tree 2>$null

        if ($insideRepository -ne "true") {
            $failures.Add("RepositoryRoot is not a Git working tree.")
        }

        $status = @(git status --porcelain)

        if ($status.Count -gt 0) {
            $warnings.Add(
                "Working tree is not clean. Commit reviewed changes before building the final release."
            )
        }

        $head = git rev-parse HEAD 2>$null

        if ([string]::IsNullOrWhiteSpace($head)) {
            $failures.Add("Unable to determine Git HEAD.")
        }
    }
    finally {
        Pop-Location
    }
}

Write-Host ""
Write-Host "Release-readiness summary"
Write-Host "-------------------------"
Write-Host "Expected lessons: $ExpectedLessonCount"
Write-Host "Markdown files:   $($markdownFiles.Count)"
Write-Host "CSV files:        $($csvFiles.Count)"
Write-Host "Warnings:         $($warnings.Count)"
Write-Host "Failures:         $($failures.Count)"
Write-Host ""

foreach ($warning in $warnings) {
    Write-Warning $warning
}

foreach ($failure in $failures) {
    Write-Error $failure
}

if ($failures.Count -gt 0) {
    exit 1
}

Write-Host "Release-readiness checks passed."
exit 0
