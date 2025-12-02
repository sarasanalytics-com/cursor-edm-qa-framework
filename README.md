# Cursor QA Framework

A standardized AI-powered data quality framework for dbt/BigQuery projects using Cursor IDE.

## 🚀 Quick Start

### One-Command Installation

```bash
curl -sSL https://raw.githubusercontent.com/sarasanalytics-com/cursor-edm-qa-framework/main/scripts/setup-qa-framework.sh | bash
```

### Manual Installation

```bash
# Clone the framework
git clone https://github.com/sarasanalytics-com/cursor-qa-framework.git /tmp/qa-framework

# Copy to your project
cp -r /tmp/qa-framework/.cursor/rules .cursor/
cp -r /tmp/qa-framework/.github .
cp -r /tmp/qa-framework/qa .

# Clean up
rm -rf /tmp/qa-framework
```

## 📁 What Gets Installed

```
your-project/
├── .cursor/
│   └── rules/
│       ├── project-context.mdc       # Update with your project info
│       ├── qa-check-standards.mdc    # Standard QA checks
│       ├── qa-thresholds.mdc         # Pass/fail thresholds
│       ├── qa-output-format.mdc      # Output formatting
│       ├── pr-prepare.mdc            # PR preparation rules
│       └── known-issues.mdc          # Known issue registry
├── qa/
│   ├── qa_config.yml                 # Your project config (customize!)
│   ├── README.md                     # Documentation
│   └── QA Results/                   # QA reports go here
└── .github/
    └── PULL_REQUEST_TEMPLATE.md      # PR template
```

## ⚙️ Configuration

### Step 1: Set Up BigQuery MCP

Create `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "bigquery": {
      "command": "/path/to/toolbox",
      "args": ["--prebuilt", "bigquery", "--stdio"],
      "env": {
        "GOOGLE_APPLICATION_CREDENTIALS": "/path/to/keyfile.json"
      }
    }
  }
}
```

### Step 2: Configure Your Project

Edit `qa/qa_config.yml`:

```yaml
project_id: "your-bigquery-project-id"

datasets:
  main: "your_main_dataset"
  presentation: "your_presentation_dataset"

tables:
  your_table:
    dataset: main
    date_column: date
    primary_key: [id]
    foreign_keys:
      - column: dim_key
        references:
          table: dim_table
          column: key
```
The above can be done by using just a cursor prompt of 'update my qa_config.yml' based upon the contents and data from this repository' . Cursor will read off project.yml + metadata but make sure to review the output thoroughly to prevent incorrect QA checks in the future

### Step 3: Update Project Context

Edit `.cursor/rules/project-context.mdc` with your:
- BigQuery project ID
- Dataset names
- Key tables

Similar to above, this can be also done by using just a cursor prompt of 'update my project-context.mdc' based upon the contents and data from this repository' . Cursor will read off project.yml + metadata but make sure to review the output thoroughly to prevent incorrect QA checks in the future

## 🎯 Usage

### Run QA Checks

```
"Run QA checks on my_table"
"Run QA checks on all tables"
"Check data freshness for all tables"
"Do referential integrity test on fact_orders"
```

### Prepare PR

```
"Prepare PR for my changes"
```

This will:
1. Identify changed tables
2. Run QA checks on affected tables + downstream
3. Save QA report to `/qa/QA Results/`
4. Generate PR description
5. Give you the command to create PR

## 📊 QA Checks Included

| Check | Description |
|-------|-------------|
| Data Freshness | Alert if data > 2 days old |
| Null Values | Check null % against thresholds |
| Duplicates | Identify duplicate records |
| Referential Integrity | Validate FK relationships |
| Invalid Values | Find negative/invalid data |
| Distribution | Show categorical value distributions |
| Logic Changes | Summarise changes at a table level |
| Data Impact | Summarise data impact based upon dev vs prod datasets |

## 🔧 Customization

### Add Table-Specific Rules

Create `.cursor/rules/table-{name}.mdc`:

```markdown
---
description: QA rules for specific table
globs: ["**/table_name*"]
alwaysApply: false
---

# Table Name Rules

- Primary Key: [columns]
- Foreign Keys: [relationships]
- Known Issues: [list]
```

### Add Known Issues

Edit `.cursor/rules/known-issues.mdc`:

```markdown
### ISSUE-001: Description
| Field | Value |
|-------|-------|
| Table | table_name |
| Issue | What's wrong |
| Accepted Threshold | X% |
```

## 🔄 Updating the Framework

Pull latest rules:

```bash
curl -sSL https://raw.githubusercontent.com/sarasanalytics-com/cursor-edm-qa-framework/main/scripts/update-qa-framework.sh | bash
```

## 📞 Support

- Check `/qa/README.md` for detailed documentation
- Review known issues in `.cursor/rules/known-issues.mdc`
- Contact the Data Engineering team

## 🏢 For Organizations

### Central Management

1. Fork this repo to your organization
2. Customize default rules for your standards
3. Teams install from your fork
4. Push updates to propagate changes

### Team Onboarding

```bash
# New team member setup
curl -sSL https://your-org/cursor-qa-framework/main/scripts/setup-qa-framework.sh | bash
```

### Governance

- Central team maintains core rules
- Project teams add project-specific rules
- Known issues documented per project
- PR template ensures QA compliance

