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
7. **Choose your Okta domain** - this creates your unique organization URL like `dev-123456.oktapreview.com`

**Important**: Write down your Okta domain URL - you'll need it for configuration!

#### Step 2: Access Your Okta Admin Console

1. **Sign in** to your new Okta organization using the URL from Step 1
2. **You should see the Okta Admin Dashboard** - this confirms your account is ready
3. **Note your org details** in the top-right corner:
   - Your email address
   - Your org domain (e.g., `dev-123456.oktapreview.com`)

#### Step 3: Create an API Token

**What is an API token?** It's a credential that allows Terraform to manage your Okta organization programmatically.

1. **In the Okta Admin Console**, go to **Security** → **API** (in the left sidebar)
2. **Click the "Tokens" tab**
3. **Click "Create Token"**
4. **Enter a token name**: `Terraform Racing Lab` (or similar)
5. **Click "Create Token"**
6. **IMMEDIATELY COPY THE TOKEN** - this is the only time you'll see it!
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

### Set Up Your Racing Lab Credentials

Now configure Terraform to connect to your Okta organization:

1. **In your Codespaces terminal**, set these environment variables with YOUR values:

   ```bash
   # Replace with YOUR org name (the part before .oktapreview.com)
   export OKTA_ORG_NAME="dev-123456"
   
   # Use oktapreview.com for developer accounts (most common)
   export OKTA_BASE_URL="oktapreview.com"
   
   # Replace with YOUR API token from Step 3 above
   export OKTA_API_TOKEN="00abc123def456ghi789jkl012mno345pqr678stu"
   ```

2. **Verify your connection**:
   ```bash
   # Test that your credentials work
   curl -H "Authorization: SSWS $OKTA_API_TOKEN" \
        "https://$OKTA_ORG_NAME.$OKTA_BASE_URL/api/v1/users/me"
   ```

   **Expected result**: You should see JSON data about your user account.

3. **Make credentials persistent** (optional but recommended):
   ```bash
   # Add to your shell profile so they persist across terminal sessions
   echo "export OKTA_ORG_NAME=\"$OKTA_ORG_NAME\"" >> ~/.bashrc
   echo "export OKTA_BASE_URL=\"$OKTA_BASE_URL\"" >> ~/.bashrc
   echo "export OKTA_API_TOKEN=\"$OKTA_API_TOKEN\"" >> ~/.bashrc
   ```

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

#### **Method 1: Using the Command Palette**
- **Keyboard**: Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac)
- **Mouse Alternative**: Click the **gear icon** ⚙️ in the bottom-left corner → **"Command Palette"**
- Type "CodeTour" and select **"CodeTour: Start Tour"**
- Choose from the available tours

#### **Method 2: Using the Explorer Panel** (Recommended for browsers)
1. **Look for the CodeTour icon** 🗺️ in the left sidebar (Activity Bar)
2. **Click the CodeTour icon** to open the CodeTour panel
3. **Click "Start Tour"** next to any available tour
4. **Choose your tour** from the list

#### **Method 3: Via the View Menu**
- Click **"View"** in the top menu bar
- Select **"Command Palette"** from the dropdown
- Type "CodeTour" and select **"CodeTour: Start Tour"**

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

## 🏁 Exercises

### 🏎️ Exercise 1: Team Formation (30 minutes)
**Learn**: Basic Terraform workflow, providers, simple resources
**CodeTour**: Use "Team Formation" tour for guided walkthrough

Create four teams as Okta groups:
- Velocity Racing
- Thunder Motors 
- Phoenix Speed
- Storm Racing

**Key Concepts**: `terraform init`, `terraform plan`, `terraform apply`, basic resource syntax

### 🏎️ Exercise 2: Driver Roster (45 minutes)
**Learn**: Variables, locals, resource dependencies, data sources, for_each loops
**CodeTour**: Use "Driver Management" tour for guided walkthrough

Add racing drivers to your teams:
- Create users with racing-specific profiles
- Assign drivers to teams using group memberships
- Calculate team statistics and analytics

**Key Concepts**: `for_each`, data sources, complex locals, resource dependencies

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
│   ├── devcontainer.json       # Container setup
│   └── setup.sh                # Environment setup script
├── exercises/                   # Step-by-step exercises
│   ├── 01-team-formation/      # Exercise 1 - creating teams
│   └── 02-driver-roster/       # Exercise 2 - managing drivers
├── solutions/                   # Complete solutions (future)
└── .tours/                      # Interactive CodeTour guides
    ├── f1-terraform-basics.tour    # Fundamental concepts tour
    ├── team-formation.tour         # Exercise 1 guided walkthrough  
    └── driver-management.tour      # Exercise 2 guided walkthrough
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

### Okta Account & Credentials Issues

**"Invalid credentials" or "Authentication failed"**
- **Check your API token**: Make sure you copied the full token correctly
- **Verify environment variables**: Run `echo $OKTA_API_TOKEN` to see if it's set
- **Test with curl**: Use the connection test command from setup above
- **Token might be expired**: API tokens don't expire, but they can be deactivated

**"Could not resolve host" or connection errors**
- **Check your org name**: Run `echo $OKTA_ORG_NAME` - should be just `dev-123456`, not the full URL
- **Check your base URL**: Run `echo $OKTA_BASE_URL` - should be `oktapreview.com` for developer accounts
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
