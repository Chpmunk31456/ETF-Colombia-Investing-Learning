# Lesson 63 — ETF Data Quality, Portfolio Analytics, and Automated Monitoring Controls

## Learning Objective

Learn how to collect, validate, transform, calculate, and monitor ETF and portfolio data without allowing stale prices, inconsistent currencies, missing distributions, broken formulas, duplicate records, or automation failures to produce misleading decisions.

## Important Disclaimer

This lesson is educational.

Market data, fund holdings, prices, distributions, tax information, exchange rates, benchmark values, APIs, file formats, and provider terms can change.

Automated output should support review, not replace human judgment, official records, or qualified professional advice.

## Core Principle

An automated calculation is only as reliable as:

- Its source data
- definitions
- timestamps
- transformations
- formulas
- assumptions
- exception handling
- review process
- audit trail

Automation can reproduce an error faster than a manual process.

## Data Governance

Data governance defines how financial data is:

- Sourced
- approved
- classified
- stored
- transformed
- reviewed
- corrected
- retained
- retired

## Data Owner

The data owner is accountable for deciding:

- What the data represents
- which sources are acceptable
- how it may be used
- who may approve changes

## Data Steward

A data steward maintains:

- Definitions
- quality checks
- metadata
- issue resolution
- documentation
- review schedules

## Data Consumer

A data consumer uses the data for:

- Research
- portfolio monitoring
- reporting
- tax preparation
- investment decisions
- household planning

## Source of Truth

A source of truth is the approved reference for a particular data element.

Examples:

- Broker statement for executed trades
- fund issuer for expense ratio
- index provider for methodology
- official exchange for listing information
- tax authority for filing rules
- approved exchange-rate source for reporting conversion

## Source Hierarchy

A practical source hierarchy may be:

1. Official regulator or government authority
2. official fund issuer
3. official exchange or index provider
4. broker or custodian record
5. audited report
6. reputable data provider
7. secondary research
8. unverified commentary

## Data Element

A data element is one defined field.

Examples:

- Ticker
- ISIN
- NAV
- market price
- expense ratio
- distribution amount
- portfolio weight
- exchange rate
- trade date
- settlement date

## Data Definition

Every material data element should have:

- Name
- definition
- unit
- currency
- source
- update frequency
- owner
- validation rule

## Metadata

Metadata describes the data.

Examples:

- Source
- timestamp
- access date
- reporting currency
- adjustment method
- calculation version
- file name
- checksum

## Data Lineage

Data lineage records how a value moved from:

Source
to transformation
to calculation
to report

## Example Lineage

Official closing price
plus distribution record
converted to total return
converted from USD to COP
aggregated into portfolio return
displayed in monthly dashboard

## Data Provenance

Data provenance records where information originated and how its authenticity was evaluated.

## Data Freshness

Data freshness indicates whether information is current enough for its intended use.

## Freshness Requirement

Different data requires different freshness.

Examples:

- Trade execution price: immediate or same day
- portfolio holdings: latest available reporting date
- expense ratio: current official document
- tax rule: current tax year
- annual report: most recent completed period

## Stale Data

Data is stale when it is older than the approved threshold.

## Stale-Price Risk

A stale price may understate:

- Volatility
- drawdown
- premium or discount
- current exposure
- liquidity risk

## Timestamp

Record timestamps with:

- Date
- time
- timezone
- source
- market status

## Timezone Control

A price timestamp without a timezone may be ambiguous.

Use an explicit format where practical.

## Valuation Date

The valuation date is the date for which assets and liabilities are measured.

## Trade Date

The trade date is when the transaction is executed.

## Settlement Date

The settlement date is when securities and cash are exchanged.

## Record Date

A record date determines eligibility for a distribution or corporate action.

## Ex-Date

The ex-date is the date a security begins trading without entitlement to the upcoming distribution under applicable rules.

## Payment Date

The payment date is when the distribution is paid.

## Date Alignment

Do not combine data series without aligning:

- Trading dates
- holidays
- timezones
- valuation times
- missing observations

## Missing Data

Missing data may result from:

- Market holiday
- provider outage
- delisting
- stale feed
- failed import
- unavailable history
- symbol change

## Missing-Data Treatment

Possible methods include:

- Leave blank
- carry forward
- interpolate
- exclude
- use a proxy
- obtain another source

Every method should be documented.

## Carry-Forward Risk

Carrying forward a prior value may suppress measured volatility.

## Interpolation Risk

Interpolating prices can create artificial values that never traded.

## Proxy Data

Proxy data may be used only when:

- The original data is unavailable
- the proxy relationship is reasonable
- limitations are disclosed
- the proxy is separately identified

## Duplicate Record

A duplicate record repeats the same event or observation.

Examples:

- Same trade imported twice
- same distribution recorded twice
- same transfer counted as income and internal movement
- same position loaded from two account files

## Duplicate-Control Key

A duplicate-control key may combine:

- Account
- transaction date
- security identifier
- quantity
- amount
- currency
- reference number

## Unique Identifier

Use stable identifiers such as:

- ISIN
- broker transaction ID
- account ID
- internal record ID
- document ID

Ticker alone may not be stable.

## Symbol Change

A ticker may change after:

- Merger
- rebranding
- exchange change
- corporate action
- share-class change

Maintain identifier history.

## Security Master

A security master is an approved register of securities and identifiers.

It may contain:

- Fund name
- ticker
- ISIN
- share class
- domicile
- currency
- exchange
- benchmark
- status

## Account Master

An account master identifies:

- Institution
- legal owner
- account type
- reporting currency
- tax jurisdiction
- status

## Currency Master

A currency master defines:

- Currency code
- name
- decimal precision
- approved rate source
- rate convention

## ISO Currency Code

Use standard three-letter currency codes where applicable.

Examples:

- COP
- USD
- EUR

## Unit Consistency

Do not mix:

- Percentages and decimals
- dollars and cents
- COP and thousands of COP
- shares and currency values
- daily and annual rates

## Percentage Convention

Document whether 5% is stored as:

- 5
- 0.05

## Rounding

Rounding should occur at the presentation stage where practical.

Premature rounding can create reconciliation differences.

## Decimal Precision

Define precision for:

- Shares
- prices
- exchange rates
- percentages
- tax calculations
- currency totals

## Currency Conversion

Every conversion should record:

- Source currency
- destination currency
- rate
- rate direction
- rate date
- source
- method

## Exchange-Rate Direction

Confirm whether a rate means:

- COP per USD
- USD per COP

## Double Conversion Risk

Do not convert a value twice.

## Currency Aggregation

A consolidated portfolio value requires a common reporting currency.

## Distribution Adjustment

Price history should not be treated as total-return history unless distributions are incorporated correctly.

## Split Adjustment

Historical share prices and quantities may require adjustment for:

- Stock split
- reverse split
- share conversion
- corporate action

## Corporate-Action Adjustment

Update:

- Security identifier
- quantity
- cost basis
- historical continuity
- performance series

## Survivorship Bias

A current fund list may omit funds that closed or merged.

## Look-Ahead Bias

A historical calculation must not use information that became available later.

## Restatement

A provider may correct previously published data.

Record:

- Original value
- corrected value
- reason
- correction date
- affected reports

## Version Control

Calculations, data dictionaries, and scripts should be version controlled.

Private financial data should not be committed to public Git.

## Calculation Version

Every material calculation should identify:

- Formula version
- script version
- assumptions version
- data cutoff

## Formula Governance

A formula should have:

- Name
- purpose
- definition
- inputs
- output
- unit
- owner
- validation example
- approval status

## Reproducibility

A calculation is reproducible when another reviewer can obtain the same result using the same:

- Inputs
- formulas
- assumptions
- software version
- date range

## Independent Verification

Important calculations should be checked using:

- Second formula
- second tool
- manual sample
- external benchmark
- another reviewer

## Reasonableness Check

A reasonableness check asks whether the result is plausible.

Examples:

- Portfolio weight totals approximately 100%
- return is consistent with beginning and ending value
- cash cannot be negative without borrowing
- quantity matches trade history
- distribution is not larger than the entire position without explanation

## Control Total

A control total is an independent total used for reconciliation.

Examples:

- Broker account value
- total shares
- total cash
- total portfolio allocation
- total transaction amount

## Cross-Footing

Cross-footing checks whether:

- Row totals
- column totals
- summary totals

agree.

## Allocation Total

Portfolio target weights should equal 100%, subject to documented rounding.

## Reconciliation Difference

Reconciliation difference equals:

Calculated amount
minus
official reference amount

## Tolerance

A tolerance defines an acceptable difference.

Tolerance may be:

- Absolute amount
- percentage
- basis points
- number of shares

## Materiality

A difference may be material because of:

- Size
- risk
- tax
- recurring pattern
- affected account
- decision impact

## Exception

An exception is a failed control or unresolved variance.

## Exception Severity

Use:

- Informational
- low
- moderate
- high
- critical

## Critical Exception

Examples include:

- Missing account
- wrong security
- duplicate trade
- unexplained cash movement
- unverified beneficiary
- stale price used for transaction
- incorrect currency conversion
- portfolio total materially wrong

## Exception Owner

Every exception should have:

- Owner
- due date
- status
- evidence
- resolution

## Issue Aging

Issue aging measures how long an exception remains open.

## Root Cause

Possible root causes include:

- Source error
- mapping error
- formula error
- manual entry
- timestamp mismatch
- duplicate import
- corporate action
- system outage
- process failure

## Corrective Action

Corrective action resolves the current issue.

## Preventive Action

Preventive action reduces recurrence.

## Automated Monitoring

Automated monitoring may check:

- Missing files
- missing columns
- duplicate rows
- invalid dates
- stale observations
- allocation totals
- negative quantities
- unknown currencies
- unmapped tickers
- out-of-range values
- broken links

## Scheduled Monitoring

Monitoring may run:

- On file change
- daily
- weekly
- monthly
- before release
- after data import

## Automation Failure

An automation can fail because of:

- Source outage
- authentication expiration
- changed file format
- changed column name
- API limit
- network failure
- script defect
- dependency update
- permission change

## Silent Failure

A silent failure occurs when automation stops or produces incomplete output without a visible alert.

## Fail-Closed Principle

For material decisions, automation should not silently substitute questionable data.

A failed critical control should stop publication or approval.

## Fail-Open Risk

Fail-open behavior continues despite missing or invalid data.

This may be acceptable only for noncritical informational output with clear warning.

## Monitoring Heartbeat

A heartbeat confirms that a scheduled control ran.

Record:

- Run time
- result
- input date
- row count
- exception count
- output location

## Row-Count Control

Unexpected changes in row count may indicate:

- Missing data
- duplicate import
- source change
- filtering error

## Schema Validation

Schema validation confirms:

- Required columns exist
- data types are appropriate
- column names match
- required fields are populated

## Range Validation

Range validation checks whether values fall within plausible boundaries.

Examples:

- Portfolio weight between 0% and 100%
- expense ratio nonnegative
- quantity not negative unless shorting is permitted
- date not in impossible format

## Referential Integrity

Referential integrity checks whether related identifiers exist.

Examples:

- Every holding references a valid security
- every transaction references a valid account
- every distribution references a known fund

## Data-Type Validation

Examples:

- Date field contains valid date
- quantity contains number
- currency contains approved code
- boolean contains accepted value

## File Integrity

File integrity checks may include:

- File exists
- file opens
- expected encoding
- valid CSV format
- checksum
- no unexpected binary content

## Encoding

Use consistent text encoding, such as UTF-8.

## Delimiter Control

CSV files may use:

- Comma
- semicolon
- tab

The expected delimiter should be documented.

## Header Control

CSV headers should be stable and unique.

## Blank-Row Control

Blank rows may affect:

- Imports
- counts
- scripts
- formulas

## Whitespace Control

Leading or trailing whitespace can cause identifier mismatches.

## Case Normalization

Identifiers may be normalized where appropriate.

Do not alter case when the source system treats it as meaningful.

## Input Validation

Manual input forms should restrict:

- Required fields
- approved categories
- date format
- currency
- numeric range

## Free-Text Risk

Free-text fields are useful for explanation but difficult to validate consistently.

## Controlled Vocabulary

Use approved values for fields such as:

- Status
- severity
- asset class
- currency
- review result
- decision

## Data Dictionary

A data dictionary should document each field used in registers and reports.

## Analytics Layer

The analytics layer transforms validated data into:

- Returns
- exposures
- risk metrics
- cash flow
- dashboards
- exception reports

## Presentation Layer

The presentation layer displays results.

It should not silently alter the underlying calculations.

## Dashboard

A dashboard should highlight:

- Portfolio value
- allocation
- drift
- cash
- risk
- exceptions
- stale data
- upcoming reviews

## Dashboard Limitation

A dashboard is a summary, not the evidence itself.

## Green-Yellow-Red Status

Status colors should be based on documented thresholds.

## Threshold Governance

Thresholds should have:

- Definition
- rationale
- owner
- effective date
- approval
- review date

## Alert

An alert should identify:

- Condition
- affected record
- severity
- evidence
- required action
- owner
- due date

## Alert Fatigue

Too many low-value alerts can cause important alerts to be ignored.

## Alert Prioritization

Prioritize alerts based on:

- Financial impact
- control failure
- deadline
- fraud risk
- essential-liquidity impact
- data uncertainty

## False Positive

A false positive flags a problem that is not real.

## False Negative

A false negative fails to identify a real problem.

False negatives can be more dangerous for critical controls.

## Override

An override permits a controlled exception.

Every override should record:

- Rule
- reason
- approver
- expiration
- compensating control

## Manual Adjustment

A manual adjustment should never overwrite source data without preserving:

- Original value
- adjusted value
- reason
- reviewer
- date

## Audit Trail

An audit trail records:

- Who
- changed what
- when
- why
- based on which evidence

## Change Log

A change log should document modifications to:

- Formula
- script
- threshold
- schema
- source
- report
- data definition

## Test Environment

Changes should be tested before use in a production decision process.

## Test Data

Test data should include:

- Normal cases
- missing values
- duplicate records
- invalid dates
- extreme values
- corporate actions
- currency changes
- closed funds

## Unit Test

A unit test verifies one calculation or function.

## Integration Test

An integration test verifies that multiple components work together.

## Regression Test

A regression test checks that a change did not break previously correct behavior.

## User-Acceptance Test

A user-acceptance test confirms that the process meets the intended business or household need.

## Known-Answer Test

A known-answer test uses a small example with a manually verified result.

## Data Snapshot

A data snapshot preserves the input used for a specific report.

## Report Reproduction

A report should be reproducible from:

- Data snapshot
- script version
- configuration
- assumptions
- calculation date

## Portfolio Analytics

Portfolio analytics may include:

- Market value
- allocation
- return
- drawdown
- volatility
- income
- tax
- currency exposure
- concentration
- benchmark comparison

## Position Market Value

Position market value equals:

Quantity
multiplied by
market price

with currency conversion where required.

## Portfolio Weight

Portfolio weight equals:

Position market value
divided by
total portfolio market value

## Contribution to Return

A simplified contribution to return may be approximated as:

Beginning portfolio weight
multiplied by
asset return

More precise attribution may require cash-flow and timing adjustments.

## Contribution to Risk

Risk contribution depends on:

- Weight
- volatility
- covariance

It is not equal to capital weight.

## Cash-Flow Treatment

External cash flows include:

- Contribution
- withdrawal

Internal activity includes:

- Security purchase
- security sale
- transfer between owned accounts

## Double-Counting Prevention

Do not count:

- Sale proceeds as income
- internal transfer as contribution
- distribution and total-return adjustment twice
- fund and underlying holdings as separate portfolio value

## Time-Weighted Return

Time-weighted return reduces the effect of external cash-flow timing.

## Money-Weighted Return

Money-weighted return reflects the timing and size of investor cash flows.

## Return-Method Selection

Use the method appropriate to the question.

Time-weighted return may assess investment performance.

Money-weighted return may assess the investor’s actual experience.

## Benchmark Alignment

Benchmark comparison requires consistent:

- Date range
- currency
- return type
- valuation timing
- distribution treatment

## Performance Attribution

Attribution may separate:

- Asset allocation
- security selection
- currency
- fees
- tax
- cash
- interaction

## Attribution Limitation

Detailed attribution can create false precision when source data is incomplete.

## Data Confidence

Every report should state confidence:

- High
- moderate
- low
- unknown

## High Confidence

High confidence requires:

- Approved sources
- complete records
- current data
- successful controls
- reconciled totals

## Low Confidence

Low confidence may result from:

- Proxy data
- stale prices
- missing distributions
- unresolved corporate action
- incomplete tax lots
- failed control

## Reporting Status

### Green

- Data current
- reconciliations pass
- no critical exception
- calculations verified
- report reproducible

### Yellow

- Minor missing data
- stale noncritical field
- unresolved moderate exception
- manual adjustment
- reduced confidence

### Red

- Portfolio total does not reconcile
- critical source unavailable
- duplicate trades
- unknown security
- stale execution data
- currency conversion failure
- report cannot be reproduced

## Publication Gate

A report should not be presented as final when:

- Critical validation failed
- source date is unknown
- formula changed without test
- data snapshot is missing
- reconciliation is outside tolerance
- manual override is undocumented

## Privacy and Security

Private analytics data may contain:

- Account identifiers
- balances
- holdings
- tax data
- transaction history
- beneficiaries
- personal goals

Do not store completed private records in public Git.

## Access Control

Limit private financial data to authorized users.

## Least Privilege

Users and scripts should receive only the access needed.

## Credential Management

Do not place:

- Passwords
- API keys
- tokens
- private certificates
- recovery codes

in scripts or public repositories.

## Environment Variable

Sensitive configuration may be stored in protected environment variables or approved secret-management systems.

## Log Privacy

Logs should not expose:

- Account numbers
- full transaction descriptions
- tokens
- personal identifiers
- beneficiary data

## Backup

Back up:

- Data dictionaries
- approved scripts
- configuration
- report snapshots
- issue registers
- private evidence

## Restore Test

A backup is not reliable until restoration is tested.

## Retention

Define retention for:

- Raw data
- reports
- logs
- tax records
- corporate actions
- issue evidence
- calculations

## Data Disposal

Dispose of expired private data securely.

## Provider Dependency

A monitoring system may depend on:

- One market-data provider
- one exchange-rate source
- one broker export
- one software library

## Backup Source

Critical data should have an approved backup source where practical.

## Source Conflict

When two sources conflict:

1. Stop affected calculation.
2. identify definitions and timestamps.
3. determine source hierarchy.
4. preserve both values.
5. document resolution.
6. rerun affected reports.

## Provider Methodology Change

A provider may change:

- Field definitions
- adjustment method
- API
- ticker mapping
- history
- frequency

## Dependency Update

A software update may change output.

Test dependency updates before accepting new results.

## Monitoring Calendar

### Daily or event driven

Review:

- Failed data import
- critical alerts
- missing prices
- account discrepancy
- corporate action

### Monthly

Review:

- Portfolio reconciliation
- allocation
- stale records
- exceptions
- report archive

### Quarterly

Review:

- Source quality
- threshold performance
- false alerts
- methodology
- backup source

### Annually

Review:

- Data dictionary
- source hierarchy
- scripts
- controls
- access
- retention
- restore testing

## Automatic Stop Conditions

Do not rely on an automated report when:

- Portfolio totals do not reconcile
- data source is unknown
- timestamp is missing
- required fields are absent
- duplicate transactions exist
- fund identifier cannot be mapped
- currency rate direction is unclear
- total-return and price-return data are mixed
- formula version is unknown
- critical control failed
- manual adjustment is undocumented
- report cannot be reproduced
- private credentials appear in code or output

## Beginner Rules

1. Define every important field.
2. use official sources where possible.
3. record timestamps, currencies, and units.
4. reconcile analytics with broker statements.
5. preserve source data and calculation versions.
6. test formulas using known answers.
7. treat stale or missing data as an exception.
8. do not allow silent automation failure.
9. separate private data from public code.
10. stop when results cannot be reproduced or explained.

## Knowledge Check

1. What is data lineage?
2. Why can stale prices understate risk?
3. What is the difference between a source of truth and a secondary source?
4. Why should percentages have a documented storage convention?
5. What is a control total?
6. How does a silent automation failure create risk?
7. Why should manual adjustments preserve original values?
8. What is the difference between time-weighted and money-weighted return?
9. Why should reports contain a confidence rating?
10. What conditions should stop publication of an automated portfolio report?

## Status

- [ ] Read the lesson
- [ ] Create security master
- [ ] create data dictionary
- [ ] define source hierarchy
- [ ] define freshness thresholds
- [ ] define reconciliation controls
- [ ] define calculation versions
- [ ] create known-answer tests
- [ ] create automated QA controls
- [ ] create exception process
- [ ] create monitoring dashboard specification
- [ ] create backup and restore test
- [ ] schedule annual analytics governance review
