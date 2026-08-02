# Lesson 27 — Data Privacy, Secure Recordkeeping, Backup, and Recovery

## Learning Objective

Learn how to separate public educational materials from confidential financial records, protect sensitive information, maintain reliable backups, and recover essential documents after device loss, theft, ransomware, accidental deletion, or incapacity.

## Core Principle

This repository should contain:

- Educational lessons
- Blank templates
- Empty worksheets
- Redacted examples
- Public official-source references
- General decision frameworks

It should not contain confidential personal records.

## Sensitive Information

Examples of sensitive information include:

- Passwords
- MFA codes
- Recovery codes
- Private keys
- Cryptocurrency seed phrases
- Full account numbers
- Full credit-card numbers
- Bank-routing information
- Brokerage credentials
- Tax returns
- Bank statements
- Pension statements
- Full identification numbers
- Passport copies
- Cédula copies
- Medical records
- Signatures
- Tenant identification documents
- Property contracts containing personal data
- Unredacted legal documents
- Private addresses
- Beneficiary personal information

## Public Repository Risk

A repository may become public through:

- Accidental GitHub publication
- Incorrect repository visibility
- Forking
- Backup synchronization
- Shared computer access
- Uploaded archives
- Support requests
- Committed files remaining in Git history

Deleting a file from the latest version does not necessarily remove it from prior Git history.

## Repository Classification

Classify information before saving it.

### Public

Suitable for publication.

Examples:

- Lessons
- Blank checklists
- General explanations
- Public official links
- Empty CSV templates

### Internal

Not intended for public release but not highly sensitive.

Examples:

- Personal learning notes
- Hypothetical examples
- General questions for professionals
- Redacted comparisons

### Confidential

Requires controlled storage.

Examples:

- Account balances
- Real portfolio holdings
- Tax calculations
- Property offers
- Personal cash flow
- Broker account identifiers
- Legal correspondence

### Highly Restricted

Requires strong encryption and minimal access.

Examples:

- Passwords
- Recovery phrases
- Full identification documents
- Private keys
- Tax returns
- Medical records
- Unredacted beneficiary information

## Storage Separation

Use at least two separate locations.

### Learning repository

Store:

- Lessons
- Blank templates
- Redacted examples
- General research notes

### Secure private vault

Store:

- Completed personal worksheets
- Account statements
- Legal documents
- Tax records
- Property records
- Identity documents
- Beneficiary records
- Financial statements

The private vault should not be inside the Git repository.

## Suggested Local Folder Structure

Example:

Secure-Financial-Records
├── 01-identity
├── 02-bank-and-brokerage
├── 03-tax-us
├── 04-tax-colombia
├── 05-property
├── 06-insurance
├── 07-estate-and-beneficiaries
├── 08-professional-advice
├── 09-emergency-access
└── 10-archive

This structure is illustrative.

## File-Naming Standard

Use consistent names.

Example:

YYYY-MM-DD_Institution_Document-Type_Description

Examples:

- 2026-07-31_Bank_Monthly-Statement_Redacted.pdf
- 2026-07-31_Broker_Trade-Confirmation.pdf
- 2026-01-01_Property_Tax-Certificate.pdf
- 2026-04-15_US_Tax-Return.pdf

Avoid names containing:

- Passwords
- Full account numbers
- Full identification numbers
- Unnecessary medical details

## Redaction

Before adding an example to the repository, remove:

- Full name where unnecessary
- Signature
- Identification number
- Account number
- Address
- Telephone number
- Email
- QR code
- Barcode
- Tax identifier
- Transaction reference
- Exact balance when unnecessary
- Metadata containing private information

Visual redaction should permanently remove the underlying content rather than merely placing a black shape over it.

## Git Ignore Controls

A `.gitignore` file can reduce accidental commits.

It does not protect files that were already committed.

Recommended exclusions include:

- Private folders
- Statements
- Tax files
- Identity documents
- Environment files
- Secrets
- Temporary exports
- Backup archives
- Password-manager exports

## Secret Scanning

Before committing, scan for:

- API keys
- Tokens
- Passwords
- Private keys
- Connection strings
- Account identifiers
- Accidental identity documents

Available local tools may include:

- gitleaks
- detect-secrets
- trivy secret scanning
- GitHub secret scanning where available

Secret scanning does not replace manual review.

## Metadata Risk

Files may contain hidden metadata such as:

- Author name
- Company
- Editing history
- GPS location
- Device information
- Creation time
- Comments
- Tracked changes
- Hidden worksheets
- Embedded attachments

Review metadata before sharing files.

## Spreadsheet Risks

Before sharing a spreadsheet, check:

- Hidden rows
- Hidden columns
- Hidden worksheets
- Comments
- Notes
- Formulas referencing private files
- External links
- Named ranges
- Cached values
- Document properties
- Full account identifiers

## Document Risks

Before sharing a document, check:

- Track Changes
- Comments
- Headers
- Footers
- Embedded files
- Author information
- Prior revisions
- Hidden text
- Document properties

## Image Risks

Images may expose:

- Faces
- Identification cards
- Addresses
- Reflections
- Computer screens
- QR codes
- Barcodes
- GPS metadata
- Documents in the background

Review the entire image before sharing.

## Password Management

Use a reputable password manager for:

- Unique passwords
- Secure notes
- Recovery codes
- Emergency-access instructions
- Account URLs

Do not reuse the same password across:

- Email
- Banking
- Brokerage
- Government portals
- Cloud storage
- GitHub

## Multi-Factor Authentication

Prefer stronger methods where supported:

1. Hardware security key
2. Authenticator application
3. Passkey
4. SMS as a weaker fallback

Store recovery codes securely and separately from the primary device.

## Email Security

Email often controls account recovery.

Protect the primary email account with:

- Unique password
- Strong MFA
- Recovery email review
- Recovery telephone review
- Login alerts
- Device review
- Forwarding-rule review
- Suspicious-session review

A compromised email account can lead to compromise of financial accounts.

## Device Security

Protect computers and phones with:

- Full-disk encryption
- Strong login credential
- Automatic screen lock
- Operating-system updates
- Antivirus or endpoint protection
- Secure browser
- Device-location capability
- Remote wipe where supported
- Separate user accounts
- Limited administrator use

## Backup Principle

A backup should survive loss of the original device.

A robust approach uses the 3-2-1 concept:

- Three copies of important data
- Two different storage types
- One copy stored separately

## Backup Categories

### Working copy

The active files used regularly.

### Local backup

An external drive or separate local device.

### Off-site or encrypted cloud backup

A geographically separate copy protected with strong access controls.

## Backup Frequency

Possible schedule:

- Critical records: immediately after creation
- Financial statements: monthly
- Tax records: after filing
- Property records: after every transaction
- Legal documents: after every revision
- Full encrypted archive: quarterly
- Recovery test: at least annually

## Encrypted Backup

An encrypted backup should protect data:

- At rest
- During transfer
- From unauthorized account access
- If the storage device is lost

Keep encryption recovery information separate from the backup media.

## External Drive Controls

For an external backup drive:

- Encrypt the drive
- Label it without exposing sensitive contents
- Disconnect it after backup
- Store it securely
- Test it periodically
- Replace failing media
- Do not leave it continuously connected

A continuously connected backup may also be encrypted by ransomware.

## Cloud Storage Controls

Before storing confidential records in cloud storage, review:

- Encryption
- MFA
- Sharing permissions
- Recovery options
- Version history
- Deleted-file recovery
- Geographic storage
- Provider access
- Account inheritance or emergency access
- Export capability

## Backup Verification

A backup is not reliable until it has been tested.

Verify:

- Files can be opened
- Password or encryption key works
- Folder structure is intact
- Recent files are present
- File sizes are reasonable
- Checksums or integrity checks match where used
- Recovery instructions are understandable

## Recovery Test

At least annually:

1. Select several representative files.
2. Restore them to a temporary folder.
3. Open each file.
4. Confirm content and dates.
5. Confirm encrypted access works.
6. Record the test.
7. Correct any failures.
8. Delete the temporary restored copies securely.

## Ransomware Preparation

Reduce ransomware risk through:

- Offline backup
- Updated software
- Limited administrator privileges
- Email caution
- Attachment scanning
- Strong MFA
- Endpoint protection
- Network segmentation where practical
- Recovery testing

Do not rely on paying a ransom as a recovery strategy.

## Lost or Stolen Device Procedure

When a device is lost:

1. Use device-location tools.
2. Lock or wipe the device where supported.
3. Change the primary email password.
4. Revoke active sessions.
5. Review banking and brokerage access.
6. Revoke exposed API keys.
7. Notify institutions where necessary.
8. Review recent account activity.
9. Document the incident.
10. Restore data only to a trusted device.

## Accidental Disclosure Procedure

If confidential information is committed or shared:

1. Stop further sharing.
2. Identify exactly what was exposed.
3. Remove public access.
4. Revoke affected credentials.
5. Change passwords.
6. Notify institutions where required.
7. Remove the information from Git history where appropriate.
8. Preserve incident evidence.
9. Review logs.
10. Document corrective actions.

Assume a published secret has been compromised even if the file was removed quickly.

## Git History Risk

Confidential information may remain in:

- Earlier commits
- Branches
- Tags
- Pull requests
- Forks
- Clones
- Cached search results
- Build artifacts

Credential rotation is usually more important than deletion alone.

## Personal Record Retention

Create retention categories.

### Permanent or long-term

Examples:

- Property deeds
- Acquisition records
- Major improvement invoices
- Estate documents
- Final tax returns
- Legal judgments
- Beneficiary documents

### Tax retention

Retain according to professional guidance for:

- Returns
- Supporting schedules
- Income statements
- Foreign-account records
- Cost basis
- Withholding
- Currency conversion
- Property sale records

### Operational retention

Examples:

- Monthly statements
- Trade confirmations
- Rental ledgers
- Contractor records
- Insurance documents
- Loan statements

## Secure Disposal

When records are no longer required:

- Shred paper
- Securely delete files
- Empty deleted-file recovery locations
- Destroy failed storage media
- Remove cloud copies
- Remove shared links
- Confirm backup copies are handled consistently

Ordinary deletion may not securely erase data.

## Family and Emergency Access

A secure plan should allow a trusted person to locate essential records during:

- Hospitalization
- Incapacity
- Death
- Travel emergency
- Device loss

Document:

- Where records are stored
- Who can access them
- How access is authorized
- Which professional should be contacted
- Where recovery information is kept

Do not place full credentials in the public learning repository.

## Repository Review Before Commit

Before each commit:

- Check `git status`
- Review every staged file
- Review the staged diff
- Run secret scanning
- Confirm no personal documents are included
- Confirm no full account identifiers appear
- Confirm examples are redacted
- Confirm generated files are intentional
- Confirm temporary exports are excluded

## Repository Review Before Publication

Before making the repository public:

1. Review all tracked files.
2. Review full Git history.
3. Run multiple secret scanners.
4. Search for names and identification numbers.
5. Search for email addresses.
6. Search for account-number patterns.
7. Search for private keys and tokens.
8. Review images and PDFs manually.
9. Review metadata.
10. Confirm all examples are synthetic or redacted.

## Data Inventory

Maintain:

| Data Category | Classification | Storage Location | Encrypted | Backup | Access |
|---|---|---|---|---|---|
| Learning lessons | Public | Git repository | Optional | Yes | Owner |
| Blank templates | Public | Git repository | Optional | Yes | Owner |
| Completed worksheets | Confidential | Private vault | Yes | Restricted |
| Tax records | Highly Restricted | Private vault | Yes | Restricted |
| Identity records | Highly Restricted | Private vault | Yes | Restricted |
| Property documents | Confidential | Private vault | Yes | Restricted |
| Passwords | Highly Restricted | Password manager | Yes | Restricted |

## Incident Log

Record:

- Date
- Incident
- Data involved
- Accounts affected
- Actions taken
- Institutions notified
- Credentials changed
- Recovery completed
- Lessons learned
- Final status

## Stop Conditions

Do not commit or share when:

- File classification is unclear
- Redaction is incomplete
- Document contains tracked changes
- Spreadsheet contains hidden personal data
- Image contains identity or location information
- Secret scanner reports an unresolved finding
- Account numbers are visible
- Tax or legal records are unredacted
- Encryption is unavailable for confidential storage
- Backup has never been tested

## Beginner Rules

1. Keep completed personal worksheets outside Git.
2. Treat all committed history as potentially permanent.
3. Use strong unique passwords and MFA.
4. Encrypt confidential records.
5. Maintain more than one backup.
6. Keep one backup separate from the primary device.
7. Test recovery annually.
8. Revoke exposed credentials immediately.
9. Review staged files before every commit.
10. Never publish sensitive records for convenience.

## Knowledge Check

1. Why is deleting a file from the latest Git commit insufficient?
2. What is the difference between public and confidential information?
3. Why should completed worksheets remain outside the repository?
4. What is the 3-2-1 backup concept?
5. Why should a backup be disconnected?
6. Why must recovery be tested?
7. What metadata risks exist in documents and images?
8. What should happen after a credential is exposed?
9. Why is email security important for financial accounts?
10. What should be checked before publishing a repository?

## Status

- [ ] Read the lesson
- [ ] Classify repository information
- [ ] Create secure private-vault location
- [ ] Review password-manager security
- [ ] Enable strong MFA
- [ ] Create encrypted backup
- [ ] Complete recovery test
- [ ] Review repository history
- [ ] Run secret scanning
- [ ] Document emergency access
