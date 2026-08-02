# Lesson 44 — Repository Quality Assurance, Curriculum Indexing, and Publication Readiness

## Learning Objective

Learn how to review an educational financial repository for completeness, consistency, usability, privacy, accessibility, file integrity, navigability, and publication readiness.

## Core Principle

A large body of educational content is not ready for publication merely because the files exist.

Publication readiness requires evidence that:

- Files are present
- Lesson numbering is coherent
- Links work
- Templates are usable
- CSV structures are valid
- No sensitive information is exposed
- Disclaimers are present
- Navigation is current
- Terminology is consistent
- The repository can be understood by a new learner

## Quality-Assurance Scope

The review should cover:

- Repository structure
- Markdown lessons
- Templates
- CSV registers
- Relative links
- File naming
- Lesson numbering
- Privacy
- Security
- Accessibility
- Source handling
- Git status
- Documentation
- Publication packaging

## Repository Structure

Expected major folders may include:

- `01-etf-fundamentals`
- `02-colombia-investments`
- `03-cross-border-tax`
- `04-research-notes`
- `05-comparisons`
- `06-risk-and-scam-checks`
- `07-foreclosure-and-distressed-property`
- `templates`
- `scripts`
- `quality-assurance`

Every folder should have a clear educational purpose.

## File Naming Standard

Use file names that are:

- Descriptive
- Stable
- Searchable
- Consistent
- Free of sensitive information
- Compatible with common operating systems

Recommended characteristics:

- Words separated by underscores
- Lesson number at the beginning where applicable
- Markdown extension for lessons and checklists
- CSV extension for structured registers
- No personal account identifiers
- No dates unless the date is materially relevant

## Lesson Numbering

Lesson numbering should be:

- Unique
- Sequential where practical
- Reflected in the curriculum index
- Consistent between title and file
- Free of duplicate lesson numbers

A folder-specific file number does not necessarily equal the global lesson number.

The curriculum index should identify the global lesson sequence explicitly.

## Lesson Metadata

Each lesson should contain:

- Lesson title
- Learning objective
- Core principles
- Educational disclaimer where appropriate
- Main concepts
- Practical controls
- Warning signs or stop conditions
- Beginner rules
- Knowledge check
- Completion status

Not every lesson requires identical headings, but important educational controls should not be omitted without reason.

## Template Review

A template should be:

- Blank or clearly hypothetical
- Understandable without the lesson open
- Free of personal data
- Consistent with the related lesson
- Usable in Markdown or spreadsheet form
- Clear about privacy where sensitive data may be entered

## CSV Review

Each CSV file should have:

- A header row
- Unique column names
- No accidental personal data
- Consistent delimiters
- No malformed quotations
- No unexplained duplicate columns
- A clear relationship to a lesson or procedure

## Link Review

Review Markdown links for:

- Missing relative file
- Incorrect capitalization
- incorrect folder
- renamed file
- external-link dependency
- link to private document
- link containing tracking data
- link to outdated material

Relative repository links should resolve from the file containing the link.

## External Sources

External sources should be:

- Official where possible
- Clearly identified
- Relevant
- Current enough for the claim
- Free of unnecessary tracking parameters
- Reviewed before publication

Time-sensitive legal, tax, regulatory, financial-product, and institutional information should be dated and independently verified.

## Privacy Review

The public repository should not contain:

- Full account numbers
- Tax returns
- Bank statements
- Medical records
- Identification documents
- Passwords
- Tokens
- API keys
- MFA recovery codes
- Private contracts
- Tenant records
- Beneficiary details
- Personal addresses
- Unredacted signatures
- Private professional advice

## Sensitive Pattern Review

Automated scanning may look for patterns resembling:

- Email addresses
- telephone numbers
- account numbers
- credit-card numbers
- API tokens
- private keys
- government identification numbers
- passwords
- authentication secrets

Automated detection may produce false positives and cannot replace human review.

## Git History Risk

Deleting a sensitive file from the current working tree does not necessarily remove it from Git history.

When sensitive information was committed:

1. Stop publication.
2. Rotate exposed credentials immediately.
3. assess the information disclosed.
4. preserve incident evidence.
5. use an appropriate Git-history remediation process.
6. notify affected parties where necessary.
7. verify the cleaned history.
8. document the incident.

## Accessibility Review

Educational content should support readers with differing abilities and experience levels.

Review:

- Clear headings
- Short paragraphs
- Plain-language explanations
- defined acronyms
- meaningful link text
- text alternatives for future graphics
- tables that remain understandable
- sufficient context around formulas
- no dependence on color alone
- consistent navigation

## Readability

Review for:

- Incomplete sentences
- unexplained jargon
- excessive repetition
- very long paragraphs
- inconsistent capitalization
- ambiguous instructions
- spelling errors
- duplicated sections
- unsupported conclusions

## Terminology Consistency

Examples of terms that should remain consistent include:

- Emergency reserve
- Investable capital
- Net worth
- Liquid net worth
- Target allocation
- Allocation drift
- Cost basis
- Settlement
- Policy exception
- Decision gate
- Stop condition
- Professional review

## Formula Review

Every formula should be checked for:

- Correct operators
- Correct units
- consistent currency
- correct denominator
- rounding
- timing assumptions
- missing costs
- interpretation

A formula that is mathematically correct may still be economically misleading if assumptions are incomplete.

## Cross-Reference Review

Confirm that each major lesson has related tools where useful.

Examples:

- Lesson plus checklist
- Lesson plus register
- Lesson plus annual review
- Lesson plus decision gate
- Lesson plus incident record

Avoid creating templates that are never referenced or explained.

## Duplicate Content

Duplicates may include:

- Same lesson under different file names
- same template copied twice
- overlapping registers with no distinct purpose
- repeated disclaimer blocks
- obsolete versions that appear current

Duplicates should be:

- Consolidated
- archived
- clearly distinguished
- or intentionally retained with documented purpose

## Orphan File

An orphan file exists in the repository but is not referenced by:

- README
- curriculum index
- lesson
- related procedure
- publication package

Not every orphan is incorrect, but each should be reviewed.

## Missing File

A missing file may be indicated when:

- README links to a file that does not exist
- lesson refers to a template that is absent
- workflow expects a file that was renamed
- publication package lists an unavailable artifact

## Empty File

An empty or nearly empty file may indicate:

- Failed generation
- interrupted write
- placeholder accidentally committed
- encoding problem

## Encoding Review

Use a consistent text encoding, preferably UTF-8.

Review for:

- Garbled accented characters
- unexpected byte-order marks where problematic
- corrupted punctuation
- unsupported symbols
- inconsistent line endings where tooling is affected

## Markdown Review

Check:

- Heading hierarchy
- unmatched code fences
- malformed tables
- malformed links
- duplicate top-level headings
- trailing placeholder text
- empty sections
- excessively long lines where readability suffers

## Curriculum Index

The curriculum index should show:

- Global lesson number
- Lesson title
- Primary folder
- File path
- Topic category
- Related templates or registers
- Completion status

## Learning Paths

Possible learning paths include:

### ETF Foundation Path

- ETF fundamentals
- costs
- diversification
- fund structure
- screening
- execution
- monitoring
- performance

### Colombia Investment Path

- Local investment landscape
- CDTs
- brokers
- property financing
- closing
- rental operations
- renovation
- property sale

### Cross-Border Path

- Tax questions
- reporting
- currency
- estate planning
- professional preparation

### Risk and Governance Path

- Fraud detection
- privacy
- insurance
- incident response
- service-provider due diligence
- governance
- control testing

### Financial Planning Path

- Investment policy
- personal balance sheet
- liquidity
- debt
- goals
- account simplification
- retirement cash flow

## Publication Readiness Levels

### Draft

Content exists but has not completed formal review.

### Reviewed Draft

Content has completed substantive review but may still require presentation or technical QA.

### Publication Candidate

Content has completed:

- Content review
- structural review
- link review
- privacy review
- formatting review
- file-integrity review

### Published

The approved publication candidate has been released intentionally.

Do not label a draft as published.

## Content Review

Content review should evaluate:

- Educational accuracy
- internal consistency
- scope
- missing concepts
- unsupported claims
- legal and tax disclaimers
- numerical examples
- learner suitability
- actionability

## Presentation Review

Presentation review should evaluate:

- Formatting
- headings
- tables
- navigation
- visual consistency
- accessibility
- file naming
- encoding
- compatibility

## Independent Review

A second reviewer should challenge:

- Assumptions
- completeness
- privacy
- formula accuracy
- legal and tax wording
- unclear instructions
- publication status

## Issue Severity

### Critical

Publication must stop.

Examples:

- Secret or credential exposed
- private financial data exposed
- dangerous instruction
- materially false legal or tax claim
- corrupted repository

### High

Material correction required before publication.

Examples:

- Broken core lesson
- incorrect formula
- missing major disclaimer
- missing essential file
- misleading financial comparison

### Moderate

Usability or consistency is materially reduced.

Examples:

- Broken internal link
- duplicate template
- inconsistent terminology
- missing index entry

### Low

Minor presentation issue.

Examples:

- Spelling
- punctuation
- noncritical formatting
- inconsistent spacing

## QA Issue Lifecycle

Use:

- New
- Confirmed
- Assigned
- Correction in progress
- Ready for retest
- Retest failed
- Resolved
- Accepted
- Deferred
- Closed

## Acceptance Criteria

A publication candidate should satisfy:

- Git working tree clean
- no known critical or high issues
- lesson inventory complete
- curriculum index current
- relative links validated
- no empty files
- no duplicate lesson numbers
- CSV headers present
- privacy review completed
- secret scan completed
- disclaimers reviewed
- documentation current
- release status approved

## Baseline Inventory

A baseline inventory records:

- Relative path
- File type
- Size
- Last modified date
- Hash
- Category

It helps detect unexpected changes.

## File Hash

A cryptographic hash can help verify that a file has not changed unexpectedly.

A changed hash does not prove malicious modification.

It indicates that the file contents differ.

## Release Manifest

A release manifest may include:

- Release name
- Date
- Commit
- Files included
- File hashes
- Known limitations
- Reviewers
- Approval
- Publication destination

## Versioning

A simple educational project may use:

- Major version for structural or conceptual change
- Minor version for new lessons
- Patch version for corrections

Example:

`1.4.2`

The specific versioning policy should be documented.

## Change Log

A change log should state:

- Version
- Date
- Added
- Changed
- Corrected
- Removed
- Security or privacy notes

## Publication Package

A publication package may contain:

- README
- Curriculum index
- Lessons
- Templates
- Registers
- License
- Disclaimer
- Change log
- Release manifest
- Checksums

Private completed worksheets must not be included.

## README Requirements

The root README should explain:

- Project purpose
- Intended audience
- Educational status
- No-guarantee disclaimer
- Repository structure
- Learning paths
- How to use templates
- Privacy warning
- Current publication status
- Contribution or correction process

## Repository Audit Script

An automated script can inspect:

- Files
- lesson-number patterns
- duplicate names
- empty files
- CSV headers
- relative Markdown links
- possible sensitive patterns
- Git status

Automated output should be reviewed manually.

## False Positives

A scan may incorrectly flag:

- Hypothetical phone formats
- example emails
- ordinary long numbers
- educational security terms
- formula values

Every finding should be validated before remediation.

## QA Evidence

Retain:

- Audit output
- issue register
- review checklist
- baseline inventory
- file hashes
- approval record
- release manifest

## Pre-Publication Sequence

1. Freeze substantive edits.
2. Confirm branch and commit.
3. run automated audit.
4. review findings.
5. correct issues.
6. rerun audit.
7. complete content review.
8. complete presentation review.
9. complete privacy review.
10. generate inventory and hashes.
11. approve publication candidate.
12. tag or release intentionally.

## Post-Publication Review

After publication:

- Verify downloadable files
- verify navigation
- verify release notes
- verify hashes
- monitor reported issues
- correct material errors
- preserve prior releases
- update change log

## Automatic Publication Stops

Do not publish when:

- Git working tree contains unexplained changes
- critical or high QA issue remains
- sensitive information may be present
- lesson index is materially incomplete
- internal links are broken
- files are empty or corrupted
- formulas are unreviewed
- legal or tax claims are presented as current without verification
- publication status is unclear
- release files differ from reviewed files

## Beginner Rules

1. Distinguish draft, publication candidate, and published status.
2. Run automated checks but review findings manually.
3. Keep the curriculum index current.
4. Validate relative links.
5. scan for sensitive information.
6. review formulas and examples.
7. preserve a file inventory and hashes.
8. resolve critical and high issues before release.
9. publish only the reviewed commit.
10. record known limitations honestly.

## Knowledge Check

1. Why is file existence insufficient for publication readiness?
2. What is an orphan file?
3. Why must Git history be considered during a privacy incident?
4. What should a curriculum index contain?
5. What is the difference between content and presentation review?
6. Why can automated scans produce false positives?
7. What is a release manifest?
8. Why are file hashes useful?
9. What is the difference between a reviewed draft and publication candidate?
10. What conditions should automatically stop publication?

## Status

- [ ] Read the lesson
- [ ] Run repository audit
- [ ] Review lesson numbering
- [ ] Validate relative links
- [ ] Review CSV headers
- [ ] Review privacy findings
- [ ] Resolve critical and high issues
- [ ] Generate baseline inventory
- [ ] Update curriculum index
- [ ] Complete publication-readiness review
