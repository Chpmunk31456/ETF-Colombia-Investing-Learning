param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^\d+\.\d+\.\d+$')]
    [string]$Version,

    [ValidateSet(
        "Draft",
        "Reviewed Draft",
        "Publication Candidate"
    )]
    [string]$PublicationStatus = "Publication Candidate",

    [string]$RepositoryPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

$repo = (Resolve-Path $RepositoryPath).Path
$outputRoot = Join-Path $repo "release-output"

$requiredFiles = @(
    "README.md",
    "CURRICULUM_INDEX.md"
)

$includedDirectories = @(
    "01-etf-fundamentals",
    "02-colombia-investments",
    "03-cross-border-tax",
    "04-research-notes",
    "05-comparisons",
    "06-risk-and-scam-checks",
    "07-foreclosure-and-distressed-property",
    "templates",
    "scripts",
    "quality-assurance"
)

$excludedNamePatterns = @(
    "*.tmp",
    "*.bak",
    "*.log",
    "*~",
    "Repository_Audit_*.md",
    "Repository_File_Inventory_*.csv",
    "Repository_SHA256_*.csv"
)

function Test-ExcludedName {
    param([string]$Name)

    foreach ($pattern in $excludedNamePatterns) {
        if ($Name -like $pattern) {
            return $true
        }
    }

    return $false
}

$gitStatus = & git -C $repo status --short 2>&1

if (-not [string]::IsNullOrWhiteSpace(($gitStatus -join ""))) {
    throw (
        "The Git working tree is not clean. " +
        "Commit, discard, or review all changes before packaging."
    )
}

$branch = (& git -C $repo branch --show-current).Trim()
$commit = (& git -C $repo rev-parse HEAD).Trim()
$shortCommit = (& git -C $repo rev-parse --short HEAD).Trim()
$commitDate = (
    & git -C $repo show -s --format=%cI HEAD
).Trim()

if ([string]::IsNullOrWhiteSpace($branch)) {
    throw "Unable to determine the current Git branch."
}

if ([string]::IsNullOrWhiteSpace($commit)) {
    throw "Unable to determine the current Git commit."
}

foreach ($requiredFile in $requiredFiles) {
    $candidate = Join-Path $repo $requiredFile

    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        throw "Required release file is missing: $requiredFile"
    }
}

$auditScript = Join-Path $repo "scripts\Test-RepositoryQuality.ps1"
$inventoryScript = Join-Path $repo "scripts\New-CurriculumInventory.ps1"

if (-not (Test-Path -LiteralPath $auditScript -PathType Leaf)) {
    throw "Repository-quality audit script is missing."
}

if (-not (Test-Path -LiteralPath $inventoryScript -PathType Leaf)) {
    throw "Curriculum-inventory script is missing."
}

Write-Host "Running repository-quality audit..."

& $auditScript -RepositoryPath $repo

Write-Host "Generating current curriculum inventory..."

$curriculumInventory = Join-Path `
    $repo `
    "quality-assurance\Curriculum_Lesson_Inventory.csv"

& $inventoryScript `
    -RepositoryPath $repo `
    -OutputPath $curriculumInventory

$packageName = (
    "ETF-Colombia-Investing-Learning_v$Version" +
    "_publication-candidate_$shortCommit"
)

$packageRoot = Join-Path $outputRoot $packageName
$stagingPath = Join-Path $packageRoot "staging"
$evidencePath = Join-Path $stagingPath "release-evidence"
$archivePath = Join-Path $packageRoot "$packageName.zip"
$fileChecksumPath = Join-Path `
    $evidencePath `
    "Release_File_SHA256.csv"

$archiveChecksumPath = Join-Path `
    $packageRoot `
    "$packageName.zip.sha256.txt"

$manifestPath = Join-Path `
    $evidencePath `
    "RELEASE_MANIFEST.md"

$buildLogPath = Join-Path `
    $packageRoot `
    "BUILD_LOG.txt"

if (Test-Path -LiteralPath $packageRoot) {
    throw "Release output already exists: $packageRoot"
}

New-Item -ItemType Directory -Force -Path $stagingPath | Out-Null
New-Item -ItemType Directory -Force -Path $evidencePath | Out-Null

$buildLog = New-Object System.Collections.Generic.List[string]
$buildLog.Add("Release package build")
$buildLog.Add("Version: $Version")
$buildLog.Add("Publication status: $PublicationStatus")
$buildLog.Add("Repository: $repo")
$buildLog.Add("Branch: $branch")
$buildLog.Add("Commit: $commit")
$buildLog.Add("Commit date: $commitDate")
$buildLog.Add("Build started: $(Get-Date -Format o)")

foreach ($requiredFile in $requiredFiles) {
    Copy-Item `
        -LiteralPath (Join-Path $repo $requiredFile) `
        -Destination (Join-Path $stagingPath $requiredFile)
}

foreach ($directory in $includedDirectories) {
    $sourceDirectory = Join-Path $repo $directory

    if (-not (Test-Path -LiteralPath $sourceDirectory -PathType Container)) {
        $buildLog.Add("Skipped missing optional directory: $directory")
        continue
    }

    $destinationDirectory = Join-Path $stagingPath $directory
    New-Item `
        -ItemType Directory `
        -Force `
        -Path $destinationDirectory |
        Out-Null

    $files = Get-ChildItem `
        -LiteralPath $sourceDirectory `
        -Recurse `
        -File

    foreach ($file in $files) {
        if (Test-ExcludedName -Name $file.Name) {
            continue
        }

        $relative = [IO.Path]::GetRelativePath(
            $sourceDirectory,
            $file.FullName
        )

        $destination = Join-Path $destinationDirectory $relative
        $destinationParent = Split-Path -Parent $destination

        New-Item `
            -ItemType Directory `
            -Force `
            -Path $destinationParent |
            Out-Null

        Copy-Item `
            -LiteralPath $file.FullName `
            -Destination $destination
    }
}

$stagedFilesBeforeManifest = Get-ChildItem `
    -LiteralPath $stagingPath `
    -Recurse `
    -File

$manifest = @"
# Release Manifest

## Identification

Version: $Version

Publication status: $PublicationStatus

Package name: $packageName

Branch: $branch

Commit: $commit

Commit date: $commitDate

Package date: $(Get-Date -Format o)

## Release Scope

This package contains educational material, blank templates, blank registers,
repository-quality scripts, and release evidence.

It does not provide individualized investment, legal, tax, insurance, property,
medical, or financial advice.

Completed personal worksheets and private supporting records must remain outside
the repository and this package.

## File Count Before Manifest and Checksums

$($stagedFilesBeforeManifest.Count)

## Required Human Reviews

- Content review
- Presentation review
- Privacy review
- Security review
- Accessibility review
- Legal and tax wording review
- Final publication approval

## Known Limitations

- External links are not comprehensively validated by the local audit.
- Automated sensitive-pattern detection can produce false positives.
- Current legal, tax, regulatory, institutional, and product information requires
  authoritative verification before reliance.
- Successful automated checks do not establish investment suitability.
- This package is not automatically published by the build process.

## Approval Status

This archive is a publication candidate only until explicit approval and release.
"@

$manifest |
    Set-Content `
        -LiteralPath $manifestPath `
        -Encoding UTF8

$stagedFilesForChecksums = Get-ChildItem `
    -LiteralPath $stagingPath `
    -Recurse `
    -File |
    Where-Object {
        $_.FullName -ne $fileChecksumPath
    }

$checksumRecords = foreach ($file in $stagedFilesForChecksums) {
    [pscustomobject]@{
        RelativePath = [IO.Path]::GetRelativePath(
            $stagingPath,
            $file.FullName
        )
        SHA256 = (
            Get-FileHash `
                -LiteralPath $file.FullName `
                -Algorithm SHA256
        ).Hash
    }
}

$checksumRecords |
    Sort-Object RelativePath |
    Export-Csv `
        -LiteralPath $fileChecksumPath `
        -NoTypeInformation `
        -Encoding UTF8

$finalStagedFiles = Get-ChildItem `
    -LiteralPath $stagingPath `
    -Recurse `
    -File

$emptyStagedFiles = $finalStagedFiles |
    Where-Object { $_.Length -eq 0 }

if ($emptyStagedFiles) {
    $emptyPaths = $emptyStagedFiles |
        ForEach-Object {
            [IO.Path]::GetRelativePath($stagingPath, $_.FullName)
        }

    throw (
        "Empty files detected in release staging: " +
        ($emptyPaths -join ", ")
    )
}

Write-Host "Creating archive..."

Compress-Archive `
    -Path (Join-Path $stagingPath "*") `
    -DestinationPath $archivePath `
    -CompressionLevel Optimal

if (-not (Test-Path -LiteralPath $archivePath -PathType Leaf)) {
    throw "Archive creation failed."
}

$archiveHash = (
    Get-FileHash `
        -LiteralPath $archivePath `
        -Algorithm SHA256
).Hash

"$archiveHash  $([IO.Path]::GetFileName($archivePath))" |
    Set-Content `
        -LiteralPath $archiveChecksumPath `
        -Encoding UTF8

$archiveTestPath = Join-Path $packageRoot "archive-test"
New-Item -ItemType Directory -Force -Path $archiveTestPath | Out-Null

Expand-Archive `
    -LiteralPath $archivePath `
    -DestinationPath $archiveTestPath `
    -Force

$expectedManifest = Join-Path `
    $archiveTestPath `
    "release-evidence\RELEASE_MANIFEST.md"

if (-not (Test-Path -LiteralPath $expectedManifest -PathType Leaf)) {
    throw "Archive verification failed: release manifest is missing."
}

$buildLog.Add("Staged file count: $($finalStagedFiles.Count)")
$buildLog.Add("Archive: $archivePath")
$buildLog.Add("Archive SHA256: $archiveHash")
$buildLog.Add("Archive verification: Passed")
$buildLog.Add("Build completed: $(Get-Date -Format o)")

$buildLog |
    Set-Content `
        -LiteralPath $buildLogPath `
        -Encoding UTF8

Remove-Item `
    -LiteralPath $archiveTestPath `
    -Recurse `
    -Force

Write-Host ""
Write-Host "Publication candidate created successfully."
Write-Host "Package directory: $packageRoot"
Write-Host "Archive: $archivePath"
Write-Host "Archive checksum: $archiveChecksumPath"
Write-Host "Build log: $buildLogPath"
Write-Host ""
Write-Host "No external publication was performed."
