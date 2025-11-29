# Data Quality (QA) Framework

This folder contains the QA configuration and rules for the data warehouse. Any Cursor user can leverage these standards for consistent data quality checks.

## Quick Start

Simply ask Cursor AI to run QA checks on any table:

```
"Run QA checks on OrderLinesMaster"
"Do a referential integrity test on fact_order_lines"
"Check data freshness for all advertising tables"
```

Cursor will automatically reference the `.cursorrules` file and `qa/qa_config.yml` to run standardized checks.

## Files & Folders

| Path | Purpose |
|------|---------|
| `/.cursorrules` | Cursor AI rules for QA check standards and output format |
| `/qa/qa_config.yml` | Structured table definitions, foreign keys, and thresholds |
| `/qa/README.md` | This documentation |
| `/qa/QA Results/` | **📁 QA output files - check here for results!** |

## 📍 Where to Find QA Results

All QA check outputs are saved as markdown files in:

```
/qa/QA Results/QA-check-YYYY-MM-DD.md
```

**Example:** `/qa/QA Results/QA-check-2025-11-28.md`

Each file contains the complete QA report for that date, including:
- Executive summary with health score
- Detailed results per table
- Action items and owners
- Trends vs previous checks
- SQL queries used

## Standard QA Checks

### 1. Data Freshness
Checks how recent the data is. Alert if > 2 days stale.

### 2. Null Value Analysis
Checks null percentages for all columns:
- Primary keys: 0% allowed
- Foreign keys: <5% acceptable
- Optional fields: <25% acceptable

### 3. Duplicate Detection
Identifies duplicate records based on primary key columns.

### 4. Referential Integrity
Validates foreign key relationships between fact and dimension tables.

### 5. Invalid Values
Checks for negative numbers, invalid categorical values, etc.

### 6. Distribution Analysis
Shows value distributions for categorical columns.

## Output Format

All QA results follow a consistent format and are saved to `/qa/QA Results/QA-check-YYYY-MM-DD.md`

### What's Included in Each QA Report

#### 1. Executive Summary
A high-level overview at the top of the report:

| Section | Description |
|---------|-------------|
| **Run Metadata** | Date, who ran it, tables checked |
| **Health Score** | Overall percentage (e.g., 79%) |
| **Quick Stats** | Total checks, passed, warnings, failed |
| **Table Summary** | One-line status per table |

#### 2. Detailed Results Per Table
For each table checked, you'll see:

| Check Type | What It Shows |
|------------|---------------|
| **Data Freshness** | Latest record date, days since last record, pass/fail status |
| **Null Values** | Per-column null counts, percentages, and threshold comparison |
| **Duplicates** | Total rows, unique rows, duplicate count |
| **Referential Integrity** | Per-FK orphan counts and percentages |
| **Invalid Values** | Negative numbers, zero values, invalid categories |

**Example Table Output:**
```
| Column | Null Count | Null % | Threshold | Status |
|--------|-----------|--------|-----------|--------|
| order_id | 0 | 0.00% | 0% | ✅ Pass |
| customer_id | 2,356,074 | 24.03% | 25% | 🟡 Warning |
```

#### 3. Action Items
Prioritized list of issues requiring attention:

| Column | Description |
|--------|-------------|
| ID | Unique issue identifier |
| Issue | Description of the problem |
| Table | Affected table |
| Impact | Number of affected rows |
| Owner | Assigned team member |
| Due | Target resolution date |

#### 4. Trends
Comparison with previous QA run:

```
| Metric | Previous | Current | Change |
|--------|----------|---------|--------|
| Total Rows | 9,750,000 | 9,804,223 | +54,223 |
```

#### 5. SQL Queries Used
Expandable section containing **ALL SQL queries** executed during the QA check (not just failed ones). Each query includes:
- Check type and table name
- Pass/Fail status indicator
- Known issue ID (if applicable)
- The complete SQL for reproducibility

This allows users to:
- Reproduce any check manually in BigQuery
- Debug specific issues
- Verify what exactly was tested
- Copy queries for ad-hoc analysis

#### 6. Sign-off Section
Tracking for review and approval workflow.

### Severity Levels

| Icon | Level | Meaning |
|------|-------|---------|
| ✅ | **Pass** | Within acceptable thresholds |
| 🟡 | **Warning** | Slightly above threshold, monitor closely |
| 🔴 | **Fail** | Critical issue, needs immediate attention |

### Priority Classification

| Priority | Description | SLA |
|----------|-------------|-----|
| **P0** | Data pipeline broken | Immediate fix required |
| **P1** | Significant data quality issue | Fix within 24 hours |
| **P2** | Minor issue | Fix within 1 week |
| **P3** | Cosmetic/low impact | Fix when convenient |

### Health Score Calculation

The overall health score is calculated as:

```
Health Score = (Passed Checks / Total Checks) × 100
```

| Score Range | Status |
|-------------|--------|
| 90-100% | 🟢 Excellent |
| 75-89% | 🟡 Good (needs attention) |
| 50-74% | 🟠 Poor (action required) |
| <50% | 🔴 Critical (immediate action) |

## Known Issues

Some data quality issues are known and accepted. These are documented in `qa_config.yml` under `known_issues`. Cursor will not flag these as failures.

| ID | Table | Issue | Status |
|----|-------|-------|--------|
| SUB-001 | fact_order_lines | Amazon subscriptions not in dim_subscription | In Progress |
| PROD-001 | fact_product_advertising | Ad products not in dim_product | Accepted |
| CUST-001 | OrderLinesMaster | 24% null customer_id (Amazon) | Accepted |
| CURR-001 | OrderLinesMaster | Invalid currency codes | Open |

## Adding New Tables

If you want cursor to perform the above QA checks to new custom tables, please add these table details as an  an entry to `qa_config.yml`:

```yaml
tables:
  NewTableName:
    dataset: prod_edm_main
    description: "Description of the table"
    date_column: date_field
    primary_key:
      - key_column1
      - key_column2
    required_columns:
      - column1
      - column2
    foreign_keys:
      - column: fk_column
        references:
          table: dim_table
          column: pk_column
```

## Adding Known Issues

When a data quality issue is identified and accepted, add it to `known_issues`:

```yaml
known_issues:
  - id: UNIQUE-ID
    table: table_name
    column: column_name
    description: "Why this issue exists"
    severity: P1/P2/P3
    status: open/in_progress/accepted
    accepted_orphan_pct: 85  # if referential integrity issue
    accepted_null_pct: 25    # if null value issue
```

## Updating Thresholds

Global thresholds are defined at the top of `qa_config.yml`:

```yaml
thresholds:
  data_freshness_days: 2
  null_pct_primary_key: 0
  null_pct_foreign_key: 5
  null_pct_optional: 25
  duplicate_count: 0
  orphan_pct: 1
```

## Example Cursor Commands

```
# Full QA on a specific table
"Run complete QA checks on OrderLinesMaster"

# Specific check types
"Check referential integrity for fact_order_lines"
"Show me null value analysis for dim_customer"
"What's the data freshness for advertising tables?"

# Compare against known issues
"Are there any new data quality issues in fact_overall_advertising?"

# Cross-table checks
"Run referential integrity tests for all facts and dims in the main layer"
```

## Maintenance

- **Weekly**: Review QA results for presentation layer tables
- **Monthly**: Full QA audit of all modelling layer tables
- **On Deploy**: Run QA checks on modified tables before promoting to prod

