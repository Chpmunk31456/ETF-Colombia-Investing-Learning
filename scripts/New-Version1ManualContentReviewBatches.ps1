param(
    [string]$RepositoryRoot = (Resolve-Path "$PSScriptRoot\..").Path,
    [int]$ExpectedLessonCount = 65,
    [int]$BatchSize = 5,
    [string]$Version = "1.0.0"
)

$ErrorActionPreference = "Stop"

$qaDirectory = Join-Path $RepositoryRoot "quality-assurance"
$inventoryPath = Join-Path $qaDirectory "Final_Curriculum_Lesson_Inventory.csv"
$reviewRoot = Join-Path $qaDirectory "manual-review-batches"
$masterStatusPath = Join-Path $reviewRoot "Manual_Review_Batch_Status.csv"
$dashboardPath = Join-Path $reviewRoot "README.md"

if (-not (Test-Path -LiteralPath $inventoryPath -PathType Leaf)) {
    throw "The authoritative lesson inventory is missing: $inventoryPath"
}

$lessons = @(
    Import-Csv -LiteralPath $inventoryPath |
    Sort-Object { [int]$_.Lesson_Number }
)

if ($lessons.Count -ne $ExpectedLessonCount) {
    throw "Expected $ExpectedLessonCount lessons but found $($lessons.Count)."
}

$numbers = @($lessons | ForEach-Object { [int]$_.Lesson_Number })
$missingNumbers = @(1..$ExpectedLessonCount | Where-Object { $_ -notin $numbers })
$duplicateNumbers = @(
    $numbers |
    Group-Object |
    Where-Object Count -gt 1
)

if ($missingNumbers.Count -gt 0) {
    throw "Missing lesson numbers: $($missingNumbers -join ', ')"
}

if ($duplicateNumbers.Count -gt 0) {
    throw "Duplicate lesson numbers were found."
}

if (Test-Path -LiteralPath $reviewRoot) {
    Remove-Item -LiteralPath $reviewRoot -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $reviewRoot | Out-Null

$reviewDate = Get-Date -Format "yyyy-MM-dd"
$batchCount = [math]::Ceiling($ExpectedLessonCount / $BatchSize)
$batchStatusRows = New-Object System.Collections.Generic.List[object]

for ($batchNumber = 1; $batchNumber -le $batchCount; $batchNumber++) {
    $firstLesson = (($batchNumber - 1) * $BatchSize) + 1
    $lastLesson = [math]::Min(
        $firstLesson + $BatchSize - 1,
        $ExpectedLessonCount
    )

    $batchLessons = @(
        $lessons |
        Where-Object {
            [int]$_.Lesson_Number -ge $firstLesson -and
            [int]$_.Lesson_Number -le $lastLesson
        }
    )

    $batchName = "Batch-{0:D2}-Lessons-{1:D2}-to-{2:D2}" -f `
        $batchNumber,
        $firstLesson,
        $lastLesson

    $batchDirectory = Join-Path $reviewRoot $batchName
    $manifestPath = Join-Path $batchDirectory "Batch_Manifest.csv"
    $reviewPath = Join-Path $batchDirectory "Batch_Review_Form.md"
    $evidencePath = Join-Path $batchDirectory "Batch_Content_Evidence.md"
    $decisionPath = Join-Path $batchDirectory "Batch_Decision_Record.csv"

    New-Item -ItemType Directory -Force -Path $batchDirectory | Out-Null

    $manifestRows = foreach ($lesson in $batchLessons) {
        $sourcePath = Join-Path $RepositoryRoot $lesson.Relative_Path

        if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
            throw "Missing lesson file: $($lesson.Relative_Path)"
        }

        $content = Get-Content -LiteralPath $sourcePath -Raw
        $wordCount = @(
            $content -split '\s+' |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
        ).Count

        $headingCount = [regex]::Matches(
            $content,
            '(?m)^#{1,6}\s+\S'
        ).Count

        $formulaIndicators = [regex]::Matches(
            $content,
            '(?im)\b(formula|equals|divided by|multiplied by|calculation)\b'
        ).Count

        $externalLinkCount = [regex]::Matches(
            $content,
            'https?://'
        ).Count

        [pscustomobject]@{
            Batch_Number = $batchNumber
            Lesson_Number = $lesson.Lesson_Number
            Lesson_Title = $lesson.Lesson_Title
            Topic_Area = $lesson.Topic_Area
            Relative_Path = $lesson.Relative_Path
            Word_Count = $wordCount
            Heading_Count = $headingCount
            Formula_Indicators = $formulaIndicators
            External_Link_Count = $externalLinkCount
            Educational_Accuracy = "Pending Manual Review"
            Formula_Review = "Pending Manual Review"
            Evidence_Review = "Pending Manual Review"
            Financial_Safety_Review = "Pending Manual Review"
            Privacy_Review = "Pending Manual Review"
            Accessibility_Review = "Pending Manual Review"
            Final_Status = "Pending Manual Review"
            Reviewer = ""
            Review_Date = ""
            Required_Corrections = ""
            Notes = ""
        }
    }

    $manifestRows |
        Export-Csv `
            -LiteralPath $manifestPath `
            -NoTypeInformation `
            -Encoding UTF8

    $decisionRows = foreach ($lesson in $batchLessons) {
        [pscustomobject]@{
            Batch_Number = $batchNumber
            Lesson_Number = $lesson.Lesson_Number
            Lesson_Title = $lesson.Lesson_Title
            Review_Decision = "Pending"
            Critical_Defect_Count = 0
            High_Defect_Count = 0
            Moderate_Defect_Count = 0
            Low_Defect_Count = 0
            Corrections_Required = ""
            Correction_Commit = ""
            Correction_Verified = "No"
            Reviewer = ""
            Review_Date = ""
            Final_Status = "Pending Manual Review"
            Notes = ""
        }
    }

    $decisionRows |
        Export-Csv `
            -LiteralPath $decisionPath `
            -NoTypeInformation `
            -Encoding UTF8

    $evidenceSections = New-Object System.Collections.Generic.List[string]

    foreach ($lesson in $batchLessons) {
        $sourcePath = Join-Path $RepositoryRoot $lesson.Relative_Path
        $content = Get-Content -LiteralPath $sourcePath -Raw

        $primaryHeading = [regex]::Match(
            $content,
            '(?m)^#\s+(.+)$'
        ).Groups[1].Value.Trim()

        $objectiveMatch = [regex]::Match(
            $content,
            '(?ims)^##\s+Learning Objective\s*(.+?)(?=^##\s+|\z)'
        )

        $objective = if ($objectiveMatch.Success) {
            ($objectiveMatch.Groups[1].Value -replace '\s+', ' ').Trim()
        }
        else {
            "Learning Objective section not detected."
        }

        $knowledgeCheckMatch = [regex]::Match(
            $content,
            '(?ims)^##\s+Knowledge Check\s*(.+?)(?=^##\s+|\z)'
        )

        $knowledgeCheck = if ($knowledgeCheckMatch.Success) {
            $knowledgeCheckMatch.Groups[1].Value.Trim()
        }
        else {
            "Knowledge Check section not detected."
        }

        $evidenceSections.Add(@"
## Lesson $($lesson.Lesson_Number) — $($lesson.Lesson_Title)

**Source:** ``$($lesson.Relative_Path)``

**Primary heading:** $primaryHeading

### Learning objective extracted from source

$objective

### Knowledge check extracted from source

$knowledgeCheck

### Reviewer findings

Educational accuracy:

Formula and example accuracy:

Source and evidence quality:

Financial-safety concerns:

Privacy concerns:

Accessibility and readability concerns:

Required corrections:

Final recommendation:

- [ ] Approve
- [ ] Approve with conditions
- [ ] Correction required
- [ ] Reject

---
"@)
    }

    @"
# Manual Review Batch $batchNumber

## Scope

Version:

$Version

Lessons:

$firstLesson through $lastLesson

Generated:

$reviewDate

## Required Review Standard

Review every lesson for:

- Educational and technical accuracy
- formula and example accuracy
- internal consistency
- source and evidence quality
- conservative treatment of tax and legal issues
- financial-safety controls
- privacy and confidentiality
- accessibility and readability
- consistency with related templates and registers

## Lesson Decisions

$(
    (
        $batchLessons |
        ForEach-Object {
            "- [ ] Lesson $($_.Lesson_Number) — $($_.Lesson_Title)"
        }
    ) -join "`n"
)

## Batch-Level Verification

- [ ] All source files opened
- [ ] Every lesson received a documented decision
- [ ] Formulas and numerical examples checked
- [ ] Unsupported current claims identified
- [ ] Tax and legal conclusions kept conservative
- [ ] No private completed records found
- [ ] Heading and checklist structures reviewed
- [ ] Required defects entered in the defect register
- [ ] Corrections committed separately
- [ ] Corrections independently verified

## Batch Decision

- [ ] Approved
- [ ] Approved with conditions
- [ ] Correction required
- [ ] Rejected

Reviewer:

Review date:

Correction commit:

Verification reviewer:

Verification date:

Conditions or unresolved issues:
"@ | Set-Content `
        -LiteralPath $reviewPath `
        -Encoding UTF8

    @"
# Batch $batchNumber Content Evidence

Version:

$Version

Lessons:

$firstLesson through $lastLesson

Generated:

$reviewDate

This file extracts limited review anchors from each source lesson. Reviewers must still open and assess the complete lesson files.

$($evidenceSections -join "`n")
"@ | Set-Content `
        -LiteralPath $evidencePath `
        -Encoding UTF8

    $batchStatusRows.Add(
        [pscustomobject]@{
            Batch_Number = $batchNumber
            Batch_Name = $batchName
            First_Lesson = $firstLesson
            Last_Lesson = $lastLesson
            Lesson_Count = $batchLessons.Count
            Manifest = "quality-assurance/manual-review-batches/$batchName/Batch_Manifest.csv"
            Review_Form = "quality-assurance/manual-review-batches/$batchName/Batch_Review_Form.md"
            Evidence_File = "quality-assurance/manual-review-batches/$batchName/Batch_Content_Evidence.md"
            Decision_Record = "quality-assurance/manual-review-batches/$batchName/Batch_Decision_Record.csv"
            Review_Status = "Pending"
            Reviewer = ""
            Review_Date = ""
            Correction_Commit = ""
            Verification_Status = "Pending"
            Verification_Reviewer = ""
            Verification_Date = ""
            Release_Gate_Status = "Blocked"
            Notes = ""
        }
    )
}

$batchStatusRows |
    Export-Csv `
        -LiteralPath $masterStatusPath `
        -NoTypeInformation `
        -Encoding UTF8

@"
# Version 1.0 Manual Content Review Batches

## Current Status

Curriculum:

65 of 65 lessons complete

Review batches:

$batchCount

Batch size:

$BatchSize lessons, except the final batch when necessary

Manual content review:

Pending

Release approval:

Blocked until all batches are reviewed and verified

Publication:

Not authorized

## Batch Sequence

$(
    (
        $batchStatusRows |
        ForEach-Object {
            "- [ ] Batch $($_.Batch_Number): Lessons $($_.First_Lesson)–$($_.Last_Lesson)"
        }
    ) -join "`n"
)

## Required Process

For each batch:

1. Open `Batch_Manifest.csv`.
2. read every complete source lesson.
3. use `Batch_Content_Evidence.md` as a review aid only.
4. complete `Batch_Review_Form.md`.
5. update `Batch_Decision_Record.csv`.
6. record defects in the central defect register.
7. correct source files in a separate commit.
8. rerun automated QA.
9. verify corrections.
10. update `Manual_Review_Batch_Status.csv`.

## Permitted Lesson Decisions

- Approved
- Approved with conditions
- Correction required
- Rejected

## Release Gate

All 13 batches must have:

- Review status: Approved or Approved with conditions
- Verification status: Verified
- Release gate status: Pass

No critical defect may remain open.

## Important

Generated review packets do not constitute human review or release approval.
"@ | Set-Content `
    -LiteralPath $dashboardPath `
    -Encoding UTF8

Write-Host ""
Write-Host "Manual content review batches generated"
Write-Host "======================================="
Write-Host "Lessons:       $ExpectedLessonCount"
Write-Host "Batch size:    $BatchSize"
Write-Host "Batch count:   $batchCount"
Write-Host "Review status: Pending"
Write-Host "Release gate:  Blocked"
Write-Host ""
Write-Host "Master status:"
Write-Host $masterStatusPath
