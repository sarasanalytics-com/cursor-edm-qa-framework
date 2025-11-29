#!/bin/bash
#
# Cursor QA Framework Setup Script
# ================================
# This script sets up the standard QA framework for any dbt/BigQuery project
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/BetterBodyCo/cursor-qa-framework/main/scripts/setup-qa-framework.sh | bash
#
# Or:
#   ./setup-qa-framework.sh
#

set -e

FRAMEWORK_REPO="https://github.com/BetterBodyCo/cursor-qa-framework.git"
TEMP_DIR="/tmp/cursor-qa-framework-$$"

echo "🚀 Setting up Cursor QA Framework..."
echo ""

# Check if we're in a git repo
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository. Please run this from your project root."
    exit 1
fi

# Clone the framework repo
echo "📥 Downloading framework..."
git clone --depth 1 "$FRAMEWORK_REPO" "$TEMP_DIR" 2>/dev/null || {
    echo "❌ Error: Could not download framework. Check your internet connection."
    exit 1
}

# Create directories if they don't exist
echo "📁 Creating directories..."
mkdir -p .cursor/rules
mkdir -p qa
mkdir -p .github

# Copy Cursor rules
echo "📋 Installing Cursor rules..."
cp -r "$TEMP_DIR/.cursor/rules/"* .cursor/rules/ 2>/dev/null || true

# Copy QA templates (don't overwrite existing)
echo "📋 Installing QA templates..."
if [ ! -f "qa/qa_config.yml" ]; then
    cp "$TEMP_DIR/qa/qa_config.template.yml" qa/qa_config.yml 2>/dev/null || true
fi
cp "$TEMP_DIR/qa/README.md" qa/README.md 2>/dev/null || true
mkdir -p "qa/QA Results"

# Copy GitHub templates (don't overwrite existing)
echo "📋 Installing GitHub templates..."
if [ ! -f ".github/PULL_REQUEST_TEMPLATE.md" ]; then
    cp "$TEMP_DIR/.github/PULL_REQUEST_TEMPLATE.md" .github/ 2>/dev/null || true
fi

# Update .gitignore
echo "📝 Updating .gitignore..."
if ! grep -q ".github/pr-body.md" .gitignore 2>/dev/null; then
    echo "" >> .gitignore
    echo "# Cursor QA Framework - temporary files" >> .gitignore
    echo ".github/pr-body.md" >> .gitignore
fi

# Clean up
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Cursor QA Framework installed successfully!"
echo ""
echo "📝 Next steps:"
echo "   1. Edit qa/qa_config.yml with your project settings:"
echo "      - BigQuery project ID"
echo "      - Dataset names"
echo "      - Table definitions"
echo ""
echo "   2. Configure .cursor/mcp.json with your BigQuery credentials"
echo ""
echo "   3. Start using the framework:"
echo "      - 'Run QA checks on [table_name]'"
echo "      - 'Prepare PR for my changes'"
echo ""
echo "📚 Documentation: qa/README.md"
echo ""

