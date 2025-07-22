# 🏁 Exercise 1: Team Formation

**Learning Goal**: Master Terraform basics by creating racing teams as Okta groups.

**Time Estimate**: 30 minutes

**What You'll Learn**:
- Terraform workflow: `init`, `plan`, `apply`
- Basic Terraform syntax and structure
- Okta provider and group resources
- Infrastructure as Code fundamentals

## 🏎️ The Racing Scenario

You're the infrastructure engineer for the **Formula Infrastructure Racing League**. Your first task is to set up identity management for four racing teams competing in this season's championship:

- **Velocity Racing** - Speed-focused team (aerodynamics specialists)
- **Thunder Motors** - Power-focused team (engine performance experts)  
- **Phoenix Speed** - Precision-focused team (race strategy masters)
- **Storm Racing** - Strategy-focused team (weather condition specialists)

Each team needs their own Okta group for organizing access to racing systems.

## 🚀 Prerequisites

Before starting, make sure you have:
- [ ] Okta developer account (free at developer.okta.com)
- [ ] API token from your Okta account
- [ ] Environment variables set (see main README)

## 🏁 Exercise Steps

### Step 1: Set Up Your Workspace

First, let's prepare your local environment:

```bash
# Navigate to this exercise directory
cd exercises/01-team-formation

# Check that you're in the right place
pwd
# Should show: .../terraform-101-okta/exercises/01-team-formation

# List the files we'll be working with
ls -la
```

### Step 2: Examine the Terraform Configuration

Look at the files in this directory:

```bash
# View the main configuration
cat main.tf

# View the variables
cat variables.tf

# View the outputs
cat outputs.tf
```

**🏎️ Racing Insight**: Notice how the configuration creates four teams with racing-specific metadata. This is Infrastructure as Code - we describe what we want, and Terraform makes it happen!

### Step 3: Initialize Terraform

Before we can create our racing teams, Terraform needs to download the Okta provider:

```bash
# Initialize Terraform (downloads providers and sets up workspace)
terraform init
```

**Expected Output**: You should see Terraform downloading the Okta provider and initializing the workspace.

**❓ What just happened?**
- Terraform downloaded the Okta provider plugin
- Created a `.terraform/` directory with provider files
- Created a `.terraform.lock.hcl` file to lock provider versions

### Step 4: Validate Your Configuration

Let's make sure our Terraform code is syntactically correct:

```bash
# Validate the configuration syntax
terraform validate
```

**Expected Output**: "Success! The configuration is valid."

**🔧 Troubleshooting**: If you see errors, check:
- File syntax (brackets, quotes, commas)
- Terraform block structure
- Variable references

### Step 5: Plan Your Infrastructure

Now let's preview what Terraform will create:

```bash
# Create an execution plan (preview changes)
terraform plan
```

**Expected Output**: Terraform will show you:
- 4 Okta groups to be created
- Details about each group's properties
- Summary: "Plan: 4 to add, 0 to change, 0 to destroy"

**🏎️ Racing Analogy**: Think of `terraform plan` as your race strategy meeting - you're planning every move before the race begins!

**📝 Exercise Questions**:
1. How many resources will Terraform create?
2. What are the names of the four teams?
3. Which team specializes in "weather_strategy"?

### Step 6: Create Your Racing Teams

Time to build your infrastructure! This will create the teams in your Okta organization:

```bash
# Apply the configuration (create the infrastructure)
terraform apply
```

**Important**: Terraform will ask for confirmation. Type `yes` to proceed.

**Expected Output**: 
- Terraform creates each group
- Shows progress as resources are created
- Displays "Apply complete! Resources: 4 added, 0 changed, 0 destroyed"

**🏁 Congratulations!** You just created your first infrastructure with Terraform!

### Step 7: Verify Your Work

Let's check what we created:

```bash
# Show the current state of our infrastructure
terraform show

# Display the output values
terraform output
```

**🔍 Verification Steps**:
1. **In Terraform**: The output should show details about your four racing teams
2. **In Okta**: Log into your Okta admin console and navigate to Groups - you should see your four racing teams!

### Step 8: Explore Your Infrastructure

Try these commands to learn more about your infrastructure:

```bash
# List all resources in the state
terraform state list

# Show details about a specific team
terraform state show 'okta_group.racing_teams["velocity-racing"]'

# See the execution plan again (should show no changes)
terraform plan
```

**💡 Key Insight**: Running `terraform plan` again shows "No changes" because our desired state (code) matches our actual state (Okta). This is the power of Infrastructure as Code!

## 🎯 Learning Checkpoints

Before moving on, make sure you understand:

### Terraform Workflow
- [ ] `terraform init` - Initialize workspace and download providers
- [ ] `terraform plan` - Preview changes before applying
- [ ] `terraform apply` - Create/update infrastructure
- [ ] `terraform show` - Display current state

### Infrastructure as Code Concepts
- [ ] **Declarative**: We describe the desired end state
- [ ] **Idempotent**: Running apply multiple times produces the same result
- [ ] **Version Control**: Infrastructure code can be tracked like application code
- [ ] **Reproducible**: Same code produces same infrastructure

### Terraform Syntax
- [ ] **Resources**: The `resource` blocks that create infrastructure
- [ ] **Providers**: The `provider` block that connects to Okta
- [ ] **Variables**: Making configuration flexible and reusable
- [ ] **Outputs**: Displaying useful information after creation

## 🏆 Challenge Exercises

Ready for more? Try these optional challenges:

### Challenge 1: Add a Fifth Team
1. Modify the variables to add "Lightning Speed" team
2. Use `terraform plan` to preview the addition
3. Apply the changes
4. Verify the new team appears in Okta

### Challenge 2: Modify Team Properties
1. Change Storm Racing's specialty from "weather_strategy" to "tire_strategy"
2. Plan and apply the change
3. Verify the update in Okta

### Challenge 3: Understand State Management
1. Look at the `terraform.tfstate` file (don't edit it!)
2. Compare it to what you see in `terraform show`
3. Understand that this file tracks what Terraform manages

## 🚧 Troubleshooting

### Common Issues

**"Invalid credentials" error**:
```bash
# Check your environment variables
echo $OKTA_ORG_NAME
echo $OKTA_BASE_URL
echo $OKTA_API_TOKEN
```

**"Resource already exists" error**:
- Someone else may have created groups with the same names
- Try modifying the team names in variables.tf

**"terraform: command not found"**:
- Make sure you're in the Codespaces environment
- Try reopening the terminal

### Getting Help
- Raise your hand during the workshop
- Check the main README troubleshooting section
- Use `terraform validate` to check syntax errors

## ✅ Exercise Complete!

**What You've Accomplished**:
- ✅ Created four racing teams using Terraform
- ✅ Learned the core Terraform workflow
- ✅ Understanding Infrastructure as Code principles
- ✅ Successfully managed Okta resources with code

**Next Steps**:
Once you're comfortable with team creation, proceed to **Exercise 2: Driver Management** where you'll add racing drivers to your teams and learn about variables, data sources, and resource dependencies.

## 🏁 Racing Wisdom

*"In racing, as in infrastructure, preparation and consistency win championships. You've just learned to prepare your infrastructure like a championship team prepares for race day!"*

---

**Ready to add some drivers to your teams?** Head to `../02-driver-roster/` when you're ready! 🏎️