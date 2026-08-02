# Portfolio Data Quality Review Checklist

## Review

Dataset or report:

Reporting date:

Data cutoff:

Reviewer:

## File Controls

- [ ] Expected file exists
- [ ] file opens correctly
- [ ] encoding correct
- [ ] delimiter correct
- [ ] headers correct
- [ ] no unexpected blank rows
- [ ] checksum recorded

## Schema Controls

- [ ] Required columns present
- [ ] column names unique
- [ ] data types valid
- [ ] required values populated
- [ ] controlled vocabulary valid

## Identifier Controls

- [ ] Accounts mapped
- [ ] tickers mapped
- [ ] ISINs mapped
- [ ] currencies mapped
- [ ] benchmarks mapped
- [ ] corporate-action changes mapped

## Date Controls

- [ ] Dates valid
- [ ] timestamps include timezone where required
- [ ] market holidays reviewed
- [ ] settlement dates valid
- [ ] distribution dates valid
- [ ] no impossible future dates

## Numeric Controls

- [ ] Quantities plausible
- [ ] prices plausible
- [ ] exchange rates plausible
- [ ] percentages use consistent convention
- [ ] currency precision correct
- [ ] no unexplained negative values

## Duplicate Controls

- [ ] Transactions deduplicated
- [ ] distributions deduplicated
- [ ] transfers not counted as income
- [ ] positions not loaded twice
- [ ] unique identifiers checked

## Freshness

- [ ] Prices current
- [ ] holdings current enough
- [ ] expense ratios current
- [ ] benchmark current
- [ ] tax data current
- [ ] stale records flagged

## Reconciliation

Official portfolio total:

Calculated portfolio total:

Difference:

Tolerance:

- [ ] Within tolerance
- [ ] Outside tolerance — stop

## Status

- [ ] Pass
- [ ] Pass with warning
- [ ] Fail
- [ ] Critical fail
- [ ] Manual review required

Exceptions:

Approved by:

Date:
