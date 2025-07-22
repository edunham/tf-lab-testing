# 🏁 Terraform 101: Racing Team Identity Management

A hands-on workshop that teaches Infrastructure as Code fundamentals using Okta identity management. No prior Terraform experience required.

## 🏆 What You'll Learn

By the end of this lab, you'll understand:
- **Terraform fundamentals**: providers, resources, variables, outputs
- **Infrastructure as Code principles**: declarative configuration, state management
- **Okta identity management**: users, groups, applications, and access control
- **Real-world DevOps practices**: version control, validation, and collaboration

## 🏎️ Scenario

You're managing identity infrastructure for multiple racing teams. You'll set up:

- **Teams**: Velocity Racing, Thunder Motors, Phoenix Speed, Storm Racing
- **Members**: Drivers, engineers, pit crew, and support staff
- **Applications**: Race Dashboard, Timing Portal, Team Communication, Data Analytics

## 🚀 Quick Start

### Prerequisites
- GitHub account (for Codespaces)
- Okta developer account (free at developer.okta.com)
- Basic familiarity with command line

### Launch Environment
1. **Open in Codespaces**: Click the green "Code" button → "Codespaces" → "Create codespace"
2. **Wait for setup**: The devcontainer will automatically install Terraform and configure your environment
3. **Verify installation**: Run `terraform --version` in the terminal

### Set Up Credentials
1. **Get Okta details** from your Okta developer account:
   - Org URL (e.g., `https://dev-123456.okta.com`)
   - API Token (from Security → API → Create Token)

2. **Configure environment** (instructor will provide exact commands):
   ```bash
   export OKTA_ORG_NAME="your-okta-org"
   export OKTA_BASE_URL="okta.com"  # or oktapreview.com
   export OKTA_API_TOKEN="your-api-token"
   ```

## 🏁 Exercises

### 🏎️ Exercise 1: Team Formation (30 minutes)
**Learn**: Basic Terraform workflow, providers, simple resources

Create four teams as Okta groups:
- Velocity Racing
- Thunder Motors 
- Phoenix Speed
- Storm Racing

**Key Concepts**: `terraform init`, `terraform plan`, `terraform apply`, basic resource syntax

### 🏎️ Exercise 2: Driver Roster (Coming Soon)
**Learn**: Variables, locals, resource dependencies

*This exercise is under development and will be available in the next version.*

### 🏎️ Exercise 3: Race Operations (Coming Soon)
**Learn**: Applications, assignments, outputs

*This exercise is under development and will be available in the next version.*

## 📁 Repository Structure

```
terraform-101-okta/
├── README.md                    # This file
├── main.tf                      # Core Terraform configuration
├── variables.tf                 # Input variables
├── outputs.tf                   # Output definitions
├── terraform.tfvars.example    # Example configuration
├── .devcontainer/              # Codespaces configuration
├── exercises/                   # Step-by-step exercises
│   └── 01-team-formation/      # First exercise - creating teams
├── solutions/                   # Complete solutions (future)
└── .tours/                      # Interactive code tour (future)
```

## 🛠️ Terraform Commands Reference

Essential commands you'll use throughout the lab:

```bash
# Initialize Terraform (download providers)
terraform init

# Check configuration syntax
terraform validate

# Preview changes (safe, read-only)
terraform plan

# Apply changes to create infrastructure
terraform apply

# Show current state
terraform show

# Destroy all resources (cleanup)
terraform destroy
```

## 🏁 Getting Started

1. **Set up your environment** following the Quick Start above
2. **Navigate to Exercise 1**: `cd exercises/01-team-formation`
3. **Follow the README** in the exercise directory
4. **Future exercises**: Additional exercises will be added in upcoming versions

## 🔧 Troubleshooting

### Common Issues

**"terraform: command not found"**
- Solution: Wait for Codespaces to finish setup, or restart the terminal

**"Invalid credentials" from Okta**
- Solution: Double-check your OKTA_API_TOKEN and OKTA_ORG_NAME environment variables

**"Resource already exists"**
- Solution: Run `terraform import` or use a different resource name

**Terraform state issues**
- Solution: Delete `.terraform/` directory and run `terraform init` again

### Getting Help

- **During workshop**: Raise your hand or ask in chat
- **After workshop**: Check the solutions/ directory for complete examples
- **Terraform docs**: https://registry.terraform.io/providers/okta/okta/latest/docs
- **Okta developer docs**: https://developer.okta.com/

## 🏆 Completion Certificates

After completing all three exercises:
1. Run `terraform plan` in the final solution directory - it should show "No changes"
2. Take a screenshot of your Okta admin console showing the created teams and users
3. Share your success with the racing metaphor that resonated most with you!

## 🎯 Next Steps

Ready to advance your Terraform skills? Consider:
- **Terraform modules**: Reusable infrastructure components
- **Remote state**: Team collaboration with shared state
- **CI/CD integration**: Automated terraform in pipelines
- **Multi-environment**: Dev/staging/production patterns
- **Advanced Okta**: Policies, authentication, and security features

## 📝 Feedback

Your feedback helps improve this lab for future participants:
- **What worked well?** 
- **What could be clearer?**
- **Which racing metaphors helped or hindered learning?**

---

**Ready to get started?** Navigate to `exercises/01-team-formation/` to begin.