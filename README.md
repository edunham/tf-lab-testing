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
- Okta integrator account (create at [developer.okta.com](https://developer.okta.com))
- Basic familiarity with command line

### Launch Environment
1. **Open in Codespaces**: Click the green "Code" button → "Codespaces" → "Create codespace"
2. **Wait for setup**: The devcontainer will automatically install Terraform and configure your environment
3. **Verify installation**: Run `terraform --version` in the terminal

## 🚀 Guided Learning with CodeTour

This lab includes **interactive guided tours** that walk you through everything step-by-step. **All setup and exercises are covered in the tours** - no need to follow separate instructions!

### 🎯 Available Tours

1. **🔐 Sign in to your Okta training org** - Initial Okta setup (for instructor-provided accounts)
2. **🏁 F1 Terraform Basics** - Learn fundamentals and set up your credentials
3. **🏎️ Module-Based Team Formation** - Deploy racing teams (Exercise 1)
4. **👥 Progressive Driver Deployment** - Add drivers to teams (Exercise 2)

### 📱 How to Start Tours

**In VS Code (Codespaces):**

1. **Click the Explorer icon** 📁 in the left sidebar
2. **Look for "CODETOUR" section** in the Explorer panel (below your file tree)
3. **Click the ▶️ play button** next to any tour
4. **Follow the guided steps**

**Alternative method:**
- Press `Ctrl+Shift+P` → Type "CodeTour" → Select "CodeTour: Start Tour"

### 🏁 Recommended Learning Path

1. **Start with "F1 Terraform Basics"** if you have your own Okta account, or "Sign in to your Okta training org" if using instructor-provided credentials
2. **Follow the tours in order** - they build on each other
3. **Complete all exercises through the guided tours**

**🎯 The tours handle everything:** Okta setup, credential management, terraform commands, and verification steps!

## 📁 Repository Structure

```
terraform-101-okta/
├── README.md                    # This file - getting started guide
├── main.tf                      # Root configuration - orchestrates modules
├── variables.tf                 # All input variables
├── outputs.tf                   # All outputs from modules
├── terraform.tfvars.example    # Progressive deployment examples
├── modules/                     # Production-quality modules
│   ├── racing-teams/           # Creates F1 teams as Okta groups
│   └── racing-drivers/         # Creates drivers and team assignments
├── .devcontainer/              # Codespaces configuration
└── .tours/                      # Interactive CodeTour guides
```

## 🔧 Basic Troubleshooting

**Don't see the CODETOUR section in Explorer?**
- Check that "CodeTour" extension is installed in VS Code
- Refresh the window: Press `F5` or reload the Codespace
- Try Command Palette: `Ctrl+Shift+P` → "CodeTour: Start Tour"

**Environment variables not loading?**
- If using GitHub Codespaces secrets: Restart your Codespace
- Verify secrets are set at [GitHub Codespaces Settings](https://github.com/settings/codespaces)

**Terraform commands not working?**
- Wait for Codespace setup to complete
- Run `terraform --version` to verify installation
- Follow the guided troubleshooting in the tours

## 🎯 Next Steps

After completing the lab:
- **Terraform modules**: Reusable infrastructure components
- **Remote state**: Team collaboration with shared state
- **CI/CD integration**: Automated terraform in pipelines
- **Multi-environment**: Dev/staging/production patterns

---

**🏁 Ready to race?** Start your CodeTour journey and learn Infrastructure as Code with Formula 1 flair!
