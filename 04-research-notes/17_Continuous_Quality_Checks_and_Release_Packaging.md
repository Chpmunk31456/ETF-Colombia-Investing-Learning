# Lesson 45 — Continuous Quality Checks, Automated Curriculum Inventory, and Release Packaging

## Learning Objective

Learn how to automate routine repository-quality checks, generate a current curriculum inventory, create a controlled publication package, calculate checksums, and preserve evidence connecting a release to an exact Git commit.

## Core Principle

Manual review remains necessary, but repeatable checks should not depend entirely on memory.

Automation can help detect:

- Missing files
- Empty files
- Broken relative links
- Duplicate lesson numbers
- Invalid CSV headers
- Uncommitted changes
- Unexpected sensitive-pattern findings
- Missing release documents
- Differences between reviewed and packaged files

Automation supports review.

It does not replace professional, legal, tax, financial, privacy, accessibility, or editorial judgment.

## Continuous Quality Assurance

Continuous quality assurance means checking repository integrity whenever important changes occur.

Possible triggers include:

- Commit
- Pull request
- Merge
- Manual workflow run
- Publication-candidate preparation
- Scheduled maintenance review

## Local Checks

Local checks run on the contributor’s computer before a commit or release.

Advantages include:

- Fast feedback
- No external service required
- Easier correction before publishing
- Ability to inspect private working files locally

Limitations include:

- May be skipped
- Depends on local software
- Environment may differ from GitHub
- Results may not be preserved automatically

## Continuous Integration

Continuous integration, or CI, runs automated checks in a controlled environment.

Possible CI checks include:

- Repository audit
- Markdown structure
- Relative links
- CSV headers
- lesson numbering
- file inventory
- checksum generation
- secret scanning
- publication-package validation

## CI Does Not Prove Accuracy

A successful workflow does not prove:

- Financial accuracy
- Legal accuracy
- Tax accuracy
- Regulatory currency
- Investment suitability
- Accessibility quality
- Absence of every privacy issue
- Absence of every security issue

It proves only that the configured checks completed successfully.

## Workflow Trigger

A workflow may run when:

- Changes are pushed
- Pull requests are opened or updated
- A user starts it manually
- A release is prepared

Manual release packaging is preferable when publication requires explicit approval.

## Fail-Closed Principle

A publication workflow should stop when required checks fail.

Examples:

- Broken internal link
- Duplicate lesson number
- Empty core file
- uncommitted changes
- missing disclaimer
- missing curriculum index
- possible secret requiring review
- checksum-generation failure
- package-integrity mismatch

## Warning Versus Failure

Not every finding should fail the workflow.

### Failure

A condition that blocks publication automatically.

Examples:

- Missing file
- malformed CSV header
- duplicate lesson number
- broken relative link
- empty lesson
- package-generation error

### Warning

A condition requiring human review.

Examples:

- Possible email address
- possible long account-like number
- duplicate file name with legitimate purpose
- external link
- old modified date
- estimated value in an example

## Deterministic Output

A deterministic process should produce the same logical package from the same committed content.

Sources of unnecessary variation include:

- Current timestamps inside content
- temporary files
- local absolute paths
- generated reports from earlier runs
- platform-specific hidden files
- unsorted file lists

## Release Source Commit

Every package should record:

- Repository
- Branch
- Commit hash
- Commit date
- Package date
- Package version
- Review status
- Included files
- Excluded files
- Checksums

## Clean Working Tree Requirement

A release package should normally be created only when the Git working tree is clean.

This ensures the package corresponds to a committed state.

A dirty working tree may contain:

- Unreviewed edits
- untracked files
- temporary outputs
- sensitive material
- corrections not reflected in the recorded commit

## Release Version

A release version should follow a documented convention.

One simple approach is:

- Major: substantial structural change
- Minor: new lessons or major features
- Patch: corrections and minor improvements

Example:

`1.0.0`

## Publication Status

Use one status:

- Draft
- Reviewed Draft
- Publication Candidate
- Published
- Superseded
- Withdrawn

The packaging script should not claim that a package is published.

Publication is a separate intentional action.

## Curriculum Inventory

An automated curriculum inventory may record:

- Global lesson number
- Lesson title
- Relative file path
- Folder
- file size
- SHA-256 hash
- related topic

The inventory helps identify:

- Missing lessons
- duplicate lesson numbers
- unexpected renames
- files omitted from navigation
- files changed after review

## Lesson Detection

A lesson may be detected through a heading such as:

`# Lesson 45 — Continuous Quality Checks...`

The detection method should:

- Support an em dash
- support a standard hyphen where necessary
- read only the initial section
- record unmatched lesson-like files for manual review

## Package Inclusion Rules

A publication package may include:

- Root README
- Curriculum index
- lessons
- blank templates
- blank registers
- quality-assurance documentation
- license
- disclaimer
- change log
- release manifest
- checksum file

## Package Exclusion Rules

A publication package should exclude:

- `.git`
- local editor settings
- temporary files
- generated caches
- private completed worksheets
- local backups
- account statements
- personal documents
- prior package files
- unreviewed audit output
- secrets
- credentials

## Blank Templates

Blank templates may be included.

Completed templates should remain outside the public repository and release package.

## Release Staging Directory

A staging directory is a temporary controlled copy of release files.

Benefits include:

- Clear inclusion boundary
- easier privacy review
- clean checksum generation
- protection from unrelated repository files
- package preview before compression

## Release Manifest

A release manifest should identify:

- Version
- status
- branch
- commit
- build date
- file count
- archive name
- checksum file
- known limitations
- review requirements

## Archive

A ZIP archive can provide:

- Portable download
- retained folder structure
- single publication candidate
- easier checksum verification

The archive should be generated only after the staging directory is complete.

## Checksums

Generate SHA-256 checksums for:

- Each staged file
- Final archive

Checksums help identify whether files changed after packaging.

## Checksum Verification

A verifier should:

1. Read the checksum list.
2. locate each file.
3. calculate current SHA-256.
4. compare expected and actual values.
5. report missing or changed files.
6. return failure when mismatches exist.

## Release Reproducibility

A future reviewer should be able to determine:

- Which commit produced the package
- which files were included
- which files were excluded
- whether files changed
- whether required checks passed
- which limitations were known

## Build Log

A build log may record:

- Start time
- repository path
- branch
- commit
- validation results
- file count
- package path
- checksum path
- completion status

Avoid logging sensitive file contents.

## Automated Index Generation

An automated index can reduce stale navigation.

However, generated output should still be reviewed for:

- Correct titles
- logical sequence
- category placement
- renamed lessons
- duplicate numbers
- missing related templates
- readability

## README Integration

The root README may link to:

- `CURRICULUM_INDEX.md`
- repository disclaimer
- learning paths
- templates
- publication status
- quality-assurance instructions

## CI Artifact

A CI workflow may upload:

- Audit report
- file inventory
- checksum list
- curriculum inventory

CI artifacts should not automatically be treated as publication candidates.

## Manual Approval

Before release, require explicit review of:

- Content
- presentation
- privacy
- security
- links
- file integrity
- known limitations
- version
- target commit

## Release Candidate Naming

A clear naming convention may be:

`ETF-Colombia-Investing-Learning_v1.0.0_publication-candidate_<short-commit>.zip`

## Package Collision

The packaging process should stop or create a new directory when the proposed output already exists.

Do not silently overwrite a reviewed package.

## Build Directory Cleanup

Temporary staging directories should be removed only after:

- Archive creation
- checksum generation
- verification
- final path confirmation

## Package Verification

After creating the archive:

1. Calculate its checksum.
2. test that it can be opened.
3. inspect its top-level structure.
4. confirm the manifest is included.
5. confirm private files are excluded.
6. confirm file count.
7. preserve the build log.

## Known Limitations

Known limitations should be stated honestly.

Examples:

- External links not validated
- legal and tax claims require current professional review
- accessibility review incomplete
- formulas need independent review
- translations not available
- no formal investment advice provided

## Release Evidence

Preserve:

- QA report
- curriculum inventory
- release manifest
- file checksums
- archive checksum
- build log
- approval record
- Git commit
- publication-readiness checklist

## Continuous Improvement

After every release or significant QA problem:

- Review failed checks
- reduce false positives
- add missing tests
- improve documentation
- update exclusion rules
- strengthen privacy checks
- simplify manual procedures

## Automation Security

Scripts and workflows should avoid:

- Printing secrets
- writing credentials
- downloading unverified executables
- running arbitrary external code
- publishing automatically without approval
- packaging private working directories
- trusting file extensions alone

## Dependency Minimization

A simple educational project should prefer:

- Built-in PowerShell
- Git
- standard GitHub Actions
- clear scripts
- limited external dependencies

Fewer dependencies reduce maintenance and supply-chain risk.

## Workflow Permissions

CI workflows should use the minimum permissions required.

A quality-check workflow normally needs read access to repository contents.

It should not need:

- Write access
- release publishing
- package publishing
- issue creation
- secret access

unless those capabilities are intentionally added later.

## Publication Separation

Quality validation, package creation, and external publication should remain separate steps.

### Validation

Checks repository quality.

### Packaging

Creates a publication candidate.

### Publication

Makes an approved package publicly available.

## Automatic Stop Conditions

Do not create a publication candidate when:

- Working tree is dirty
- branch is unknown
- commit cannot be identified
- repository audit fails
- duplicate lesson numbers exist
- broken relative links exist
- required root files are missing
- staging directory contains excluded files
- checksum verification fails
- archive cannot be opened
- possible sensitive findings remain unresolved
- publication-readiness approval is incomplete

## Beginner Rules

1. Run local checks before committing.
2. Run CI on pushes and pull requests.
3. Separate warnings from blocking failures.
4. Package only committed content.
5. use a staging directory.
6. record the source commit.
7. generate file and archive checksums.
8. verify the package after creation.
9. require human approval before publication.
10. never treat a successful workflow as proof of financial or legal accuracy.

## Knowledge Check

1. What is continuous quality assurance?
2. Why does successful CI not prove content accuracy?
3. What is a fail-closed publication process?
4. Why should a working tree be clean?
5. What is a staging directory?
6. Why should a release record the source commit?
7. What is the purpose of a release manifest?
8. Why are checksums generated?
9. Why should packaging and publication remain separate?
10. What conditions should stop package creation?

## Status

- [ ] Read the lesson
- [ ] Add continuous quality workflow
- [ ] Generate curriculum inventory
- [ ] Define release inclusion rules
- [ ] Define release exclusion rules
- [ ] Create release packaging script
- [ ] Create checksum verifier
- [ ] Run local validation
- [ ] Test publication-candidate package
- [ ] Review CI permissions
- [ ] Document manual approval requirement
