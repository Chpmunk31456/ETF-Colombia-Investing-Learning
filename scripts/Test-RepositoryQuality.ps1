param(
    [string]$RepositoryPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

$repo = (Resolve-Path $RepositoryPath).Path
$qaDirectory = Join-Path $repo "quality-assurance"
New-Item -ItemType Directory -Force -Path $qaDirectory | Out-Null

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$reportPath = Join-Path $qaDirectory "Repository_Audit_$timestamp.md"
$inventoryPath = Join-Path $qaDirectory "Repository_File_Inventory_$timestamp.csv"
$checksumPath = Join-Path $qaDirectory "Repository_SHA256_$timestamp.csv"

$excludedDirectories = @(
    ".git"
)

function Test-ExcludedPath {
    param([string]$FullName)

    foreach ($directory in $excludedDirectories) {
        $segment = [IO.Path]::DirectorySeparatorChar + $directory +
            [IO.Path]::DirectorySeparatorChar

        if ($FullName.Contains($segment)) {
            return $true
        }
    }

    return $false
}

$allFiles = Get-ChildItem -Path $repo -Recurse -File |
    Where-Object { -not (Test-ExcludedPath -FullName $_.FullName) }

$markdownFiles = $allFiles |
    Where-Object { $_.Extension -ieq ".md" }

$csvFiles = $allFiles |
    Where-Object { $_.Extension -ieq ".csv" }

$emptyFiles = $allFiles |
    Where-Object { $_.Length -eq 0 }

$duplicateNames = $allFiles |
    Group-Object Name |
    Where-Object { $_.Count -gt 1 }

$lessonPattern = '^\s*#\s+Lesson\s+(\d+)\s+[—-]\s+(.+?)\s*$'
$lessons = @()

foreach ($file in $markdownFiles) {
    $firstLines = Get-Content -LiteralPath $file.FullName -TotalCount 20

    foreach ($line in $firstLines) {
        if ($line -match $lessonPattern) {
            $lessons += [pscustomobject]@{
                LessonNumber = [int]$Matches[1]
                LessonTitle  = $Matches[2].Trim()
            RelativePath = $file.FullName.Substring($repo.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
            }
            break
        }
    }
}

$duplicateLessonNumbers = $lessons |
    Group-Object LessonNumber |
    Where-Object { $_.Count -gt 1 }

$csvProblems = @()

foreach ($file in $csvFiles) {
    $firstLine = Get-Content -LiteralPath $file.FullName -TotalCount 1

    if ([string]::IsNullOrWhiteSpace($firstLine)) {
        $csvProblems += [pscustomobject]@{
            File = $file.FullName.Substring($repo.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
            Issue = "Missing or blank header row"
        }
        continue
    }

    $headers = $firstLine -split ','
    $duplicateHeaders = $headers |
        Group-Object |
        Where-Object { $_.Count -gt 1 }

    if ($duplicateHeaders) {
        $csvProblems += [pscustomobject]@{
            File  = $file.FullName.Substring($repo.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
            Issue = "Duplicate header names: " +
                (($duplicateHeaders.Name) -join ", ")
        }
    }
}

$brokenLinks = @()
$linkPattern = '\[[^\]]+\]\(([^)]+)\)'

foreach ($file in $markdownFiles) {
    $content = Get-Content -LiteralPath $file.FullName

    for ($lineNumber = 0; $lineNumber -lt $content.Count; $lineNumber++) {
        $matches = [regex]::Matches($content[$lineNumber], $linkPattern)

        foreach ($match in $matches) {
            $target = $match.Groups[1].Value.Trim()

            if (
                $target -match '^(https?|mailto):' -or
                $target.StartsWith("#") -or
                [string]::IsNullOrWhiteSpace($target)
            ) {
                continue
            }

            $targetWithoutAnchor = ($target -split '#')[0]
            $decodedTarget = [Uri]::UnescapeDataString($targetWithoutAnchor)
            $candidate = Join-Path $file.DirectoryName $decodedTarget

            if (-not (Test-Path -LiteralPath $candidate)) {
                $brokenLinks += [pscustomobject]@{
                    File   = $file.FullName.Substring($repo.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
                    Line   = $lineNumber + 1
                    Target = $target
                }
            }
        }
    }
}

$sensitiveFindings = @()

$sensitivePatterns = [ordered]@{
    "Possible private key" =
        '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'

    "Possible API token or secret assignment" =
        '(?i)\b(api[_-]?key|access[_-]?token|client[_-]?secret|password)\b\s*[:=]\s*["'']?[A-Za-z0-9_\-\/+=]{12,}'

    "Possible email address" =
        '(?i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b'

    "Possible payment-card pattern" =
        '\b(?:\d[ -]*?){13,19}\b'
}

$textFiles = $allFiles |
    Where-Object {
        $_.Extension -in @(
            ".md",
            ".csv",
            ".txt",
            ".json",
            ".yml",
            ".yaml",
            ".ps1"
        )
    }

foreach ($file in $textFiles) {
    $content = Get-Content -LiteralPath $file.FullName

    for ($lineNumber = 0; $lineNumber -lt $content.Count; $lineNumber++) {
        foreach ($patternName in $sensitivePatterns.Keys) {
            if ($content[$lineNumber] -match $sensitivePatterns[$patternName]) {
                $sensitiveFindings += [pscustomobject]@{
                    File    = $file.FullName.Substring($repo.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
                    Line    = $lineNumber + 1
                    Finding = $patternName
                }
            }
        }
    }
}

$inventory = foreach ($file in $allFiles) {
    [pscustomobject]@{
        RelativePath = $file.FullName.Substring($repo.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
        Extension     = $file.Extension
        SizeBytes     = $file.Length
        LastWriteTime = $file.LastWriteTime.ToString("s")
        SHA256        = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
    }
}

$inventory |
    Sort-Object RelativePath |
    Export-Csv -LiteralPath $inventoryPath -NoTypeInformation -Encoding UTF8

$inventory |
    Select-Object RelativePath, SHA256 |
    Sort-Object RelativePath |
    Export-Csv -LiteralPath $checksumPath -NoTypeInformation -Encoding UTF8

$gitStatus = & git -C $repo status --short 2>&1
$gitBranch = & git -C $repo branch --show-current 2>&1
$gitCommit = & git -C $repo rev-parse HEAD 2>&1

$report = New-Object System.Collections.Generic.List[string]

$report.Add("# Repository Quality-Assurance Audit")
$report.Add("")
$report.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')")
$report.Add("")
$report.Add("Repository: ``$repo``")
$report.Add("")
$report.Add("Branch: ``$gitBranch``")
$report.Add("")
$report.Add("Commit: ``$gitCommit``")
$report.Add("")
$report.Add("## Summary")
$report.Add("")
$report.Add("- Total files: $($allFiles.Count)")
$report.Add("- Markdown files: $($markdownFiles.Count)")
$report.Add("- CSV files: $($csvFiles.Count)")
$report.Add("- Lessons detected: $($lessons.Count)")
$report.Add("- Empty files: $($emptyFiles.Count)")
$report.Add("- Duplicate file names: $($duplicateNames.Count)")
$report.Add("- Duplicate lesson numbers: $($duplicateLessonNumbers.Count)")
$report.Add("- CSV issues: $($csvProblems.Count)")
$report.Add("- Broken relative links: $($brokenLinks.Count)")
$report.Add("- Possible sensitive-pattern findings: $($sensitiveFindings.Count)")
$report.Add("")

$report.Add("## Git Working Tree")
$report.Add("")

if ([string]::IsNullOrWhiteSpace(($gitStatus -join ""))) {
    $report.Add("Working tree was clean when checked.")
}
else {
$report.Add('```text')
    foreach ($line in $gitStatus) {
        $report.Add([string]$line)
    }
$report.Add('```')
}

$report.Add("")
$report.Add("## Detected Lessons")
$report.Add("")

foreach ($lesson in ($lessons | Sort-Object LessonNumber, RelativePath)) {
    $report.Add(
        "- Lesson $($lesson.LessonNumber): $($lesson.LessonTitle) — " +
        "``$($lesson.RelativePath)``"
    )
}

$report.Add("")
$report.Add("## Empty Files")
$report.Add("")

if ($emptyFiles.Count -eq 0) {
    $report.Add("None detected.")
}
else {
    foreach ($file in $emptyFiles) {
        $report.Add("- ``$($file.FullName.Substring($repo.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar))``")
    }
}

$report.Add("")
$report.Add("## Duplicate File Names")
$report.Add("")

if ($duplicateNames.Count -eq 0) {
    $report.Add("None detected.")
}
else {
    foreach ($group in $duplicateNames) {
        $report.Add("- **$($group.Name)**")
        foreach ($file in $group.Group) {
            $report.Add(
                "  - ``$($file.FullName.Substring($repo.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar))``"
            )
        }
    }
}

$report.Add("")
$report.Add("## Duplicate Lesson Numbers")
$report.Add("")

if ($duplicateLessonNumbers.Count -eq 0) {
    $report.Add("None detected.")
}
else {
    foreach ($group in $duplicateLessonNumbers) {
        $report.Add("- Lesson $($group.Name)")
        foreach ($lesson in $group.Group) {
            $report.Add("  - ``$($lesson.RelativePath)``")
        }
    }
}

$report.Add("")
$report.Add("## CSV Findings")
$report.Add("")

if ($csvProblems.Count -eq 0) {
    $report.Add("None detected.")
}
else {
    foreach ($problem in $csvProblems) {
        $report.Add("- ``$($problem.File)`` — $($problem.Issue)")
    }
}

$report.Add("")
$report.Add("## Broken Relative Links")
$report.Add("")

if ($brokenLinks.Count -eq 0) {
    $report.Add("None detected.")
}
else {
    foreach ($finding in $brokenLinks) {
        $report.Add(
            "- ``$($finding.File)`` line $($finding.Line): " +
            "``$($finding.Target)``"
        )
    }
}

$report.Add("")
$report.Add("## Possible Sensitive-Pattern Findings")
$report.Add("")
$report.Add(
    "These findings require manual review and may contain false positives."
)
$report.Add("")

if ($sensitiveFindings.Count -eq 0) {
    $report.Add("None detected by the configured patterns.")
}
else {
    foreach ($finding in $sensitiveFindings) {
        $report.Add(
            "- ``$($finding.File)`` line $($finding.Line): " +
            "$($finding.Finding)"
        )
    }
}

$report.Add("")
$report.Add("## Generated Evidence")
$report.Add("")
$report.Add(
    "- Inventory: ``$($inventoryPath.Substring($repo.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar))``"
)
$report.Add(
    "- Checksums: ``$($checksumPath.Substring($repo.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar))``"
)
$report.Add("")
$report.Add("## Required Manual Review")
$report.Add("")
$report.Add("- Validate every sensitive-pattern finding.")
$report.Add("- Review legal, tax, and regulatory statements for currency.")
$report.Add("- Confirm lesson sequence and curriculum index completeness.")
$report.Add("- Review accessibility, clarity, and terminology.")
$report.Add("- Confirm no completed personal templates are present.")
$report.Add("- Confirm the reviewed commit matches any release package.")

$report |
    Set-Content -LiteralPath $reportPath -Encoding UTF8

Write-Host ""
Write-Host "Repository audit completed."
Write-Host "Report: $reportPath"
Write-Host "Inventory: $inventoryPath"
Write-Host "Checksums: $checksumPath"
Write-Host ""

if (
    $emptyFiles.Count -gt 0 -or
    $duplicateLessonNumbers.Count -gt 0 -or
    $csvProblems.Count -gt 0 -or
    $brokenLinks.Count -gt 0
) {
    Write-Warning "Structural findings require review."
}
else {
    Write-Host "No configured structural failures were detected."
}

if ($sensitiveFindings.Count -gt 0) {
    Write-Warning "Possible sensitive information requires manual validation."
}

