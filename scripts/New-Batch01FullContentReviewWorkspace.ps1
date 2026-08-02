param(
    [string]$RepositoryRoot = (Resolve-Path "$PSScriptRoot\..").Path,
    [int]$BatchNumber = 1,
    [int]$FirstLesson = 1,
    [int]$LastLesson = 5,
    [string]$Version = "1.0.0"
)

$ErrorActionPreference = "Stop"

$qaDirectory = Join-Path $RepositoryRoot "quality-assurance"
$batchRoot = Join-Path $qaDirectory "manual-review-batches"
$batchDirectory = Join-Path `
    $batchRoot `
    ("Batch-{0:D2}-Lessons-{1:D2}-to-{2:D2}" -f $BatchNumber, $FirstLesson, $LastLesson)

$inventoryPath = Join-Path `
    $qaDirectory `
    "Final_Curriculum_Lesson_Inventory.csv"

$manifestPath = Join-Path `
    $batchDirectory `
    "Batch_Manifest.csv"

$decisionPath = Join-Path `
    $batchDirectory `
    "Batch_Decision_Record.csv"

$reviewWorkbookPath = Join-Path `
    $batchDirectory `
    "Batch_01_Full_Content_Review_Workbook.md"

$findingsPath = Join-Path `
    $batchDirectory `
    "Batch_01_Review_Findings_Register.csv"

$formulaReviewPath = Join-Path `
    $batchDirectory `
    "Batch_01_Formula_and_Example_Review.csv"

$sourceEvidencePath = Join-Path `
    $batchDirectory `
    "Batch_01_Source_and_Current_Claim_Review.csv"

$progressPath = Join-Path `
    $batchDirectory `
    "Batch_01_Review_Progress.md"

$requiredPaths = @(
    $inventoryPath,
    $manifestPath,
    $decisionPath
)

foreach ($requiredPath in $requiredPaths) {
    if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
        throw "Required review file is missing: $requiredPath"
    }
}

$inventory = @(
    Import-Csv -LiteralPath $inventoryPath |
    Where-Object {
        [int]$_.Lesson_Number -ge $FirstLesson -and
        [int]$_.Lesson_Number -le $LastLesson
    } |
    Sort-Object {
        [int]$_.Lesson_Number
    }
)

if ($inventory.Count -ne 5) {
    throw "Batch 1 should contain 5 lessons, but $($inventory.Count) were found."
}

$expectedNumbers = @($FirstLesson..$LastLesson)
$actualNumbers = @(
    $inventory |
    ForEach-Object {
        [int]$_.Lesson_Number
    }
)

$missingNumbers = @(
    $expectedNumbers |
    Where-Object {
        $_ -notin $actualNumbers
    }
)

if ($missingNumbers.Count -gt 0) {
    throw "Missing Batch 1 lesson numbers: $($missingNumbers -join ', ')"
}

$reviewDate = Get-Date -Format "yyyy-MM-dd"
$workbookSections = New-Object System.Collections.Generic.List[string]
$findingsRows = New-Object System.Collections.Generic.List[object]
$formulaRows = New-Object System.Collections.Generic.List[object]
$sourceRows = New-Object System.Collections.Generic.List[object]

foreach ($lesson in $inventory) {
    $lessonNumber = [int]$lesson.Lesson_Number
    $relativePath = $lesson.Relative_Path -replace "/", "\"
    $fullPath = Join-Path $RepositoryRoot $relativePath

    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        throw "Lesson source file is missing: $($lesson.Relative_Path)"
    }

    $content = Get-Content `
        -LiteralPath $fullPath `
        -Raw

    if ([string]::IsNullOrWhiteSpace($content)) {
        throw "Lesson source file is empty: $($lesson.Relative_Path)"
    }

    $primaryHeading = [regex]::Match(
        $content,
        '(?m)^#\s+(.+)$'
    ).Groups[1].Value.Trim()

    if ([string]::IsNullOrWhiteSpace($primaryHeading)) {
        throw "Lesson $lessonNumber does not contain a valid primary heading."
    }

    $wordCount = @(
        $content -split '\s+' |
        Where-Object {
            -not [string]::IsNullOrWhiteSpace($_)
        }
    ).Count

    $formulaMatches = @(
        [regex]::Matches(
            $content,
            '(?im)^.*\b(equals|divided by|multiplied by|formula|calculated as|calculation)\b.*$'
        ) |
        ForEach-Object {
            $_.Value.Trim()
        } |
        Select-Object -Unique
    )

    $numberExampleMatches = @(
        [regex]::Matches(
            $content,
            '(?im)^.*\b(example|result|percentage|annualized|return|cost|fee|ratio)\b.*\d.*$'
        ) |
        ForEach-Object {
            $_.Value.Trim()
        } |
        Select-Object -Unique
    )

    $currentClaimMatches = @(
        [regex]::Matches(
            $content,
            '(?im)^.*\b(current|currently|today|latest|as of|regulator|tax authority|law|rule|requirement|limit)\b.*$'
        ) |
        ForEach-Object {
            $_.Value.Trim()
        } |
        Select-Object -Unique
    )

    $externalLinks = @(
        [regex]::Matches(
            $content,
            'https?://[^\s\)\]>]+'
        ) |
        ForEach-Object {
            $_.Value.TrimEnd(".", ",", ";", ":")
        } |
        Select-Object -Unique
    )

    $formulaSummary = if ($formulaMatches.Count -gt 0) {
        ($formulaMatches | ForEach-Object { "- $_" }) -join "`n"
    }
    else {
        "- No formula indicator automatically detected."
    }

    $numberExampleSummary = if ($numberExampleMatches.Count -gt 0) {
        ($numberExampleMatches | ForEach-Object { "- $_" }) -join "`n"
    }
    else {
        "- No numerical-example indicator automatically detected."
    }

    $currentClaimSummary = if ($currentClaimMatches.Count -gt 0) {
        ($currentClaimMatches | ForEach-Object { "- $_" }) -join "`n"
    }
    else {
        "- No potentially time-sensitive claim indicator automatically detected."
    }

    $externalLinkSummary = if ($externalLinks.Count -gt 0) {
        ($externalLinks | ForEach-Object { "- $_" }) -join "`n"
    }
    else {
        "- No external URLs detected."
    }

    $workbookSections.Add(@"
# Review — Lesson $lessonNumber

## Identification

**Inventory title:** $($lesson.Lesson_Title)

**Primary source heading:** $primaryHeading

**Topic area:** $($lesson.Topic_Area)

**Source path:** ``$($lesson.Relative_Path)``

**Approximate word count:** $wordCount

## Complete Source Content

$content

## Reviewer Checklist

### Educational Accuracy

- [ ] Core ETF or investment concepts are accurate.
- [ ] Important distinctions are preserved.
- [ ] Terminology is used consistently.
- [ ] Risks and limitations are not understated.
- [ ] No guaranteed result is implied.
- [ ] The learning objective is met.

Finding:

### Formula and Example Accuracy

Automatically detected formula-related lines:

$formulaSummary

Automatically detected numerical-example lines:

$numberExampleSummary

- [ ] Every formula is mathematically correct.
- [ ] Variables and units are understandable.
- [ ] Percentage and decimal conventions are consistent.
- [ ] Numerical examples reproduce the stated result.
- [ ] Rounding does not change the conclusion.
- [ ] No false precision is presented.
- [ ] Not applicable.

Finding:

### Sources and Current Claims

Potentially time-sensitive or authority-related lines:

$currentClaimSummary

External URLs detected:

$externalLinkSummary

- [ ] Current claims are supported appropriately.
- [ ] Stable educational explanations do not require unnecessary citation.
- [ ] Tax, legal, and regulatory conclusions remain conservative.
- [ ] Assumptions are distinguished from verified facts.
- [ ] Official sources are preferred where current verification is required.
- [ ] No obsolete product or regulatory statement is presented as current.

Finding:

### Financial Safety

- [ ] Educational disclaimer is present where needed.
- [ ] Potential loss is explained.
- [ ] Emergency liquidity is protected.
- [ ] Professional-review triggers are identified.
- [ ] Unsupported return claims are absent.
- [ ] Automatic stop conditions are adequate where appropriate.

Finding:

### Privacy and Confidentiality

- [ ] No completed private financial information.
- [ ] No account or identification numbers.
- [ ] No passwords, tokens, or credentials.
- [ ] No private medical or beneficiary details.
- [ ] Blank fields cannot be mistaken for completed private data.

Finding:

### Accessibility and Readability

- [ ] Primary heading is clear.
- [ ] Heading structure is logical.
- [ ] Acronyms are explained.
- [ ] Paragraphs and lists are readable.
- [ ] Tables are understandable.
- [ ] Meaning does not rely on color.
- [ ] Instructions are understandable to the intended learner.

Finding:

### Internal Consistency

- [ ] Lesson number is correct.
- [ ] File title and source heading agree.
- [ ] Related terminology matches other lessons.
- [ ] Knowledge check matches the content.
- [ ] Status checklist reflects the learning objective.
- [ ] Related templates and registers use compatible terminology.

Finding:

## Required Corrections

1.
2.
3.
4.

## Lesson Decision

- [ ] Approved
- [ ] Approved with conditions
- [ ] Correction required
- [ ] Rejected

Reviewer:

Review date:

Conditions or reason:

---

"@)

    $findingsRows.Add(
        [pscustomobject]@{
            Finding_ID = "B01-L{0:D2}-F01" -f $lessonNumber
            Version = $Version
            Batch_Number = $BatchNumber
            Lesson_Number = $lessonNumber
            Lesson_Title = $lesson.Lesson_Title
            Relative_Path = $lesson.Relative_Path
            Review_Domain = "Educational Accuracy"
            Severity = ""
            Finding_Description = ""
            Evidence_Section = ""
            Required_Correction = ""
            Owner = ""
            Target_Date = ""
            Correction_Commit = ""
            Verification_Result = "Pending"
            Verified_By = ""
            Verification_Date = ""
            Current_Status = "Pending Manual Review"
            Notes = ""
        }
    )

    $findingsRows.Add(
        [pscustomobject]@{
            Finding_ID = "B01-L{0:D2}-F02" -f $lessonNumber
            Version = $Version
            Batch_Number = $BatchNumber
            Lesson_Number = $lessonNumber
            Lesson_Title = $lesson.Lesson_Title
            Relative_Path = $lesson.Relative_Path
            Review_Domain = "Financial Safety and Limitations"
            Severity = ""
            Finding_Description = ""
            Evidence_Section = ""
            Required_Correction = ""
            Owner = ""
            Target_Date = ""
            Correction_Commit = ""
            Verification_Result = "Pending"
            Verified_By = ""
            Verification_Date = ""
            Current_Status = "Pending Manual Review"
            Notes = ""
        }
    )

    $formulaRows.Add(
        [pscustomobject]@{
            Formula_Review_ID = "B01-L{0:D2}-CALC" -f $lessonNumber
            Version = $Version
            Batch_Number = $BatchNumber
            Lesson_Number = $lessonNumber
            Lesson_Title = $lesson.Lesson_Title
            Relative_Path = $lesson.Relative_Path
            Formula_Indicator_Count = $formulaMatches.Count
            Numerical_Example_Indicator_Count = $numberExampleMatches.Count
            Formula_or_Example_Reviewed = "Pending"
            Manual_Recalculation_Result = ""
            Unit_and_Currency_Check = "Pending"
            Percentage_Convention_Check = "Pending"
            Rounding_Check = "Pending"
            Defect_Identified = "Pending"
            Required_Correction = ""
            Reviewer = ""
            Review_Date = ""
            Final_Status = "Pending Manual Review"
            Notes = ""
        }
    )

    $sourceRows.Add(
        [pscustomobject]@{
            Source_Review_ID = "B01-L{0:D2}-SRC" -f $lessonNumber
            Version = $Version
            Batch_Number = $BatchNumber
            Lesson_Number = $lessonNumber
            Lesson_Title = $lesson.Lesson_Title
            Relative_Path = $lesson.Relative_Path
            Potential_Current_Claim_Count = $currentClaimMatches.Count
            External_Link_Count = $externalLinks.Count
            Current_Claims_Reviewed = "Pending"
            Official_Source_Required = "Pending Determination"
            Official_Source_Verified = "Pending"
            Access_Date_Recorded = "Pending"
            Tax_or_Legal_Claim_Present = "Pending Determination"
            Tax_or_Legal_Language_Conservative = "Pending"
            Unsupported_Claim_Identified = "Pending"
            Required_Correction = ""
            Reviewer = ""
            Review_Date = ""
            Final_Status = "Pending Manual Review"
            Notes = ""
        }
    )
}

@"
# Batch 1 Full Content Review Workbook

## Release Information

Version:

$Version

Batch:

$BatchNumber

Lessons:

$FirstLesson through $LastLesson

Generated:

$reviewDate

## Status Warning

This workbook contains the full source text for Batch 1 to support human review.

Generation of this workbook does not mean:

- Any lesson has been reviewed
- any lesson is accurate
- any lesson has been approved
- Version 1.0 is approved
- publication is authorized

## Required Completion Standard

Every lesson must receive a documented decision after its complete source content is read.

$($workbookSections -join "`n")
"@ | Set-Content `
    -LiteralPath $reviewWorkbookPath `
    -Encoding UTF8

$findingsRows |
    Export-Csv `
        -LiteralPath $findingsPath `
        -NoTypeInformation `
        -Encoding UTF8

$formulaRows |
    Export-Csv `
        -LiteralPath $formulaReviewPath `
        -NoTypeInformation `
        -Encoding UTF8

$sourceRows |
    Export-Csv `
        -LiteralPath $sourceEvidencePath `
        -NoTypeInformation `
        -Encoding UTF8

$decisionRows = @(
    Import-Csv -LiteralPath $decisionPath
)

foreach ($decision in $decisionRows) {
    $decision.Review_Decision = "Pending"
    $decision.Critical_Defect_Count = 0
    $decision.High_Defect_Count = 0
    $decision.Moderate_Defect_Count = 0
    $decision.Low_Defect_Count = 0
    $decision.Corrections_Required = ""
    $decision.Correction_Commit = ""
    $decision.Correction_Verified = "No"
    $decision.Reviewer = ""
    $decision.Review_Date = ""
    $decision.Final_Status = "Pending Manual Review"
    $decision.Notes = "Full content review workbook generated; human review not yet completed."
}

$decisionRows |
    Export-Csv `
        -LiteralPath $decisionPath `
        -NoTypeInformation `
        -Encoding UTF8

@"
# Batch 1 Review Progress

## Scope

Version:

$Version

Lessons:

$FirstLesson through $LastLesson

Generated:

$reviewDate

## Current Status

| Lesson | Title | Review Status |
|---:|---|---|
$(
    (
        $inventory |
        ForEach-Object {
            "| $($_.Lesson_Number) | $($_.Lesson_Title) | Pending manual review |"
        }
    ) -join "`n"
)

## Review Files

- `Batch_01_Full_Content_Review_Workbook.md`
- `Batch_01_Review_Findings_Register.csv`
- `Batch_01_Formula_and_Example_Review.csv`
- `Batch_01_Source_and_Current_Claim_Review.csv`
- `Batch_Decision_Record.csv`
- `Batch_Review_Form.md`

## Required Sequence

1. Read the complete source for Lesson 1.
2. document accuracy, safety, privacy, and accessibility findings.
3. verify formulas and numerical examples.
4. review potentially current claims.
5. record any defect.
6. assign the lesson decision.
7. repeat for Lessons 2 through 5.
8. correct source files in a separate commit.
9. rerun QA.
10. independently verify corrections.

## Batch Release Gate

Current status:

**Blocked — human review has not been completed.**
"@ | Set-Content `
    -LiteralPath $progressPath `
    -Encoding UTF8

Write-Host ""
Write-Host "Batch 1 full-content review workspace created"
Write-Host "============================================="
Write-Host "Lessons prepared:      $($inventory.Count)"
Write-Host "Lesson range:          $FirstLesson-$LastLesson"
Write-Host "Human review complete: No"
Write-Host "Batch approved:        No"
Write-Host "Release gate:          Blocked"
Write-Host ""
Write-Host "Open this file to begin the review:"
Write-Host $reviewWorkbookPath
