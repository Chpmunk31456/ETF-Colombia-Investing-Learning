# Lesson 65 — Final Curriculum Audit, Publication Package, and Version 1.0 Release

## Learning Objective

Complete a final content, technical, accessibility, privacy, evidence, and publication review of the ETF Colombia Investing Learning curriculum; generate a reproducible Version 1.0 release candidate; verify its contents and checksums; and formally document release approval.

## Important Disclaimer

This curriculum is educational.

It does not provide individualized:

- Investment advice
- tax advice
- legal advice
- estate-planning advice
- accounting advice
- insurance advice
- real-estate advice
- brokerage recommendations

Financial laws, tax rules, investment products, broker services, investor protections, prices, interest rates, and regulatory requirements can change.

Learners should verify current authoritative information and obtain qualified professional advice before making material financial decisions.

## Final Curriculum Objective

The complete curriculum should help learners progress from basic investment concepts to a controlled household investment process covering:

- ETF fundamentals
- Colombian investments
- cross-border tax awareness
- household financial foundations
- portfolio construction
- investment mathematics
- risk and scenario analysis
- broker and custody due diligence
- fraud prevention
- distressed-property review
- real-estate operations
- investment execution
- withdrawals and retirement income
- continuity and incapacity planning
- data quality and automated monitoring
- evidence governance
- capstone application

## Release Principle

A release is not complete merely because files exist.

A trustworthy release should be:

- Complete
- internally consistent
- understandable
- traceable
- reproducible
- privacy reviewed
- technically valid
- appropriately disclaimed
- accessible
- versioned
- independently reviewable

## Release States

Use the following release states.

### Draft

Content is still being created.

### Audit Candidate

All expected content exists, but final validation is incomplete.

### Release Candidate

Automated and manual review has been completed sufficiently for final approval.

### Approved Release

An authorized reviewer has approved the package.

### Published Release

The approved package has been made externally available.

### Superseded Release

A later approved version has replaced the release.

## Important Status Distinction

Do not describe a package as published merely because:

- It was committed locally
- a ZIP file was created
- a tag was created
- a release candidate passed QA

Publication requires a separate external action and confirmation.

## Version

This curriculum’s first planned complete edition is:

Version 1.0.0

## Semantic Versioning

A version may use:

MAJOR.MINOR.PATCH

### Major Version

Increase when changes materially alter:

- Curriculum structure
- learning objectives
- compatibility
- governance model

### Minor Version

Increase when adding backward-compatible:

- Lessons
- templates
- registers
- substantial educational content

### Patch Version

Increase for backward-compatible:

- Corrections
- formatting
- clarified language
- link updates
- minor QA improvements

## Release Scope

Version 1.0.0 should include:

- 65 lessons
- supporting CSV registers
- learner templates
- quality-assurance scripts
- GitHub Actions workflows
- release tools
- documentation
- final checksums
- release notes

## Audit Domains

The final release audit should cover twelve domains.

### Domain 1 — Curriculum Completeness

Verify:

- All 65 lessons are represented
- lesson sequence is understandable
- no planned topic is missing
- templates support major lessons
- registers support repeatable work
- capstone connects the curriculum

### Domain 2 — Educational Accuracy

Verify:

- Concepts are explained correctly
- formulas are defined
- examples are internally consistent
- distinctions are preserved
- limitations are disclosed
- uncertainty is not hidden

### Domain 3 — Internal Consistency

Verify consistent use of:

- ETF
- NAV
- ISIN
- ticker
- domicile
- distribution
- total return
- tracking difference
- tracking error
- drawdown
- currency exposure
- cost basis
- settlement
- investor protection

### Domain 4 — Cross-Reference Integrity

Verify:

- File references exist
- lesson references are correct
- template references are valid
- workflow paths exist
- script paths are correct
- no obsolete filenames remain

### Domain 5 — Evidence and Source Governance

Verify that material factual claims requiring external support can be connected to:

- Official sources
- access dates
- relevant sections
- limitations
- verification status

### Domain 6 — Privacy and Security

Verify that public files contain no:

- Account numbers
- identification numbers
- tax identifiers
- private medical information
- passwords
- API keys
- access tokens
- recovery codes
- beneficiary details
- private financial statements

### Domain 7 — Financial Safety

Verify that the curriculum:

- Distinguishes education from advice
- does not guarantee returns
- addresses loss risk
- protects emergency reserves
- addresses high-cost debt
- identifies professional-review needs
- discourages fraud and unsupported claims

### Domain 8 — Accessibility and Readability

Verify:

- Clear heading structure
- descriptive titles
- understandable language
- defined acronyms
- manageable paragraph length
- meaningful checklist labels
- text alternatives where graphics are added
- no reliance on color alone

### Domain 9 — Technical Integrity

Verify:

- Markdown files open correctly
- CSV headers are valid
- scripts parse
- workflows use valid paths
- expected directories exist
- file encoding is consistent
- release scripts execute safely

### Domain 10 — Reproducibility

Verify that another reviewer can reproduce:

- File inventory
- release package
- checksums
- QA results
- release notes
- version identification

### Domain 11 — Licensing and Attribution

Verify:

- Repository license is present or intentionally pending
- third-party material is not copied improperly
- external quotations are limited and attributed
- generated examples are original or appropriately cited
- trademark references are descriptive

### Domain 12 — Publication Readiness

Verify:

- Release notes are complete
- known limitations are listed
- checksums are generated
- package opens correctly
- release approval is documented
- rollback and correction process exists

## Curriculum Inventory

A final inventory should record:

- Relative path
- file category
- extension
- size
- last modification
- SHA-256 checksum
- release inclusion
- validation status

## File Categories

Use categories such as:

- Lesson
- template
- register
- script
- workflow
- quality assurance
- release documentation
- repository documentation
- other

## Lesson Count

The planned curriculum contains:

65 lessons

The release audit should verify the count using an approved inventory method.

## Lesson Identification Limitation

Because lesson files may be distributed across topic folders, automated counting should use:

- Explicit curriculum index
- approved lesson naming
- final manual reconciliation

Do not rely solely on counting every Markdown file.

## Curriculum Index

The curriculum index should show:

- Lesson number
- title
- topic area
- relative path
- completion status
- review status

## Orphan File

An orphan file is a curriculum file not represented in the approved inventory or index.

Orphan files should be:

- Added to the index
- excluded intentionally
- archived
- removed through a separate reviewed change

## Missing File

A missing file is referenced by the curriculum but absent from the repository.

A missing required file blocks release approval.

## Duplicate Content

Duplicate content should be reviewed to determine whether it is:

- Intentional reinforcement
- reusable policy language
- accidental duplication
- obsolete material

## Placeholder Content

Search for unresolved placeholders such as:

- TODO
- TBD
- FIXME
- INSERT
- REPLACE ME
- example.com
- incomplete brackets

A placeholder may be acceptable only when explicitly part of a blank learner template.

## Empty File

Required empty files block release.

CSV register files containing only an approved header are not considered empty.

## Broken Markdown Structure

Examples include:

- Missing primary heading
- malformed code fence
- invalid internal link
- accidental heading sequence
- unexplained raw HTML
- truncated file

## Link Validation

External links should be reviewed for:

- Availability
- authority
- relevance
- security
- current destination

Automated link checking can produce false results because some sites block automated requests.

## External-Link Limitation

A link’s availability does not prove that:

- Content is correct
- information is current
- the source is authoritative
- the source supports the claim

## CSV Quality

CSV files should have:

- Unique headers
- nonblank headers
- consistent column count
- valid encoding
- documented purpose
- no private completed records

## Template Quality

Templates should:

- Explain their purpose
- contain understandable fields
- distinguish blank input from instruction
- include privacy warnings where needed
- avoid implying professional approval

## Script Quality

Scripts should:

- Use safe default paths
- stop on material errors
- avoid deleting source files
- avoid publishing automatically
- produce understandable output
- return nonzero status on critical failure

## Workflow Quality

Workflows should:

- Use least-privilege permissions
- validate repository content
- avoid exposing secrets
- avoid automatic publication without approval
- identify the operating system and shell

## Release Package

The release package should include approved repository files while excluding:

- `.git`
- temporary files
- prior release output
- private data
- secrets
- editor caches
- operating-system artifacts

## Release Manifest

The release manifest should include:

- Version
- build date
- source commit
- source branch
- file count
- lesson count
- package name
- package checksum
- QA status

## Source Commit

Every release candidate should identify the exact Git commit from which it was built.

## Clean Working Tree

A release should normally be built from a clean working tree.

Uncommitted changes make the release difficult to reproduce.

## Release Tag

A local annotated tag may identify an approved source commit.

Creating a local tag does not publish it.

Pushing a tag is a separate external action.

## Release Notes

Release notes should summarize:

- Curriculum purpose
- included topics
- major features
- known limitations
- educational disclaimer
- privacy warning
- installation or access method
- checksum verification
- version history

## Checksum

A checksum helps verify that a file has not changed unexpectedly.

This release uses:

SHA-256

## Checksum Limitation

A checksum verifies file identity relative to a known expected value.

It does not prove:

- Content accuracy
- safety
- authorship
- legal compliance
- suitability

## Release Candidate Directory

Release output should be written outside the curriculum source tree or into an excluded output directory.

This curriculum uses:

`release-output`

## Dry Run

A dry run performs validation without creating the final package.

## Build Run

A build run:

1. Verifies repository state.
2. runs QA scripts.
3. generates inventory.
4. creates an archive from the committed source.
5. calculates checksums.
6. writes the release manifest.
7. creates a QA report.

## Publication Gate

Publication should stop when:

- Lesson count is unresolved
- required files are missing
- QA scripts fail
- private information is detected
- repository state is dirty
- source commit is unknown
- release package cannot be opened
- checksum cannot be reproduced
- disclaimer is missing
- known critical defect remains open

## Manual Review

Automation cannot fully validate:

- Educational accuracy
- tone
- legal interpretation
- tax interpretation
- accessibility quality
- learner usability
- source appropriateness

These require human review.

## Independent Review

Where possible, a final reviewer should be different from the primary author.

## Conflict of Interest

A reviewer should disclose any conflict that may affect:

- Product discussion
- broker discussion
- professional recommendations
- commercial links
- financial incentives

## Defect Severity

### Critical

Release cannot proceed.

Examples:

- Private financial data exposed
- materially unsafe instruction
- false guarantee
- corrupted package
- missing major curriculum section
- embedded credential

### High

Release should normally stop until corrected.

Examples:

- Materially incorrect formula
- broken core workflow
- incorrect file reference
- major disclaimer omission

### Moderate

Correction should be scheduled before or soon after release.

Examples:

- Inconsistent term
- missing minor cross-reference
- unclear template field

### Low

Minor improvement.

Examples:

- Typographical error
- optional formatting enhancement
- minor wording refinement

## Defect Register

Every release defect should identify:

- ID
- severity
- file
- description
- owner
- corrective action
- target date
- verification
- status

## Waiver

A noncritical defect may be waived only when:

- Risk is understood
- rationale is documented
- approver is identified
- correction plan exists
- expiration is defined

Critical defects should not be waived.

## Release Approval

Release approval should document:

- Version
- source commit
- QA result
- manual-review result
- unresolved defects
- accepted waivers
- package checksum
- approver
- approval date

## Publication Channels

Possible future publication channels include:

- GitHub repository
- GitHub release
- GitHub Pages
- Zenodo
- Internet Archive
- educational-resource repository

Each publication channel should preserve:

- Version
- attribution
- license
- disclaimer
- checksum where practical

## Citation Record

A citation record may include:

- Author or organization
- title
- version
- year
- repository
- persistent identifier when available
- license

## Correction Policy

After publication:

1. Record the defect.
2. assess severity.
3. preserve the original release.
4. correct the source.
5. rerun QA.
6. issue an appropriate patch, minor, or major version.
7. document the change.
8. avoid silently replacing historical artifacts.

## Withdrawal Policy

A published release may need withdrawal when it contains:

- Exposed personal data
- serious unsafe guidance
- copyright violation
- corrupted files
- material legal concern

Withdrawal should be documented.

## Archival Policy

Retain:

- Release package
- manifest
- checksum
- release notes
- source commit
- audit report
- approval record
- defect register

## Release Review Frequency

### Before Every Release

Run:

- Content audit
- privacy scan
- technical QA
- inventory
- checksum generation
- package verification

### Quarterly After Publication

Review:

- Broken authoritative links
- significant regulatory changes
- material product changes
- reported defects

### Annually

Review:

- Curriculum relevance
- legal and tax disclaimers
- accessibility
- sources
- scripts
- workflows
- publication channels
- version strategy

## Version 1.0 Known Limitations

Version 1.0 should clearly state:

- It is educational, not individualized advice.
- Blank templates require learner completion.
- Tax and legal rules must be verified.
- Product information can change.
- Automated QA cannot prove substantive accuracy.
- No investment outcome is guaranteed.
- Translation and localization may require separate review.
- Accessibility should be reassessed when graphical editions are created.

## Version 1.0 Completion Criteria

Version 1.0 is ready for approval when:

- [ ] 65 lessons are indexed
- [ ] Required templates exist
- [ ] Required registers exist
- [ ] CSV validation passes
- [ ] Markdown validation passes
- [ ] Release-readiness validation passes
- [ ] Privacy review passes
- [ ] Final manual review is complete
- [ ] Critical defects equal zero
- [ ] Release package is generated
- [ ] Package checksum is recorded
- [ ] Release approval is signed
- [ ] Publication decision is documented

## Automatic Stop Conditions

Do not approve or publish Version 1.0 when:

- Lesson count cannot be reconciled
- required files are missing
- critical defects remain
- credentials or private data are present
- package differs from its manifest
- source commit is not identified
- release scripts fail
- working tree contains unreviewed changes
- disclaimer is missing
- audit evidence is incomplete
- package checksum is absent
- final reviewer has not approved it

## Beginner Rules

1. A commit is not the same as a publication.
2. Build releases from an identified clean commit.
3. verify the lesson inventory manually and automatically.
4. never publish private completed financial records.
5. stop on critical QA failures.
6. preserve checksums and manifests.
7. disclose limitations and unresolved issues.
8. use version numbers consistently.
9. preserve historical releases rather than silently replacing them.
10. publish only after formal approval.

## Knowledge Check

1. How does a release candidate differ from a published release?
2. Why should a release identify its source commit?
3. What is the purpose of a release manifest?
4. What does a SHA-256 checksum verify?
5. Why can automated QA not prove educational accuracy?
6. What is an orphan file?
7. Which defects should block release?
8. Why should completed private templates never be committed publicly?
9. What should happen after a material post-publication correction?
10. What conditions should stop Version 1.0 publication?

## Final Curriculum Status

Planned lessons:

65

After successful completion of this lesson and final audit:

- Curriculum development status: Complete
- Release status: Release candidate pending validation
- Publication status: Not automatically published

## Status

- [ ] Read the lesson
- [ ] Generate curriculum index
- [ ] reconcile all 65 lessons
- [ ] complete content audit
- [ ] complete terminology review
- [ ] complete privacy review
- [ ] complete accessibility review
- [ ] run CSV QA
- [ ] run Markdown QA
- [ ] run release-readiness QA
- [ ] generate file inventory
- [ ] build Version 1.0 release candidate
- [ ] verify release archive
- [ ] generate SHA-256 checksums
- [ ] complete release approval
- [ ] document publication decision
