# Secure Repository Pre-Commit Checklist

## File Review

- [ ] `git status` reviewed
- [ ] Every staged file expected
- [ ] Staged diff reviewed
- [ ] No temporary exports included
- [ ] No backup archives included
- [ ] No completed personal worksheets included
- [ ] No confidential source documents included

## Sensitive Data

- [ ] No passwords
- [ ] No API keys
- [ ] No MFA codes
- [ ] No recovery phrases
- [ ] No private keys
- [ ] No full account numbers
- [ ] No full identification numbers
- [ ] No tax returns
- [ ] No bank statements
- [ ] No tenant identity documents
- [ ] No signatures
- [ ] No unredacted legal documents

## Metadata and Hidden Content

- [ ] Document metadata reviewed
- [ ] Track Changes removed
- [ ] Comments removed
- [ ] Hidden text reviewed
- [ ] Spreadsheet hidden rows reviewed
- [ ] Spreadsheet hidden columns reviewed
- [ ] Hidden worksheets reviewed
- [ ] External links reviewed
- [ ] Image metadata reviewed
- [ ] Background details reviewed

## Security Scanning

- [ ] Gitleaks scan completed
- [ ] Detect-secrets scan completed
- [ ] Other available secret scan completed
- [ ] Findings reviewed
- [ ] False positives documented
- [ ] Material findings resolved

## Publication Readiness

- [ ] Content classification confirmed
- [ ] Examples are synthetic or permanently redacted
- [ ] Personal details removed
- [ ] Repository visibility confirmed
- [ ] Commit message describes the change
- [ ] Backup completed before major change

## Approval

Reviewer:

Date:

Decision:

- [ ] Approved to commit
- [ ] Return for correction
- [ ] Do not commit
