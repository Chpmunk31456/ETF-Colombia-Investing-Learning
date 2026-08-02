param(
    [string]$RepositoryRoot = (Resolve-Path "$PSScriptRoot\..").Path,
    [string]$OutputDirectory = (Join-Path (Resolve-Path "$PSScriptRoot\..").Path "release-output"),
    [string]$Version = "1.0.0"
)

$ErrorActionPreference = "Stop"

function Invoke-CheckedPowerShellScript {
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath,

        [Parameter(Mandatory)]
        [string]$RepositoryRoot
    )

    & $ScriptPath -RepositoryRoot $RepositoryRoot

    if ($LASTEXITCODE -ne 0) {
        throw "Quality-assurance script failed: $ScriptPath"
    }
}

$repositoryRootPath = (Resolve-Path $RepositoryRoot).Path
New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null

Push-Location $repositoryRootPath

try {
    $gitCommand = Get-Command git -ErrorAction Stop
    $isRepository = git rev-parse --is-inside-work-tree

    if ($isRepository -ne "true") {
        throw "The selected directory is not a Git repository."
    }

    $workingTreeStatus = @(git status --porcelain)

    if ($workingTreeStatus.Count -gt 0) {
        throw "The working tree is not clean. Commit or remove reviewed changes before building."
    }

    $sourceCommit = (git rev-parse HEAD).Trim()
    $sourceBranch = (git branch --show-current).Trim()

    if ([string]::IsNullOrWhiteSpace($sourceBranch)) {
        $sourceBranch = "detached-head"
    }

    $versionFile = Join-Path $repositoryRootPath "VERSION"

    if (-not (Test-Path -LiteralPath $versionFile)) {
        throw "VERSION file is missing."
    }

    $repositoryVersion = (Get-Content -LiteralPath $versionFile -Raw).Trim()

    if ($repositoryVersion -ne $Version) {
        throw "Requested version '$Version' does not match VERSION '$repositoryVersion'."
    }

    $csvQaScript = Join-Path `
        $repositoryRootPath `
        "scripts\Test-PortfolioCsvQuality.ps1"

    $markdownQaScript = Join-Path `
        $repositoryRootPath `
        "scripts\Test-PortfolioMarkdownQuality.ps1"

    $releaseQaScript = Join-Path `
        $repositoryRootPath `
        "scripts\Test-RepositoryReleaseReadiness.ps1"

    Invoke-CheckedPowerShellScript `
        -ScriptPath $csvQaScript `
        -RepositoryRoot $repositoryRootPath

    Invoke-CheckedPowerShellScript `
        -ScriptPath $markdownQaScript `
        -RepositoryRoot $repositoryRootPath

    Invoke-CheckedPowerShellScript `
        -ScriptPath $releaseQaScript `
        -RepositoryRoot $repositoryRootPath

    $buildStamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $releaseBaseName = "ETF-Colombia-Investing-Learning-v$Version"
    $archivePath = Join-Path $OutputDirectory "$releaseBaseName.zip"
    $inventoryPath = Join-Path $OutputDirectory "$releaseBaseName-file-inventory.csv"
    $manifestPath = Join-Path $OutputDirectory "$releaseBaseName-manifest.json"
    $checksumPath = Join-Path $OutputDirectory "$releaseBaseName-SHA256.txt"
    $qaReportPath = Join-Path $OutputDirectory "$releaseBaseName-QA-report.txt"

    Remove-Item `
        -LiteralPath $archivePath, $inventoryPath, $manifestPath, $checksumPath, $qaReportPath `
        -Force `
        -ErrorAction SilentlyContinue

    $trackedFiles = @(
        git ls-files |
        Where-Object {
            -not [string]::IsNullOrWhiteSpace($_) -and
            $_ -notmatch "^release-output/"
        }
    )

    if ($trackedFiles.Count -eq 0) {
        throw "No tracked files were found for packaging."
    }

    $inventory = foreach ($relativePath in $trackedFiles) {
        $fullPath = Join-Path $repositoryRootPath $relativePath

        if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
            throw "Tracked file is missing from the working tree: $relativePath"
        }

        $item = Get-Item -LiteralPath $fullPath
        $hash = Get-FileHash -LiteralPath $fullPath -Algorithm SHA256
        $normalizedPath = $relativePath -replace "\\", "/"

        $category = switch -Regex ($normalizedPath) {
            "^templates/" { "Template"; break }
            "^quality-assurance/" { "Quality Assurance"; break }
            "^scripts/" { "Script"; break }
            "^release-tools/" { "Release Tool"; break }
            "^\.github/workflows/" { "Workflow"; break }
            "\.csv$" { "Register"; break }
            "\.md$" { "Lesson or Documentation"; break }
            default { "Other" }
        }

        [pscustomobject]@{
            RelativePath = $normalizedPath
            Category = $category
            Extension = $item.Extension
            SizeBytes = $item.Length
            LastWriteTimeUtc = $item.LastWriteTimeUtc.ToString("o")
            SHA256 = $hash.Hash
        }
    }

    $inventory |
        Sort-Object RelativePath |
        Export-Csv `
            -LiteralPath $inventoryPath `
            -NoTypeInformation `
            -Encoding UTF8

    git archive `
        --format=zip `
        --output="$archivePath" `
        --prefix="$releaseBaseName/" `
        HEAD

    if (-not (Test-Path -LiteralPath $archivePath)) {
        throw "Release archive was not created."
    }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [System.IO.Compression.ZipFile]::OpenRead($archivePath)

    try {
        if ($archive.Entries.Count -eq 0) {
            throw "Release archive contains no files."
        }

        $archiveEntryCount = $archive.Entries.Count
    }
    finally {
        $archive.Dispose()
    }

    $packageHash = Get-FileHash -LiteralPath $archivePath -Algorithm SHA256

    "$($packageHash.Hash)  $(Split-Path $archivePath -Leaf)" |
        Set-Content `
            -LiteralPath $checksumPath `
            -Encoding UTF8

    $markdownCount = @(
        $inventory |
        Where-Object { $_.Extension -eq ".md" }
    ).Count

    $csvCount = @(
        $inventory |
        Where-Object { $_.Extension -eq ".csv" }
    ).Count

    $templateCount = @(
        $inventory |
        Where-Object { $_.RelativePath -like "templates/*" }
    ).Count

    $scriptCount = @(
        $inventory |
        Where-Object { $_.Extension -eq ".ps1" }
    ).Count

    $workflowCount = @(
        $inventory |
        Where-Object { $_.RelativePath -like ".github/workflows/*" }
    ).Count

    $manifest = [ordered]@{
        project = "ETF Colombia Investing Learning"
        version = $Version
        release_status = "release-candidate"
        build_timestamp = (Get-Date).ToUniversalTime().ToString("o")
        build_stamp = $buildStamp
        source_branch = $sourceBranch
        source_commit = $sourceCommit
        expected_lesson_count = 65
        tracked_file_count = $trackedFiles.Count
        archive_entry_count = $archiveEntryCount
        markdown_file_count = $markdownCount
        csv_file_count = $csvCount
        template_count = $templateCount
        powershell_script_count = $scriptCount
        workflow_count = $workflowCount
        package_name = (Split-Path $archivePath -Leaf)
        package_sha256 = $packageHash.Hash
        inventory_file = (Split-Path $inventoryPath -Leaf)
        checksum_file = (Split-Path $checksumPath -Leaf)
        qa_status = "automated-checks-passed"
        publication_status = "not-published"
    }

    $manifest |
        ConvertTo-Json -Depth 5 |
        Set-Content `
            -LiteralPath $manifestPath `
            -Encoding UTF8

    @"
ETF Colombia Investing Learning
Version: $Version
Release status: Release candidate
Build timestamp: $($manifest.build_timestamp)
Source branch: $sourceBranch
Source commit: $sourceCommit

Automated QA:
- CSV validation: Passed
- Markdown validation: Passed
- Release-readiness validation: Passed
- Archive verification: Passed

Package:
- Name: $($manifest.package_name)
- SHA-256: $($manifest.package_sha256)
- Archive entries: $archiveEntryCount
- Tracked source files: $($trackedFiles.Count)

Publication:
- This build did not publish or push any artifact.
- Manual audit and release approval remain required.
"@ | Set-Content `
        -LiteralPath $qaReportPath `
        -Encoding UTF8

    Write-Host ""
    Write-Host "Version $Version release candidate created successfully."
    Write-Host "Archive:   $archivePath"
    Write-Host "Inventory: $inventoryPath"
    Write-Host "Manifest:  $manifestPath"
    Write-Host "Checksum:  $checksumPath"
    Write-Host "QA report: $qaReportPath"
    Write-Host ""
    Write-Host "No files were pushed or published."
}
finally {
    Pop-Location
}
