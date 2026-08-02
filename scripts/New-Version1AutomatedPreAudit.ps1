param(
    [string]$RepositoryRoot = (Resolve-Path "$PSScriptRoot\..").Path,
    [string]$Reviewer = "",
    [string]$Version = "1.0.0"
)

$ErrorActionPreference = "Stop"

$qaDirectory = Join-Path $RepositoryRoot "quality-assurance"
$lessonInventoryPath = Join-Path $qaDirectory "Final_Curriculum_Lesson_Inventory.csv"
$privacyRegisterPath = Join-Path $qaDirectory "Final_Privacy_and_Confidentiality_Review_Register.csv"
$accessibilityRegisterPath = Join-Path $qaDirectory "Final_Accessibility_and_Readability_Review_Register.csv"
$auditRegisterPath = Join-Path $qaDirectory "Version_1_Final_Audit_Register.csv"
$defectRegisterPath = Join-Path $qaDirectory "Release_Defect_and_Corrective_Action_Register.csv"
$reportPath = Join-Path $qaDirectory "Version_1_Automated_Pre_Audit_Report.md"

if (-not (Test-Path -LiteralPath $lessonInventoryPath -PathType Leaf)) {
    throw "Final curriculum lesson inventory is missing."
}

$reviewDate = Get-Date -Format "yyyy-MM-dd"
$reviewerValue = if ([string]::IsNullOrWhiteSpace($Reviewer)) {
    "Pending Manual Reviewer"
}
else {
    $Reviewer
}

$textExtensions = @(
    ".md",
    ".csv",
    ".ps1",
    ".yml",
    ".yaml",
    ".json",
    ".txt"
)

$files = @(
    Get-ChildItem `
        -Path $RepositoryRoot `
        -Recurse `
        -File |
    Where-Object {
        $_.Extension.ToLowerInvariant() -in $textExtensions -and
        $_.FullName -notmatch "\\.git\\" -and
        $_.FullName -notmatch "\\release-output\\"
    } |
    Sort-Object FullName
)

$privacyPatterns = [ordered]@{
    Potential_Account_Data = @(
        '(?i)\baccount\s*(number|no\.?|#)\s*[:=]\s*[A-Z0-9-]{5,}',
        '(?i)\bmasked\s+account\s*[:=]\s*(?!$)\S+'
    )
    Potential_Identity_Data = @(
        '(?i)\b(passport|cedula|cédula|social security|ssn|taxpayer identification)\s*(number|no\.?|#)?\s*[:=]\s*[A-Z0-9-]{5,}'
    )
    Potential_Tax_Data = @(
        '(?i)\b(tax identification|tax id|tin|ein|nit)\s*(number|no\.?|#)?\s*[:=]\s*[A-Z0-9-]{5,}'
    )
    Potential_Medical_Data = @(
        '(?i)\b(patient|diagnosis|medical record|clinical history)\s*(name|number|id)?\s*[:=]\s*\S+'
    )
    Potential_Credential = @(
        '(?i)\b(api[_-]?key|secret[_-]?key|access[_-]?token|password)\s*[:=]\s*["'']?\S+',
        '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'
    )
    Potential_Beneficiary_Data = @(
        '(?i)\bbeneficiary\s*(name|account|bank)\s*[:=]\s*\S+'
    )
}

$privacyResults = New-Object System.Collections.Generic.List[object]
$privacyDefects = New-Object System.Collections.Generic.List[object]

foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($RepositoryRoot.Length).TrimStart("\") -replace "\\", "/"
    $content = Get-Content -LiteralPath $file.FullName -Raw

    $categoryResults = [ordered]@{
        Potential_Account_Data = "No"
        Potential_Identity_Data = "No"
        Potential_Tax_Data = "No"
        Potential_Medical_Data = "No"
        Potential_Credential = "No"
        Potential_Beneficiary_Data = "No"
    }

    foreach ($category in $privacyPatterns.Keys) {
        foreach ($pattern in $privacyPatterns[$category]) {
            if ($content -match $pattern) {
                $categoryResults[$category] = "Potential Match"
                break
            }
        }
    }

    $matches = @(
        $categoryResults.GetEnumerator() |
        Where-Object Value -eq "Potential Match"
    )

    $manualResult = if ($matches.Count -gt 0) {
        "Pending Manual Review"
    }
    else {
        "No Automated Indicator"
    }

    $blocking = if (
        $categoryResults.Potential_Credential -eq "Potential Match"
    ) {
        "Yes"
    }
    else {
        "No"
    }

    $privacyResults.Add(
        [pscustomobject]@{
            Review_ID = "PRIV-{0:D4}" -f ($privacyResults.Count + 1)
            Version = $Version
            Review_Date = $reviewDate
            File_or_Directory = $relativePath
            Privacy_Category = "Repository File"
            Potential_Account_Data = $categoryResults.Potential_Account_Data
            Potential_Identity_Data = $categoryResults.Potential_Identity_Data
            Potential_Tax_Data = $categoryResults.Potential_Tax_Data
            Potential_Medical_Data = $categoryResults.Potential_Medical_Data
            Potential_Credential = $categoryResults.Potential_Credential
            Potential_Beneficiary_Data = $categoryResults.Potential_Beneficiary_Data
            Automated_Scan_Result = if ($matches.Count -gt 0) {
                "Potential Indicator"
            }
            else {
                "No Indicator"
            }
            Manual_Review_Result = $manualResult
            Release_Blocking = $blocking
            Corrective_Action = if ($matches.Count -gt 0) {
                "Review each potential match and confirm that it is a blank instructional field or remove private content."
            }
            else {
                ""
            }
            Reviewed_By = $reviewerValue
            Verification_Date = ""
            Current_Status = $manualResult
            Notes = ""
        }
    )

    if ($blocking -eq "Yes") {
        $privacyDefects.Add(
            [pscustomobject]@{
                Version = $Version
                Detected_Date = $reviewDate
                Severity = "Critical"
                Category = "Privacy and Security"
                Affected_File = $relativePath
                Line_or_Section = "Automated scan"
                Defect_Description = "Possible embedded credential or private key detected."
                Financial_or_Safety_Impact = "Potential unauthorized access or sensitive-data exposure."
                Release_Blocking = "Yes"
                Owner = "Repository Maintainer"
                Corrective_Action = "Inspect immediately, remove sensitive value, rotate affected credential if real, and rerun the scan."
                Target_Date = $reviewDate
                Resolution_Date = ""
                Verified_By = ""
                Verification_Date = ""
                Waiver_ID = ""
                Current_Status = "Open"
                Notes = "Automatically identified; manual confirmation required."
            }
        )
    }
}

$privacyResults |
    Export-Csv `
        -LiteralPath $privacyRegisterPath `
        -NoTypeInformation `
        -Encoding UTF8

$markdownFiles = @(
    $files |
    Where-Object Extension -eq ".md"
)

$accessibilityResults = New-Object System.Collections.Generic.List[object]

foreach ($file in $markdownFiles) {
    $relativePath = $file.FullName.Substring($RepositoryRoot.Length).TrimStart("\") -replace "\\", "/"
    $content = Get-Content -LiteralPath $file.FullName -Raw

    $hasH1 = $content -match '(?m)^#\s+\S'
    $headingJump = $content -match '(?m)^###\s+' -and $content -notmatch '(?m)^##\s+'
    $rawUrl = $content -match '(?m)(?<!\()https?://\S+'
    $colorOnly = $content -match '(?i)\b(click|select|choose|follow)\s+the\s+(red|green|yellow|blue)\b'
    $imageWithoutAlt = $content -match '!\[\]\([^)]+\)'
    $longLines = @(
        $content -split "`r?`n" |
        Where-Object {
            $_.Length -gt 240 -and
            $_ -notmatch '^\|' -and
            $_ -notmatch '^```'
        }
    ).Count

    $status = if (
        -not $hasH1 -or
        $headingJump -or
        $colorOnly -or
        $imageWithoutAlt
    ) {
        "Pending Correction or Manual Review"
    }
    elseif ($rawUrl -or $longLines -gt 0) {
        "Pending Manual Review"
    }
    else {
        "Automated Checks Passed"
    }

    $accessibilityResults.Add(
        [pscustomobject]@{
            Accessibility_ID = "ACC-{0:D4}" -f ($accessibilityResults.Count + 1)
            Version = $Version
            Review_Date = $reviewDate
            File_or_Section = $relativePath
            Heading_Structure = if ($hasH1 -and -not $headingJump) {
                "Pass"
            }
            else {
                "Review"
            }
            Plain_Language = if ($longLines -eq 0) {
                "No Automated Concern"
            }
            else {
                "Manual Review"
            }
            Acroynms_Defined = "Pending Manual Review"
            Tables_Understandable = "Pending Manual Review"
            Links_Descriptive = if ($rawUrl) {
                "Manual Review"
            }
            else {
                "No Automated Concern"
            }
            Color_Independent = if ($colorOnly) {
                "Review"
            }
            else {
                "Pass"
            }
            Graphics_Have_Text_Alternative = if ($imageWithoutAlt) {
                "Review"
            }
            else {
                "No Missing Alt Text Detected"
            }
            Keyboard_or_Screen_Reader_Concern = if (
                -not $hasH1 -or
                $headingJump -or
                $imageWithoutAlt
            ) {
                "Potential Concern"
            }
            else {
                "No Automated Concern"
            }
            Review_Status = $status
            Corrective_Action = if ($status -like "Pending Correction*") {
                "Correct structural issue or document an approved exception."
            }
            else {
                ""
            }
            Reviewed_By = $reviewerValue
            Verification_Date = ""
            Notes = if ($longLines -gt 0) {
                "$longLines line(s) exceed 240 characters and should be reviewed for readability."
            }
            else {
                ""
            }
        }
    )
}

$accessibilityResults |
    Export-Csv `
        -LiteralPath $accessibilityRegisterPath `
        -NoTypeInformation `
        -Encoding UTF8

$lessonInventory = @(Import-Csv -LiteralPath $lessonInventoryPath)

foreach ($lesson in $lessonInventory) {
    $lesson.File_Exists = if (
        Test-Path `
            -LiteralPath (Join-Path $RepositoryRoot $lesson.Relative_Path) `
            -PathType Leaf
    ) {
        "Yes"
    }
    else {
        "No"
    }

    $lesson.Technical_Review_Status = "Automated QA Pending Final Run"
    $lesson.Content_Review_Status = "Pending Manual Review"
    $lesson.Privacy_Review_Status = "Automated Pre-Audit Complete; Manual Review Pending"
    $lesson.Accessibility_Review_Status = "Automated Pre-Audit Complete; Manual Review Pending"
    $lesson.Final_Status = "Release Candidate Review Pending"
}

$lessonInventory |
    Export-Csv `
        -LiteralPath $lessonInventoryPath `
        -NoTypeInformation `
        -Encoding UTF8

$auditItems = @(
    [pscustomobject]@{
        Domain = "Curriculum Completeness"
        Item = "All 65 lessons appear exactly once in the authoritative inventory"
        Expected = "65 unique lessons"
        Actual = "$($lessonInventory.Count) inventory rows"
        Evidence = "quality-assurance/Final_Curriculum_Lesson_Inventory.csv"
        Severity = "Critical"
        Status = if ($lessonInventory.Count -eq 65) { "Automated Pass" } else { "Fail" }
    },
    [pscustomobject]@{
        Domain = "Privacy and Security"
        Item = "Repository text files scanned for private-data and credential indicators"
        Expected = "No confirmed private data or credentials"
        Actual = "$(@($privacyResults | Where-Object Automated_Scan_Result -eq 'Potential Indicator').Count) potential indicator file(s)"
        Evidence = "quality-assurance/Final_Privacy_and_Confidentiality_Review_Register.csv"
        Severity = "Critical"
        Status = if ($privacyDefects.Count -eq 0) {
            "Automated Scan Complete; Manual Review Pending"
        }
        else {
            "Fail"
        }
    },
    [pscustomobject]@{
        Domain = "Accessibility and Readability"
        Item = "Markdown files scanned for primary headings and basic accessibility indicators"
        Expected = "No release-blocking structural concern"
        Actual = "$(@($accessibilityResults | Where-Object Review_Status -like 'Pending Correction*').Count) potential structural concern file(s)"
        Evidence = "quality-assurance/Final_Accessibility_and_Readability_Review_Register.csv"
        Severity = "High"
        Status = if (
            @($accessibilityResults | Where-Object Review_Status -like "Pending Correction*").Count -eq 0
        ) {
            "Automated Scan Complete; Manual Review Pending"
        }
        else {
            "Review Required"
        }
    },
    [pscustomobject]@{
        Domain = "Educational Accuracy"
        Item = "Manual substantive review of lessons, formulas, examples, and limitations"
        Expected = "Independent reviewer approval"
        Actual = "Not performed by automated scan"
        Evidence = "templates/Version_1_Final_Curriculum_Audit_Checklist.md"
        Severity = "Critical"
        Status = "Pending Manual Review"
    },
    [pscustomobject]@{
        Domain = "Evidence and Sources"
        Item = "Manual verification of material external claims and source appropriateness"
        Expected = "Claims supported or clearly labeled as assumptions"
        Actual = "Not fully verifiable through automated scan"
        Evidence = "quality-assurance/Version_1_Final_Audit_Register.csv"
        Severity = "High"
        Status = "Pending Manual Review"
    },
    [pscustomobject]@{
        Domain = "Publication Readiness"
        Item = "Release approval and publication decision"
        Expected = "Signed approval record"
        Actual = "Not yet approved"
        Evidence = "templates/Release_Candidate_Approval_Record.md"
        Severity = "Critical"
        Status = "Pending Manual Approval"
    }
)

$auditRows = New-Object System.Collections.Generic.List[object]

foreach ($item in $auditItems) {
    $auditRows.Add(
        [pscustomobject]@{
            Audit_ID = "AUD-{0:D3}" -f ($auditRows.Count + 1)
            Audit_Date = $reviewDate
            Audit_Domain = $item.Domain
            Audit_Item = $item.Item
            Applicable = "Yes"
            Expected_Result = $item.Expected
            Actual_Result = $item.Actual
            Evidence_Location = $item.Evidence
            Severity_if_Failed = $item.Severity
            Control_Owner = "Repository Maintainer"
            Reviewer = $reviewerValue
            Review_Status = $item.Status
            Corrective_Action = ""
            Target_Date = ""
            Verification_Date = ""
            Notes = ""
        }
    )
}

$auditRows |
    Export-Csv `
        -LiteralPath $auditRegisterPath `
        -NoTypeInformation `
        -Encoding UTF8

$existingDefects = @()

if (Test-Path -LiteralPath $defectRegisterPath -PathType Leaf) {
    $existingDefects = @(
        Import-Csv -LiteralPath $defectRegisterPath |
        Where-Object {
            -not [string]::IsNullOrWhiteSpace($_.Defect_ID)
        }
    )
}

$newDefectRows = New-Object System.Collections.Generic.List[object]

foreach ($defect in $existingDefects) {
    $newDefectRows.Add($defect)
}

foreach ($defect in $privacyDefects) {
    $newDefectRows.Add(
        [pscustomobject]@{
            Defect_ID = "DEF-{0:D4}" -f ($newDefectRows.Count + 1)
            Version = $defect.Version
            Detected_Date = $defect.Detected_Date
            Severity = $defect.Severity
            Category = $defect.Category
            Affected_File = $defect.Affected_File
            Line_or_Section = $defect.Line_or_Section
            Defect_Description = $defect.Defect_Description
            Financial_or_Safety_Impact = $defect.Financial_or_Safety_Impact
            Release_Blocking = $defect.Release_Blocking
            Owner = $defect.Owner
            Corrective_Action = $defect.Corrective_Action
            Target_Date = $defect.Target_Date
            Resolution_Date = $defect.Resolution_Date
            Verified_By = $defect.Verified_By
            Verification_Date = $defect.Verification_Date
            Waiver_ID = $defect.Waiver_ID
            Current_Status = $defect.Current_Status
            Notes = $defect.Notes
        }
    )
}

$newDefectRows |
    Export-Csv `
        -LiteralPath $defectRegisterPath `
        -NoTypeInformation `
        -Encoding UTF8

$privacyIndicatorCount = @(
    $privacyResults |
    Where-Object Automated_Scan_Result -eq "Potential Indicator"
).Count

$accessibilityConcernCount = @(
    $accessibilityResults |
    Where-Object Review_Status -like "Pending Correction*"
).Count

@"
# Version 1.0 Automated Pre-Audit Report

## Report Information

Version:

$Version

Generated:

$reviewDate

Repository:

ETF Colombia Investing Learning

## Important Status

This report records automated pre-audit results.

It does not constitute:

- Manual educational-content approval
- legal or tax review
- accessibility certification
- release approval
- publication authorization

## Inventory

- Lessons in authoritative inventory: $($lessonInventory.Count)
- Text files scanned for privacy indicators: $($files.Count)
- Markdown files scanned for accessibility indicators: $($markdownFiles.Count)

## Privacy and Credential Scan

- Files with potential privacy indicators: $privacyIndicatorCount
- Critical credential-related defects generated: $($privacyDefects.Count)

Potential indicators require manual review because blank educational template labels may resemble private-data fields without containing actual private information.

## Accessibility and Readability Scan

- Markdown files requiring potential structural correction or review: $accessibilityConcernCount
- Files with automated checks passed or manual-only review remaining: $($markdownFiles.Count - $accessibilityConcernCount)

Automated checks cannot determine full screen-reader usability, plain-language quality, table comprehension, or substantive accessibility.

## Manual Review Still Required

1. Educational accuracy and internal consistency
2. Formula and example verification
3. Current-source and evidence review
4. Privacy confirmation of all potential indicators
5. Accessibility and readability review
6. Licensing and attribution review
7. Final defect disposition
8. Release-candidate approval
9. Separate publication authorization

## Release Status

- Curriculum development: Complete
- Automated pre-audit: Complete
- Manual audit: Pending
- Release approval: Pending
- Publication: Not authorized
"@ | Set-Content `
    -LiteralPath $reportPath `
    -Encoding UTF8

Write-Host ""
Write-Host "Automated Version 1 pre-audit complete"
Write-Host "======================================"
Write-Host "Lesson inventory rows:          $($lessonInventory.Count)"
Write-Host "Privacy indicator files:        $privacyIndicatorCount"
Write-Host "Critical credential defects:    $($privacyDefects.Count)"
Write-Host "Accessibility concern files:    $accessibilityConcernCount"
Write-Host "Manual approval remains:        Yes"
Write-Host "Publication authorized:         No"
Write-Host ""
Write-Host "Report:"
Write-Host $reportPath
