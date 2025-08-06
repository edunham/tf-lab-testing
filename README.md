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
- Okta integrator account (see setup below)
- Basic familiarity with command line

### 🔧 Okta Integrator Account Setup

#### Step 1: Create Your Free Okta Integrator Account

1. **Visit** [developer.okta.com](https://developer.okta.com)
2. **Click "Sign Up"** in the top right corner
3. **Fill out the form**:
   - Email address
   - First and last name
   - Company (can use "Personal" or "Learning")
   - Country
4. **Choose "Integrator"** when asked about your role
5. **Complete email verification** - check your inbox and click the verification link
6. **Set your password** when prompted
7. **Choose your Okta domain** - this creates your unique organization URL like `dev-123456.okta.com`

**Important**: Write down your Okta domain URL - you'll need it for configuration!

#### Step 2: Access Your Okta Admin Console

1. **Sign in** to your new Okta organization using the URL from Step 1
2. **You should see the Okta Admin Dashboard** - this confirms your account is ready
3. **Note your org details** in the top-right corner:
   - Your email address
   - Your org domain (e.g., `dev-123456.okta.com`)

#### Step 3: Create an API Token

**What is an API token?** It's a credential that allows Terraform to manage your Okta organization programmatically.

1. **In the Okta Admin Console**, go to **Security** → **API** (in the left sidebar)
2. **Click the "Tokens" tab**
3. **Click "Create Token"**
4. **Enter a token name**: `Terraform Racing Lab` (or similar)
5. **Set IP restrictions**: For "API calls made with this token must originate from", select **"Any IP"**
   - ⚠️ **For labs only**: In production, you'd restrict to specific IP ranges
   - 📡 **Why "Any IP"**: Codespaces use dynamic IP addresses that change
6. **Click "Create Token"**
7. **IMMEDIATELY COPY THE TOKEN** - this is the only time you'll see it!
   - It looks like: `00abc123def456ghi789jkl012mno345pqr678stu`
   - Store it somewhere safe (password manager, secure note, etc.)

**⚠️ Security Note**: Treat this token like a password - don't share it or commit it to git!

#### Step 4: Understand Your Okta URLs

Your Okta organization has specific URL formats:

- **Full Org URL**: `https://dev-123456.okta.com` (what you see in the browser)
- **Org Name**: `dev-123456` (the part before `.okta.com`)
- **Base URL**: `okta.com`


### Launch Environment
1. **Open in Codespaces**: Click the green "Code" button → "Codespaces" → "Create codespace"
2. **Wait for setup**: The devcontainer will automatically install Terraform and configure your environment
3. **Verify installation**: Run `terraform --version` in the terminal

### 🔐 Set Up Your Racing Lab Credentials (Secure Method)

**⚠️ SECURITY NOTICE**: Never expose API tokens in your terminal history or commit them to git!

GitHub Codespaces provides **secure secrets management** for sensitive data like API tokens. Use this secure method:

#### **Method 1: GitHub Codespaces Secrets (Recommended)**

1. **Create your Codespaces secrets**:
   - Go to **GitHub.com** → **Settings** (your profile) → **Codespaces**
   - Click **"New secret"** and create these three secrets:

   | Secret Name | Value | Example |
   |-------------|-------|---------|
   | `OKTA_ORG_NAME` | Your org name (before .okta.com) | `dev-123456` |
   | `OKTA_BASE_URL` | Your base URL | `okta.com` |
   | `OKTA_API_TOKEN` | Your API token from Step 3 | `00abc123def456...` |

2. **Grant repository access**:
   - For each secret, select this repository in "Repository access"
   - Click **"Add secret"**

3. **Restart your Codespace** to load the secrets:
   - In VS Code: `Ctrl+Shift+P` → "Codespaces: Stop Current Codespace"
   - Then restart it from GitHub.com

4. **Verify secrets are loaded** (they'll be available as environment variables):
   ```bash
   echo "Org: $OKTA_ORG_NAME"
   echo "Base URL: $OKTA_BASE_URL" 
   echo "Token loaded: $([ -n "$OKTA_API_TOKEN" ] && echo "✅ Yes" || echo "❌ No")"
   ```

#### **Method 2: Temporary Setup (Less Secure)**

⚠️ **Only use this for testing** - secrets won't persist and may be exposed in terminal history:

```bash
# Set temporarily (will be lost when codespace restarts)
read -s -p "Enter your OKTA_ORG_NAME: " OKTA_ORG_NAME && export OKTA_ORG_NAME
read -s -p "Enter your OKTA_BASE_URL: " OKTA_BASE_URL && export OKTA_BASE_URL  
read -s -p "Enter your OKTA_API_TOKEN: " OKTA_API_TOKEN && export OKTA_API_TOKEN
echo "Credentials set temporarily"
```

#### **Verify Your Connection**
```bash
# Test that your credentials work
curl -H "Authorization: SSWS $OKTA_API_TOKEN" \
     "https://$OKTA_ORG_NAME.$OKTA_BASE_URL/api/v1/users/me"
```

**Expected result**: You should see JSON data about your user account.

### 🏁 Test Your Setup

Before starting the exercises, let's verify everything works:

```bash
# Navigate to the first exercise
cd exercises/01-team-formation

# Initialize Terraform (downloads the Okta provider)
terraform init

# Test your configuration (should show 4 groups to be created)
terraform plan
```

**Expected output**: You should see a plan to create 4 Okta groups (racing teams) with no errors.

**If you see errors**, check the troubleshooting section below or verify your credentials.

## 🚀 Guided Learning with CodeTour

This lab includes **interactive guided tours** that walk you through the code step-by-step:

### 🎯 Available Tours

1. **🏁 F1 Terraform Basics** - Start here! Learn fundamental concepts
2. **🏎️ Team Formation** - Exercise 1 walkthrough
3. **👥 Driver Management** - Exercise 2 walkthrough

### 📱 How to Use CodeTour

**In VS Code (Codespaces) - Multiple Ways to Start:**

#### **Method 1: Via the Hamburger Menu** (Best for browsers)
1. **Click the 3 horizontal lines** ☰ at the top-left of VS Code
2. **Select "View"** from the dropdown menu
3. **Select "Command Palette"** from the submenu
4. **Type "CodeTour"** in the search box
5. **Select "CodeTour: Start Tour"** from the results
6. **Choose your tour** from the list

#### **Method 2: Using the Explorer Panel**
1. **Click the Explorer icon** 📁 in the left sidebar (first icon in Activity Bar)
2. **Look for "CODETOUR" section** in the Explorer panel (below your file tree)
3. **Click the ▶️ play button** next to any available tour
4. **Choose your tour** from the list

**Note**: CodeTour section only appears when the extension is installed and `.tour` files are detected

#### **Method 3: Keyboard Shortcut** (May not work in browsers)
- **Keyboard**: Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac)
- **Type "CodeTour"** and select **"CodeTour: Start Tour"**
- **Choose from the available tours**

### **During Tours:**
- **Next step**: Click the "Next" button or press `→` (right arrow)
- **Previous step**: Click "Previous" or press `←` (left arrow) 
- **Exit tour**: Click the "×" button or press `Escape`
- **Tour controls**: Tours appear as a sidebar panel with step-by-step guidance
- **File navigation**: Tours automatically highlight relevant code and switch files

### 🏁 Recommended Learning Path

1. **Start with "F1 Terraform Basics"** - Essential concepts overview
2. **Follow with exercise-specific tours** as you work through labs
3. **Use tours as reference** when you need explanations

**Pro tip**: You can start/stop tours anytime and resume where you left off!

### 🔧 CodeTour Troubleshooting

**Don't see the CODETOUR section in Explorer?**
- ✅ **Check extension is installed**: Look for "CodeTour" in VS Code Extensions panel
- ✅ **Refresh the window**: Press `F5` or reload the Codespace
- ✅ **Verify tour files exist**: Check that `.tours/` directory contains `.tour` files
- ✅ **Try Command Palette**: Use Method 1 above as backup

**Tours not loading?**
- 🔄 **Reload window**: `Ctrl+Shift+P` → "Developer: Reload Window"
- 🔄 **Check file permissions**: Ensure `.tour` files are readable
- 🔄 **Restart Codespace**: Close and reopen from GitHub

**Can't start a tour?**
- 📝 **Use Command Palette**: Most reliable method across all environments
- 📝 **Check workspace**: Ensure you're in the `terraform-101-okta` directory
- 📝 **Manual navigation**: Open tour files directly from `.tours/` folder

## 🏁 Progressive Learning with Modules

This lab now uses a **module-based architecture** that demonstrates production-quality Terraform patterns!

### 🏎️ Exercise 1: Racing Teams Module (20 minutes)
**Learn**: Module basics, single state management, variable-driven configuration

Deploy F1 racing teams using the `racing-teams` module:
- Start with `enable_drivers = false` in `terraform.tfvars`
- Create four teams: Velocity Racing, Thunder Motors, Phoenix Speed, Storm Racing
- Observe clean module outputs and single state file

**Key Concepts**: Module composition, variable patterns, progressive deployment

### 🏎️ Exercise 2: Racing Drivers Module (25 minutes)  
**Learn**: Module dependencies, conditional deployment, real-world patterns

Add drivers using the `racing-drivers` module:
- Set `enable_drivers = true` in `terraform.tfvars`
- Watch how modules pass data between each other
- See drivers automatically assigned to their teams

**Key Concepts**: Module dependencies, conditional resources, output composition

### 🏎️ What Makes This Special
✅ **Single State File**: All resources managed in one state (best practice!)
✅ **Module Dependencies**: See how `racing-drivers` depends on `racing-teams` outputs
✅ **Progressive Deployment**: Deploy teams first, then drivers - real-world pattern
✅ **Production Patterns**: Code structure you'd use in actual projects

## 📁 Repository Structure

```
terraform-101-okta/
├── README.md                    # This file - updated for module architecture
├── main.tf                      # Root configuration - orchestrates modules
├── variables.tf                 # All input variables
├── outputs.tf                   # All outputs from modules  
├── terraform.tfvars.example    # Progressive deployment examples
├── modules/                     # 🆕 Production-quality modules
│   ├── racing-teams/           # Creates F1 teams as Okta groups
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── racing-drivers/         # Creates drivers and team assignments
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── exercises/                   # 📁 Original step-by-step exercises (legacy)
│   ├── 01-team-formation/      # Now superseded by modules approach
│   └── 02-driver-roster/       # Now superseded by modules approach
├── .devcontainer/              # Codespaces configuration
├── solutions/                   # Complete solutions (future)
└── .tours/                      # Interactive CodeTour guides
```

**🚀 New Module-Based Approach**: The lab now demonstrates production-ready patterns with proper module structure!

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
2. **Stay in the root directory**: Work directly from `terraform-101-okta/` (no cd needed!)
3. **Copy configuration**: `cp terraform.tfvars.example terraform.tfvars`
4. **Start with teams**: Ensure `enable_drivers = false` in `terraform.tfvars`
5. **Initialize and deploy**: `terraform init && terraform apply`
6. **Progress to drivers**: Set `enable_drivers = true` and `terraform apply` again

**🎯 That's it!** You'll experience both modules deploying in a single, cohesive workflow.

## 🔧 Troubleshooting

### Okta Account & Credentials Issues

**"Invalid credentials" or "Authentication failed"**
- **Check your API token**: Make sure you copied the full token correctly
- **Verify environment variables**: Run `echo $OKTA_API_TOKEN` to see if it's set
- **Test with curl**: Use the connection test command from setup above
- **Token might be expired**: API tokens don't expire, but they can be deactivated

**"Could not resolve host" or connection errors**
- **Check your org name**: Run `echo $OKTA_ORG_NAME` - should be just `dev-123456`, not the full URL
- **Check your base URL**: Run `echo $OKTA_BASE_URL` - should be `okta.com` for integrator accounts
- **Verify your org is active**: Try logging into the Okta admin console manually

**"Insufficient permissions" errors**
- **Integrator accounts have full admin**: This shouldn't happen with developer.okta.com accounts
- **Check if you're using a work Okta account**: Work accounts may have restricted permissions
- **Solution**: Use a developer.okta.com account for this lab

**"API token not found" in Okta console**
- **Tokens are permanent**: Once created, they don't disappear unless deleted
- **Check the right org**: Make sure you're logged into the same org you created the token in
- **Multiple orgs**: You might have multiple Okta orgs - verify you're in the right one

### Terraform Issues

**"terraform: command not found"**
- **Wait for setup**: Codespaces may still be installing dependencies
- **Restart terminal**: Close and open a new terminal
- **Manual install**: Run `terraform --version` to check if it's installed

**"Resource already exists"**
- **Someone else used the same names**: Groups with the same name already exist in your org
- **Solution 1**: Delete the existing groups in Okta admin console
- **Solution 2**: Modify the group names in the terraform files
- **Solution 3**: Import existing resources: `terraform import okta_group.velocity_racing <group-id>`

**"Provider configuration not found"**
- **Run terraform init**: Make sure you've initialized the workspace
- **Check working directory**: Make sure you're in the exercise directory
- **Provider installation failed**: Delete `.terraform/` and run `terraform init` again

**"Terraform state issues"**
- **Corrupted state**: Delete `.terraform/` directory and run `terraform init` again
- **State/reality mismatch**: Run `terraform refresh` to sync state with actual resources
- **Start fresh**: Delete `terraform.tfstate` and `terraform.tfstate.backup` (be careful!)

### Environment & Setup Issues

**Environment variables don't persist**
- **Temporary**: Environment variables only last for the current terminal session
- **Make permanent**: Use the `.bashrc` commands from the setup section
- **Restart terminal**: Close and open terminal after modifying `.bashrc`

**Codespaces not starting correctly**
- **Rebuild container**: In VS Code command palette, run "Codespaces: Rebuild Container"
- **Check creation logs**: Look for errors in the setup process
- **Try different browser**: Sometimes browser issues can cause problems

**VS Code extensions not working**
- **Terraform extension issues**: Check that HashiCorp Terraform extension is installed
- **Restart VS Code**: Reload the window or restart VS Code
- **Check extension settings**: Make sure terraform language server is enabled

### Getting Help

- **During workshop**: Raise your hand or ask in chat
- **After workshop**: Check the solutions/ directory for complete examples
- **Terraform docs**: https://registry.terraform.io/providers/okta/okta/latest/docs
- **Okta developer docs**: https://developer.okta.com/

## 🔒 Security Best Practices

### **Secrets Management**
- ✅ **Use GitHub Codespaces secrets** for API tokens and sensitive data
- ✅ **Never commit secrets** to git repositories  
- ✅ **Limit secret access** to only repositories that need them
- ❌ **Avoid export commands** in terminal (they expose secrets in history)
- ❌ **Don't share codespaces** with secrets loaded

### **Okta Security**
- 🔑 **Use integrator accounts** (developer.okta.com) for labs - they're isolated
- 🔑 **Rotate API tokens** regularly in production environments
- 🔑 **Restrict API token IPs** in production - only allow necessary IP ranges
- 🔑 **Use least-privilege access** - only grant permissions needed for the task
- 🔑 **Monitor audit logs** in real Okta environments

### **Terraform Security**
- 📁 **Use `.gitignore`** to exclude `terraform.tfvars` and state files
- 📁 **Enable state locking** in team environments
- 📁 **Review plans carefully** before applying changes
- 📁 **Use remote state** for production workloads

### **If You Suspect Secrets Are Compromised**
1. **Immediately revoke** the API token in Okta console
2. **Create a new token** with a different name
3. **Update your Codespaces secrets** with the new token
4. **Check audit logs** for unauthorized activity

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
