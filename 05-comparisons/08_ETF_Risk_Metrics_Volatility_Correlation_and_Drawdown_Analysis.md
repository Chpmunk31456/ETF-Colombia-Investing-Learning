# Lesson 59 — ETF Risk Metrics, Volatility, Correlation, Drawdown, and Scenario Analysis

## Learning Objective

Learn how to evaluate ETF risk using volatility, downside deviation, drawdown, recovery time, correlation, beta, tracking behavior, concentration, liquidity, currency exposure, and scenario analysis.

## Important Disclaimer

This lesson is educational.

Historical risk measurements do not predict future returns or losses.

Results depend on:

- Data source
- measurement period
- return frequency
- currency
- distribution treatment
- benchmark
- missing data
- market conditions
- calculation method

Use current verified data and qualified professional advice for material investment decisions.

## Core Principle

Return cannot be evaluated responsibly without risk.

Two ETFs with similar returns may expose the investor to very different:

- Volatility
- drawdowns
- concentration
- liquidity
- currency movement
- recovery periods
- downside outcomes
- behavioral pressure

## Risk Is Multi-Dimensional

ETF risk may include:

- Market risk
- volatility risk
- drawdown risk
- concentration risk
- liquidity risk
- tracking risk
- currency risk
- interest-rate risk
- credit risk
- inflation risk
- counterparty risk
- tax risk
- operational risk
- behavioral risk

No single metric captures every risk.

## Measurement Period

Every calculation should identify:

- Start date
- end date
- data frequency
- return type
- currency
- benchmark
- whether distributions are included

Changing the period can materially change the conclusion.

## Price Return

Price return measures only the change in market price.

## Total Return

Total return includes:

- Price change
- distributions
- reinvestment assumptions

Use total return when evaluating investment performance unless a different measure is explicitly required.

## Return Formula

Simple periodic return equals:

Ending value
minus beginning value
plus applicable cash distribution

divided by beginning value

## Example

Beginning value:

USD 100

Ending value:

USD 104

Distribution:

USD 2

Total return:

(104 - 100 + 2) ÷ 100

Result:

6%

## Logarithmic Return

Logarithmic return may be calculated as:

Natural logarithm of:

Ending value
divided by beginning value

Log returns can be useful in statistical analysis but should not be mixed with simple returns without explanation.

## Arithmetic Average Return

Arithmetic average return equals:

Sum of periodic returns
divided by number of periods

## Geometric Average Return

Geometric average return reflects compounded growth.

For multiple periods:

Multiply each:

1 + periodic return

Then take the appropriate root and subtract 1.

## Why the Difference Matters

Arithmetic average may overstate actual compounded growth when returns vary.

## Annualized Return

Annualized return converts a multi-period return into an equivalent yearly compound rate.

For a holding period measured in years:

Annualized return equals:

(Ending value ÷ beginning value) raised to:

1 ÷ years

minus 1

Adjust for contributions, withdrawals, and distributions where applicable.

## Volatility

Volatility generally measures the dispersion of returns around their average.

Historical volatility is commonly estimated using standard deviation.

## Standard Deviation

A higher standard deviation generally indicates that periodic returns varied more widely.

Standard deviation does not distinguish between:

- Positive variation
- negative variation

## Sample Standard Deviation

When historical returns are treated as a sample, use the sample standard-deviation formula and document the method.

## Annualized Volatility

Annualized volatility may be estimated from periodic volatility.

For monthly data:

Monthly standard deviation
multiplied by square root of 12

For daily data:

Daily standard deviation
multiplied by square root of the assumed annual trading days

The scaling assumption should be documented.

## Volatility Limitation

Volatility may understate risk when:

- Returns are not normally distributed
- markets gap
- prices are stale
- liquidity disappears
- losses are asymmetric
- data history is short
- structural conditions changed

## Downside Deviation

Downside deviation measures returns falling below a selected threshold.

The threshold may be:

- Zero
- inflation
- required return
- risk-free rate
- financial-goal return

## Downside Risk

Downside risk focuses on harmful outcomes rather than all variation.

## Semivariance

Semivariance measures dispersion of observations below a selected average or threshold.

## Maximum Drawdown

Maximum drawdown is the largest peak-to-trough decline during the measurement period.

## Drawdown Formula

Drawdown equals:

Current value
minus prior peak value

divided by prior peak value

## Example

Prior peak:

USD 100

Trough:

USD 70

Drawdown:

(70 - 100) ÷ 100

Result:

-30%

## Drawdown Period

The drawdown period begins after the prior peak and continues until:

- Recovery to the prior peak
- end of available data

## Recovery Time

Recovery time measures how long the investment takes to regain the previous peak.

## Underwater Period

An underwater period is the time an investment remains below its previous peak.

## Drawdown Depth Versus Duration

Review both:

- How far the investment fell
- how long it remained below the peak

A smaller but prolonged drawdown may be difficult for an investor with a near-term goal.

## Drawdown Frequency

Review:

- Number of drawdowns
- number exceeding 5%
- number exceeding 10%
- number exceeding 20%
- average duration
- maximum duration

Thresholds should match the asset class and purpose.

## Ulcer Index

The Ulcer Index measures the depth and duration of drawdowns.

It focuses on downside discomfort rather than all volatility.

## Value at Risk

Value at Risk, or VaR, estimates a loss threshold over a defined period and confidence level.

Example interpretation:

- Under the selected model, losses are estimated not to exceed a specified amount on a stated percentage of periods.

## Value-at-Risk Limitation

VaR does not reveal how severe losses may be beyond the threshold.

It can be highly sensitive to:

- Model
- history
- distribution assumption
- volatility
- correlation
- confidence level
- holding period

## Expected Shortfall

Expected shortfall estimates the average loss beyond a selected VaR threshold.

It is also called conditional Value at Risk in some contexts.

## Tail Risk

Tail risk refers to rare but severe outcomes.

Historical samples may contain too few tail events to estimate this risk reliably.

## Skewness

Skewness measures return-distribution asymmetry.

Negative skew may indicate more severe or frequent downside outliers.

## Kurtosis

Kurtosis measures aspects of tail heaviness relative to a normal distribution.

Higher tail risk may make standard volatility assumptions less reliable.

## Best Period

Best-period return identifies the strongest return during a specified interval.

## Worst Period

Worst-period return identifies the weakest return during a specified interval.

Always state the interval:

- Day
- month
- quarter
- year
- rolling period

## Rolling Return

A rolling return measures performance over repeated overlapping periods.

Examples:

- Rolling 12-month return
- rolling 36-month return
- rolling 60-month return

## Rolling Risk

Rolling calculations can show whether:

- Volatility changed
- correlation changed
- drawdown risk changed
- tracking changed
- a fund behaved differently across market environments

## Correlation

Correlation measures how two return series moved relative to each other.

Its usual range is:

-1 to +1

## Positive Correlation

A positive correlation means the returns generally moved in the same direction.

## Negative Correlation

A negative correlation means the returns generally tended to move in opposite directions.

## Near-Zero Correlation

Near-zero correlation indicates limited linear relationship during the measured period.

## Correlation Is Not Stable

Correlation may change because of:

- Market stress
- interest rates
- inflation
- currency
- investor behavior
- structural change
- policy change
- liquidity pressure

## Crisis Correlation

Assets that appear diversified during normal markets may become more correlated during stress.

## Correlation Matrix

A correlation matrix compares multiple return series using the same:

- Dates
- frequency
- currency
- return type
- missing-data treatment

## Correlation Data Quality

Do not calculate correlation from series with:

- Mismatched dates
- different frequencies
- stale prices
- inconsistent currencies
- different distribution treatment
- insufficient observations

## Covariance

Covariance measures how two return series vary together.

Correlation standardizes covariance using the volatility of both series.

## Portfolio Volatility

For a two-asset portfolio, portfolio variance depends on:

- Asset weights
- each asset’s variance
- covariance between assets

Low correlation can reduce portfolio volatility, but it does not guarantee protection.

## Diversification Benefit

Diversification benefit occurs when combined assets produce a more favorable risk profile than concentrated ownership.

## Diversification Failure

Diversification may fail when:

- Holdings overlap
- sector concentration is hidden
- country exposures are similar
- currencies move together
- correlations rise during stress
- multiple funds hold the same large companies

## Beta

Beta estimates sensitivity to a selected benchmark.

A beta of approximately:

- 1 suggests similar sensitivity
- above 1 suggests greater sensitivity
- below 1 suggests lower sensitivity
- below 0 suggests opposite historical sensitivity

## Beta Limitation

Beta depends on:

- Benchmark
- period
- frequency
- currency
- market environment

It does not measure every form of risk.

## Alpha

Alpha is an estimated return beyond that explained by the selected model or benchmark.

Historical alpha does not prove manager skill or future outperformance.

## R-Squared

R-squared measures how much variation in the fund’s returns is statistically associated with the benchmark under the selected model.

A high R-squared may support use of beta.

A low R-squared may make beta less meaningful.

## Sharpe Ratio

Sharpe ratio generally equals:

Portfolio return
minus risk-free return

divided by volatility

## Sharpe Ratio Interpretation

A higher historical Sharpe ratio indicates more excess return per unit of measured volatility.

It does not guarantee future performance.

## Sharpe Ratio Limitations

Sharpe ratio can be distorted by:

- Short history
- stale pricing
- non-normal returns
- leverage
- infrequent losses
- unsuitable risk-free rate
- currency mismatch

## Sortino Ratio

Sortino ratio generally equals:

Portfolio return
minus target return

divided by downside deviation

It focuses on harmful variation below the selected target.

## Calmar Ratio

Calmar ratio generally compares:

Annualized return
with absolute maximum drawdown

## Information Ratio

Information ratio generally equals:

Active return
divided by tracking error

It may be used when comparing a fund with its benchmark.

## Active Return

Active return equals:

Fund return
minus benchmark return

## Tracking Error

Tracking error measures variability in active return.

## Capture Ratio

Capture ratios compare performance during benchmark up and down periods.

## Upside Capture

Upside capture evaluates fund behavior when the benchmark rises.

## Downside Capture

Downside capture evaluates fund behavior when the benchmark falls.

A downside-capture ratio below 100% may indicate the fund historically lost less than the benchmark during down periods.

## Capture-Ratio Limitation

Capture ratios depend on:

- Benchmark choice
- measurement frequency
- sample period
- number of up and down observations

## Batting Average

A batting average may measure the percentage of periods in which a fund outperformed its benchmark.

It does not measure the magnitude of outperformance or underperformance.

## Concentration Risk

Concentration risk can arise from:

- Largest holding
- top-ten holdings
- sector
- country
- issuer
- currency
- factor
- bond issuer
- credit quality
- maturity

## Largest-Holding Weight

Record the percentage allocated to the largest security.

## Top-Ten Weight

Add the weights of the ten largest positions.

## Effective Number of Holdings

An effective number of holdings may be estimated as:

1 divided by the sum of squared holding weights

This reflects concentration more meaningfully than the raw number of holdings.

## Example

A fund with 500 holdings may still be highly concentrated if a small number of holdings dominate the weight.

## Herfindahl-Hirschman Index

The Herfindahl-Hirschman Index may be calculated as the sum of squared portfolio weights.

Use consistent units.

## Sector Concentration

A broad index may become heavily exposed to one sector because of market capitalization changes.

## Country Concentration

A regional or emerging-market fund may be dominated by one or two countries.

## Issuer Concentration

Bond ETFs may hold many securities from the same issuer.

Count issuer exposure rather than only bond count.

## Credit Risk

For bond ETFs, review:

- Credit-rating distribution
- default exposure
- downgrade risk
- recovery assumptions
- issuer concentration
- sector concentration

## Interest-Rate Risk

Interest-rate risk may be measured partly through:

- Duration
- maturity
- yield-curve exposure
- convexity

## Duration

Duration estimates sensitivity to interest-rate changes under specified assumptions.

A simplified approximation is:

Percentage price change
approximately equals:

Negative duration
multiplied by interest-rate change

## Example

Duration:

6

Rate increase:

1 percentage point

Approximate price effect:

-6%

This is only an approximation.

## Convexity

Convexity refines the relationship between bond prices and interest-rate changes.

## Yield Risk

A high stated yield may reflect:

- Higher credit risk
- longer duration
- illiquidity
- distressed pricing
- option exposure
- return of capital

## Currency Risk

For an investor measuring results in COP, a USD ETF return may be affected by:

- ETF return in USD
- USD/COP movement
- conversion cost
- withholding
- tax

## Currency-Adjusted Return

A reporting-currency return may be calculated as:

(1 + asset return in source currency)
multiplied by
(1 + currency return)

minus 1

## Example

ETF return in USD:

5%

USD appreciation against COP:

10%

COP return before fees and tax:

1.05 × 1.10 - 1

Result:

15.5%

## Currency Loss Example

ETF return in USD:

5%

USD depreciation against COP:

10%

COP return:

1.05 × 0.90 - 1

Result:

-5.5%

## Currency Hedging Risk

A hedged ETF may still experience:

- Hedge cost
- imperfect hedge
- timing differences
- counterparty exposure
- interest-rate differential
- residual currency exposure

## Liquidity Risk

Liquidity risk can be evaluated using:

- Bid-ask spread
- average trading volume
- underlying liquidity
- market depth
- premium or discount
- trading-hour alignment
- creation and redemption status

## Risk of Stale Prices

Illiquid holdings may show artificially low measured volatility because prices change infrequently.

Low observed volatility does not always mean low economic risk.

## Return Smoothing

Return smoothing occurs when reported values adjust gradually rather than reflecting current market conditions.

## Fund Age

A new ETF may have insufficient live data for reliable risk measurement.

Do not substitute:

- Backtested index data
- peer data
- synthetic history

without clear labeling.

## Survivorship Bias

Survivorship bias occurs when analysis includes only funds that remained available.

Closed or failed funds may be omitted.

## Look-Ahead Bias

Look-ahead bias uses information that was not available at the historical decision date.

## Selection Bias

Selection bias occurs when funds or periods are chosen because they support a preferred conclusion.

## Benchmark Bias

Selecting an inappropriate benchmark can make a fund appear:

- Safer
- riskier
- better performing
- more diversified

than it actually is.

## Data-Snooping Risk

Repeatedly testing many strategies can identify attractive historical patterns that occurred by chance.

## Backtest Overfitting

A backtest may be overfit when rules are optimized too closely to historical data.

## Short-History Risk

A fund that began after a major crisis may not have experienced:

- Recession
- inflation shock
- interest-rate shock
- currency crisis
- liquidity crisis
- prolonged bear market

## Proxy History

A proxy may be used when fund history is short.

Record:

- Proxy name
- reason
- differences
- limitations
- confidence

## Scenario Analysis

Scenario analysis estimates the effect of defined conditions.

It is not a forecast.

## Historical Scenario

A historical scenario applies conditions from a past market period.

Limitations include:

- Different valuations
- different interest rates
- changed holdings
- changed regulation
- changed market structure

## Hypothetical Scenario

A hypothetical scenario applies assumed changes.

Examples:

- Equities fall 25%
- interest rates rise 2 percentage points
- COP weakens 15%
- credit spreads widen
- ETF spread doubles
- distributions decline

## Deterministic Scenario

A deterministic scenario uses fixed assumptions.

## Probabilistic Simulation

A probabilistic simulation uses modeled distributions and repeated outcomes.

Its results depend strongly on assumptions.

## Scenario Variables

Possible variables include:

- Equity return
- bond return
- interest rate
- credit spread
- inflation
- currency
- property value
- income
- withdrawal
- liquidity cost
- tax

## Single-Factor Stress

A single-factor stress changes one variable while holding others constant.

## Multi-Factor Stress

A multi-factor stress changes several related variables simultaneously.

This is often more realistic during crises.

## Correlated Stress

During stress, assume that adverse factors may occur together.

Example:

- Equity decline
- currency movement
- wider spreads
- income disruption
- higher household expenses

## Portfolio Scenario

A portfolio scenario should calculate:

- Starting value
- asset-level loss
- currency effect
- withdrawal
- fees
- taxes
- ending value
- allocation after shock
- reserve impact

## Drawdown Tolerance

Drawdown tolerance should distinguish:

### Financial capacity

Can the household absorb the loss without harming essential goals?

### Emotional tolerance

Can the investor remain disciplined during the decline?

### Required risk

How much risk is actually necessary to fund the goal?

## Loss Capacity

Loss capacity depends on:

- Time horizon
- income
- pension
- reserves
- debt
- dependents
- health costs
- withdrawal need
- goal flexibility

## Risk Tolerance Questionnaire Limitation

A questionnaire may help structure discussion but should not replace:

- Balance-sheet review
- cash-flow analysis
- goal timing
- behavioral history
- scenario testing

## Risk Budget

A risk budget allocates acceptable risk across:

- Asset classes
- goals
- accounts
- currencies
- strategies

## Loss Limit

A loss limit should not automatically trigger emotional selling.

It may instead trigger:

- Review
- rebalancing
- evidence update
- liquidity assessment
- professional consultation

## Portfolio Risk Contribution

An asset’s risk contribution depends on:

- Weight
- volatility
- covariance with other holdings

A small highly volatile position may contribute substantial risk.

## Marginal Risk Contribution

Marginal risk contribution estimates how portfolio risk changes when an asset’s weight changes slightly.

## Equal-Risk Contribution

Equal-risk contribution attempts to allocate similar risk rather than similar capital.

This is more complex than equal weighting.

## Rebalancing After Drawdown

A drawdown may cause allocation drift.

Before rebalancing, verify:

- Reserve sufficiency
- tax effects
- transaction costs
- target allocation
- investment policy
- changed financial circumstances

## Sequence Risk

Sequence risk arises when poor returns occur near the beginning of a withdrawal period.

## Sequence-of-Returns Example

Two portfolios may have the same average return but different outcomes when:

- One experiences losses early
- the other experiences losses later

Withdrawals make the sequence materially important.

## Withdrawal Stress Test

Review the effect of:

- Market decline
- continued withdrawal
- inflation
- currency movement
- fees
- recovery delay

## Recovery Assumption Risk

Do not assume that every market decline will recover:

- Quickly
- completely
- on the prior historical schedule

## Scenario Probability

Scenario probabilities should not be presented as precise facts unless supported by a defensible model.

## Sensitivity Analysis

Sensitivity analysis changes one assumption at a time to identify which inputs drive the result.

## Break-Even Analysis

Break-even analysis determines the condition required to achieve a specified outcome.

Example:

- Required return to reach a goal
- maximum acceptable loss
- maximum fee
- minimum recovery
- required contribution

## Reverse Stress Test

A reverse stress test begins with failure.

Ask:

- What combination of losses, inflation, withdrawals, and currency movement would make the goal fail?

## Severe but Plausible Scenario

A severe but plausible scenario should be difficult but not impossible.

Avoid using only mild scenarios that cannot challenge the plan.

## Scenario Documentation

Every scenario should record:

- Name
- date
- purpose
- assumptions
- source
- time horizon
- affected holdings
- result
- limitation
- required action

## Risk Comparison

A fund comparison should use the same:

- Measurement period
- frequency
- currency
- total-return convention
- benchmark
- risk-free rate
- minimum acceptable return
- data source

## Ranking Risk

A fund should not be selected solely because it ranks first on one metric.

## Composite Score

A composite score may combine several measures.

Document:

- Metrics
- weights
- normalization
- missing-data treatment
- threshold
- limitations

## False Precision

Avoid conclusions such as:

- Fund A is exactly 7.4% safer

unless the definition and model support that statement.

Prefer:

- Fund A had lower measured volatility and a smaller maximum drawdown during the selected period.

## Risk Metric Confidence

Use:

### High

- Current verified data
- adequate history
- consistent methodology
- appropriate benchmark

### Moderate

- Reasonable data
- some limitations
- shorter history
- proxy use

### Low

- Sparse data
- inconsistent history
- stale pricing
- unclear methodology

### Unknown

- Calculation cannot be verified

## Risk Metric Status

### Green

- Data consistent
- risk within policy
- drawdown tolerable
- liquidity adequate
- scenario results manageable

### Yellow

- Risk increased
- short history
- correlation rose
- drawdown exceeds expectation
- additional review required

### Red

- Data unreliable
- loss capacity exceeded
- liquidity impaired
- concentration excessive
- scenario threatens essential goals
- metric calculation cannot be reconciled

## Risk Review Frequency

### Monthly

Monitor:

- Allocation
- concentration
- major drawdown
- liquidity
- goal proximity

### Quarterly

Review:

- Rolling volatility
- correlation
- drawdown
- risk contribution
- currency exposure

### Annually

Review:

- Full historical risk
- benchmark
- scenario analysis
- loss capacity
- risk policy
- household circumstances

### Event Driven

Review after:

- Major market decline
- retirement begins
- income loss
- property purchase
- health change
- currency shock
- fund methodology change
- liquidity event

## Automatic Stop Conditions

Do not rely on a risk comparison when:

- Data periods differ
- one series uses price return and another total return
- currencies differ without adjustment
- benchmark is inappropriate
- history is too short and unlabeled
- stale prices suppress measured volatility
- distributions are missing
- correlation uses mismatched dates
- maximum drawdown cannot be reproduced
- risk-free rate is unidentified
- backtested history is presented as actual fund history
- severe scenarios are excluded
- result conflicts with household loss capacity

## Beginner Rules

1. Compare total return using consistent data.
2. measure both volatility and drawdown.
3. review drawdown duration and recovery time.
4. do not assume correlation is permanent.
5. measure concentration using actual weights.
6. separate currency return from asset return.
7. use more than one risk metric.
8. test severe but plausible scenarios.
9. compare risk with household loss capacity.
10. stop when data, formulas, or assumptions cannot be verified.

## Knowledge Check

1. Why is volatility an incomplete risk measure?
2. What is maximum drawdown?
3. How does drawdown duration differ from drawdown depth?
4. What does correlation measure?
5. Why may correlation rise during market stress?
6. How does beta depend on the benchmark?
7. What is the difference between the Sharpe and Sortino ratios?
8. Why may illiquid assets appear less volatile?
9. What is a reverse stress test?
10. What conditions should stop reliance on a risk comparison?

## Status

- [ ] Read the lesson
- [ ] Define consistent data standards
- [ ] calculate annualized return
- [ ] calculate annualized volatility
- [ ] calculate maximum drawdown
- [ ] calculate recovery time
- [ ] calculate correlation
- [ ] review concentration
- [ ] separate currency effects
- [ ] complete severe scenario analysis
- [ ] compare risk with loss capacity
- [ ] schedule annual ETF risk review
