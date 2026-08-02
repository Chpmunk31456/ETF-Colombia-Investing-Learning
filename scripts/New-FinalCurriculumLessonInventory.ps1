param(
    [string]$RepositoryRoot = (Resolve-Path "$PSScriptRoot\..").Path,
    [int]$ExpectedLessonCount = 65
)

$ErrorActionPreference = "Stop"

$outputPath = Join-Path `
    $RepositoryRoot `
    "quality-assurance\Final_Curriculum_Lesson_Inventory.csv"

$excludedDirectories = @(
    ".git",
    "templates",
    "release-output",
    "release-tools"
)

$markdownFiles = @(
    Get-ChildItem `
        -Path $RepositoryRoot `
        -Recurse `
        -File `
        -Filter "*.md" |
    Where-Object {
        $relativePath = $_.FullName.Substring($RepositoryRoot.Length).TrimStart("\")
        $topDirectory = ($relativePath -split "[\\/]")[0]

        $topDirectory -notin $excludedDirectories
    }
)

$lessonRecords = New-Object System.Collections.Generic.List[object]
$parseWarnings = New-Object System.Collections.Generic.List[string]

foreach ($file in $markdownFiles) {
    $content = Get-Content `
        -LiteralPath $file.FullName `
        -Raw

    $headingMatch = [regex]::Match(
        $content,
        '(?m)^#\s+Lesson\s+(\d+)\s+[—-]\s+(.+?)\s*$'
    )

    if (-not $headingMatch.Success) {
        continue
    }

    $lessonNumber = [int]$headingMatch.Groups[1].Value
    $lessonTitle = $headingMatch.Groups[2].Value.Trim()
    $relativePath = $file.FullName.Substring($RepositoryRoot.Length).TrimStart("\")
    $topicArea = Split-Path $relativePath -Parent

    if ([string]::IsNullOrWhiteSpace($topicArea)) {
        $topicArea = "Repository Root"
    }

    if ($lessonNumber -lt 1 -or $lessonNumber -gt $ExpectedLessonCount) {
        $parseWarnings.Add(
            "Out-of-range lesson number $lessonNumber in $relativePath"
        )
    }

    $lessonRecords.Add(
        [pscustomobject]@{
            Lesson_Number = $lessonNumber
            Lesson_Title = $lessonTitle
            Topic_Area = $topicArea
            Relative_Path = $relativePath -replace "\\", "/"
            File_Exists = "Yes"
            Content_Review_Status = "Pending Manual Review"
            Technical_Review_Status = "Automated QA Pending"
            Privacy_Review_Status = "Pending Manual Review"
            Accessibility_Review_Status = "Pending Manual Review"
            Final_Status = "Inventory Verified"
            Reviewed_By = ""
            Review_Date = ""
            Notes = ""
        }
    )
}

$duplicateLessons = @(
    $lessonRecords |
    Group-Object Lesson_Number |
    Where-Object Count -gt 1
)

$missingLessons = @(
    1..$ExpectedLessonCount |
    Where-Object {
        $_ -notin $lessonRecords.Lesson_Number
    }
)

$unexpectedLessons = @(
    $lessonRecords |
    Where-Object {
        $_.Lesson_Number -lt 1 -or
        $_.Lesson_Number -gt $ExpectedLessonCount
    }
)

Write-Host ""
Write-Host "Curriculum inventory validation"
Write-Host "==============================="
Write-Host "Expected lessons: $ExpectedLessonCount"
Write-Host "Parsed lessons:   $($lessonRecords.Count)"
Write-Host "Missing lessons:  $($missingLessons.Count)"
Write-Host "Duplicate numbers: $($duplicateLessons.Count)"
Write-Host "Out-of-range:     $($unexpectedLessons.Count)"
Write-Host ""

if ($parseWarnings.Count -gt 0) {
    foreach ($warning in $parseWarnings) {
        Write-Warning $warning
    }
}

if ($missingLessons.Count -gt 0) {
    Write-Host "Missing lesson numbers:"
    Write-Host ($missingLessons -join ", ")
}

if ($duplicateLessons.Count -gt 0) {
    Write-Host ""
    Write-Host "Duplicate lesson numbers:"

    foreach ($duplicate in $duplicateLessons) {
        Write-Host "Lesson $($duplicate.Name):"

        $duplicate.Group |
            ForEach-Object {
                Write-Host "  $($_.Relative_Path)"
            }
    }
}

if (
    $lessonRecords.Count -ne $ExpectedLessonCount -or
    $missingLessons.Count -gt 0 -or
    $duplicateLessons.Count -gt 0 -or
    $unexpectedLessons.Count -gt 0
) {
    throw "The curriculum could not be reconciled to one unique file for every lesson from 1 through $ExpectedLessonCount."
}

$orderedLessons = @(
    $lessonRecords |
    Sort-Object Lesson_Number
)

$orderedLessons |
    Export-Csv `
        -LiteralPath $outputPath `
        -NoTypeInformation `
        -Encoding UTF8

Write-Host "Curriculum inventory written to:"
Write-Host $outputPath
Write-Host ""

$orderedLessons |
    Select-Object `
        Lesson_Number,
        Lesson_Title,
        Topic_Area,
        Relative_Path |
    Format-Table -AutoSize

Write-Host ""
Write-Host "All lessons 1 through $ExpectedLessonCount were found exactly once."
