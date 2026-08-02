param(
    [string]$RepositoryPath = (Get-Location).Path,
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"

$repo = (Resolve-Path $RepositoryPath).Path

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $repo "quality-assurance\Curriculum_Lesson_Inventory.csv"
}

$outputDirectory = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

$lessonPattern = '^\s*#\s+Lesson\s+(\d+)\s+[—-]\s+(.+?)\s*$'

$lessonFiles = Get-ChildItem -Path $repo -Recurse -File -Filter "*.md" |
    Where-Object {
        $_.FullName -notmatch '[\\/]\.git[\\/]' -and
        $_.FullName -notmatch '[\\/]release-output[\\/]'
    }

$lessons = foreach ($file in $lessonFiles) {
    $lines = Get-Content -LiteralPath $file.FullName -TotalCount 25
    $matched = $false

    foreach ($line in $lines) {
        if ($line -match $lessonPattern) {
            $matched = $true

            [pscustomobject]@{
                LessonNumber = [int]$Matches[1]
                LessonTitle  = $Matches[2].Trim()
                Folder       = Split-Path `
                    ([IO.Path]::GetRelativePath($repo, $file.FullName)) `
                    -Parent
                RelativePath = [IO.Path]::GetRelativePath(
                    $repo,
                    $file.FullName
                )
                SizeBytes    = $file.Length
                SHA256       = (
                    Get-FileHash `
                        -LiteralPath $file.FullName `
                        -Algorithm SHA256
                ).Hash
            }

            break
        }
    }
}

$duplicateNumbers = $lessons |
    Group-Object LessonNumber |
    Where-Object { $_.Count -gt 1 }

if ($duplicateNumbers) {
    $details = foreach ($group in $duplicateNumbers) {
        "Lesson $($group.Name): " +
        (($group.Group.RelativePath) -join "; ")
    }

    throw "Duplicate lesson numbers detected: $($details -join ' | ')"
}

$lessons |
    Sort-Object LessonNumber |
    Export-Csv `
        -LiteralPath $OutputPath `
        -NoTypeInformation `
        -Encoding UTF8

Write-Host "Curriculum inventory generated:"
Write-Host $OutputPath
Write-Host "Lessons detected: $($lessons.Count)"
