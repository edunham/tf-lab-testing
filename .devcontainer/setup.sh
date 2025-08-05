#!/bin/bash

# Terraform 101 Racing Lab - Codespaces Setup Script
# This script prepares the development environment for the workshop

echo "🏁 Setting up your Terraform Racing Lab environment..."

# Update system packages
echo "📦 Updating system packages..."
sudo apt-get update -qq

# Install additional tools that might be helpful
echo "🔧 Installing additional tools..."
sudo apt-get install -y -qq \
    curl \
    jq \
    tree \
    htop \
    unzip

# Install/Verify Terraform installation
echo "🔧 Installing/Verifying Terraform..."

# Check if terraform is already installed
if command -v terraform >/dev/null 2>&1; then
    echo "✅ Terraform already installed:"
    terraform --version
else
    echo "📦 Installing Terraform..."
    
    # Install Terraform via HashiCorp's official method
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    
    sudo apt-get update -qq
    sudo apt-get install -y terraform
    
    echo "✅ Terraform installed:"
    terraform --version
fi

# Create helpful aliases
echo "Setting up command aliases..."
cat >> ~/.bashrc << 'EOF'

# Terraform Lab Aliases
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tfs='terraform show'

# Optional themed aliases
alias race='terraform apply'
alias pitstop='terraform plan'
alias checkered='terraform show'
alias warmup='terraform validate'

# Helpful functions
function show-resources() {
    echo "Current resources:"
    terraform show -json | jq -r '.values.root_module.resources[] | "\(.type): \(.values.name // .values.label // "unnamed")"' 2>/dev/null || echo "No resources deployed yet"
}

function show-groups() {
    echo "Current groups:"
    terraform show -json | jq -r '.values.root_module.resources[] | select(.type=="okta_group") | "Group: \(.values.name)"' 2>/dev/null || echo "No groups created yet"
}

EOF

# Set up Terraform tab completion
echo "⚡ Setting up Terraform tab completion..."
terraform -install-autocomplete 2>/dev/null || true

# Create workspace structure if it doesn't exist
echo "📁 Setting up workspace structure..."
mkdir -p {exercises/{01-team-formation,02-driver-roster,03-race-operations},solutions/{01-team-formation,02-driver-roster,03-race-operations},.tours}

# Create helpful getting started files
echo "📋 Creating getting started guide..."
cat > GETTING_STARTED.md << 'EOF'
# 🏁 Quick Start Guide

## 1. Set Environment Variables
```bash
export OKTA_ORG_NAME="your-dev-org"
export OKTA_BASE_URL="oktapreview.com"  # or okta.com
export OKTA_API_TOKEN="your-api-token"
```

## 2. Test Connection
```bash
terraform init
terraform plan
```

## 3. Start First Exercise
```bash
cd exercises/01-team-formation
cat README.md
```

## Helpful Commands
- `show-resources` - Show current infrastructure
- `show-groups` - Show created groups
- `tf plan` - Preview changes
- `tf apply` - Deploy changes
EOF

# Create example environment file
echo "Creating environment template..."
cat > .env.example << 'EOF'
# Okta Configuration for Terraform Lab
# Copy this file to .env and fill in your values

# Your Okta organization name (the part before .okta.com or .oktapreview.com)
OKTA_ORG_NAME=your-dev-org-name

# Your Okta base URL (usually oktapreview.com for developer accounts)
OKTA_BASE_URL=oktapreview.com

# Your Okta API token (create in Security > API > Tokens)
OKTA_API_TOKEN=your-api-token-here

# Optional: Enable terraform debug logging
# TF_LOG=DEBUG
EOF

# Set proper permissions
chmod +x .devcontainer/setup.sh
chmod 600 .env.example

echo ""
echo "Setup complete! Your lab environment is ready."
echo ""
echo "Next steps:"
echo "   1. Set your Okta credentials (see GETTING_STARTED.md)"
echo "   2. Run 'terraform init' to initialize"
echo "   3. Navigate to exercises/01-team-formation to begin"
echo ""