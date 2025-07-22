# 🏎️ Exercise 2: Driver Roster

**Learning Goal**: Master variables, data sources, and resource dependencies by adding racing drivers to teams.

**Time Estimate**: 20 minutes

**Prerequisites**: Complete Exercise 1 (Team Formation) first

**What You'll Learn**:
- Variables: types, validation, defaults
- Data sources: referencing existing resources
- Resource dependencies: how terraform manages creation order
- Locals: computed values and DRY principles
- For_each loops: creating multiple similar resources

## 🏆 The Racing Scenario

Your racing teams are formed, but they need drivers! You're tasked with recruiting and managing the driver roster for the **Formula Infrastructure Racing League**. Each team needs their star driver with proper credentials and team membership.

**Meet Your Drivers**:
- **Alex Speedwell** (#7) - Velocity Racing's aerodynamics specialist
- **Jordan Swift** (#23) - Thunder Motors' power specialist  
- **Casey Turbo** (#11) - Phoenix Speed's strategy expert
- **Riley Flash** (#44) - Storm Racing's weather master

## 🚀 Prerequisites Check

Before starting, verify you have Exercise 1 completed:

```bash
# Check that you have teams from Exercise 1
cd ../01-team-formation
terraform show | grep "okta_group"

# You should see 4 racing teams listed
# If not, complete Exercise 1 first
```

## 🏁 Exercise Steps

### Step 1: Navigate to Exercise 2

```bash
# Move to the driver roster exercise
cd ../02-driver-roster

# Check that you're in the right place
pwd
# Should show: .../exercises/02-driver-roster

# List the files we'll work with
ls -la
```

### Step 2: Examine the New Concepts

Look at the configuration files to understand the new concepts:

```bash
# View the main configuration (focus on new concepts)
cat main.tf

# Look at the variables (more complex than Exercise 1)
cat variables.tf

# Check the outputs (team and driver information)
cat outputs.tf
```

**🏎️ New Concepts to Notice**:
- **Data sources**: `data "okta_group"` - references teams created in Exercise 1
- **For_each loops**: `for_each = var.drivers` - creates multiple drivers from one resource block
- **Variables with objects**: Complex driver configuration with multiple attributes
- **Computed locals**: Calculating values from other values

### Step 3: Configure Your Driver Roster

Create your configuration file:

```bash
# Copy the example configuration
cp terraform.tfvars.example terraform.tfvars

# Edit with your preferences (optional)
# nano terraform.tfvars
```

**💡 Key Configuration Options**:
- `create_example_drivers`: Set to `true` to create the default drivers
- `driver_email_domain`: Customize email domains for your drivers
- `include_driver_metadata`: Add racing-specific profile information

### Step 4: Initialize and Plan

```bash
# Initialize terraform (may download additional providers)
terraform init

# Validate the configuration
terraform validate

# Plan the changes - see what will be created
terraform plan
```

**📊 Expected Plan Output**:
- 4 new Okta users (drivers)
- 4 new group memberships (assigning drivers to teams)
- Data sources will reference existing teams from Exercise 1

**🏎️ Racing Insight**: Notice how terraform automatically figures out the creation order - it needs to read the team data first, then create drivers, then assign memberships!

### Step 5: Create Your Driver Roster

```bash
# Apply the configuration
terraform apply

# Type 'yes' when prompted
```

**Expected Results**:
- 4 racing drivers created in your Okta organization
- Each driver assigned to their respective team
- Driver profiles include racing-specific metadata

### Step 6: Verify Your Work

```bash
# Show the current state
terraform show

# Display output values
terraform output

# Check specific driver information
terraform output racing_drivers
```

**🔍 Verification Steps**:
1. **In Terraform**: Outputs show 4 drivers with team assignments
2. **In Okta**: 
   - Navigate to Directory → People (see 4 new users)
   - Navigate to Directory → Groups (see team memberships)
   - Check user profiles for racing metadata

### Step 7: Explore Dependencies

Learn about terraform's dependency management:

```bash
# Show the dependency graph (if graphviz is available)
terraform graph

# List all resources
terraform state list

# Show details about a specific driver
terraform state show 'okta_user.racing_drivers["alex-speedwell"]'

# Show details about a group membership
terraform state show 'okta_group_memberships.team_memberships["alex-speedwell"]'
```

**🔧 Understanding Dependencies**:
- Terraform automatically detected that group memberships depend on both users and groups
- Data sources are read before resources are created
- `for_each` creates multiple resources from a single configuration block

### Step 8: Test Variable Concepts

Experiment with variables to understand their power:

```bash
# Show current variable values
terraform console
# In console, try:
# var.drivers
# var.create_example_drivers
# local.driver_team_assignments
# exit
```

**📚 Variable Concepts Demonstrated**:
- **Object variables**: Complex driver configurations
- **Validation**: Ensuring driver numbers are valid
- **Defaults**: Sensible fallbacks for optional settings
- **Locals**: Computed values for organization

## 🎯 Learning Checkpoints

Before moving on, make sure you understand:

### Variables and Configuration
- [ ] **Object variables**: How to structure complex configuration
- [ ] **Variable validation**: Ensuring inputs meet requirements
- [ ] **Default values**: Making variables optional with good defaults
- [ ] **Variable precedence**: How terraform.tfvars overrides defaults

### Data Sources and Dependencies
- [ ] **Data sources**: Reading existing infrastructure
- [ ] **Implicit dependencies**: Terraform figuring out creation order
- [ ] **Resource references**: Using outputs from other resources
- [ ] **Cross-exercise dependencies**: Building on previous work

### Advanced Terraform Concepts
- [ ] **For_each loops**: Creating multiple resources efficiently
- [ ] **Locals**: Computing values from other values
- [ ] **Resource addressing**: How to reference specific resources
- [ ] **State management**: How terraform tracks relationships

## 🏆 Challenge Exercises

Ready to test your skills? Try these challenges:

### Challenge 1: Add a Reserve Driver
1. Add a fifth driver to the variables
2. Assign them to any team as a reserve
3. Plan and apply the changes
4. Verify the new driver appears in Okta

### Challenge 2: Modify Driver Metadata
1. Change Casey Turbo's racing style from "strategic" to "aggressive"
2. Update their preferred tire from "hard" to "medium"
3. Apply the changes and verify in Okta

### Challenge 3: Create a Multi-Driver Team
1. Modify the configuration to assign two drivers to Velocity Racing
2. Understand how group memberships work with multiple users
3. Apply and verify both drivers are in the same team

### Challenge 4: Cross-Reference Exercise Data
1. Use `terraform console` to explore the data sources
2. Find the team ID for "Storm Racing" using data sources
3. Verify it matches the ID from Exercise 1

## 🚧 Troubleshooting

### Common Issues

**"No matching groups found" error**:
```bash
# Verify Exercise 1 teams exist
cd ../01-team-formation
terraform show | grep "okta_group"

# If missing, run terraform apply in Exercise 1 first
```

**"Invalid driver number" validation error**:
- Check that driver numbers are 1-99
- Ensure no duplicate numbers in your configuration

**"Resource already exists" error**:
- Someone may have created users with the same names
- Try customizing the driver names in terraform.tfvars

**Group membership conflicts**:
- Ensure each driver is only assigned to one team
- Check for typos in team names

### Data Source Debugging

```bash
# Test data sources manually
terraform console
# Try: data.okta_group.existing_teams
# This shows what teams were found from Exercise 1
```

## ✅ Exercise Complete!

**What You've Accomplished**:
- ✅ Created racing drivers with complex profiles
- ✅ Learned variable types and validation
- ✅ Used data sources to reference existing infrastructure
- ✅ Implemented resource dependencies
- ✅ Mastered for_each loops and locals
- ✅ Built on previous exercise work

**Skills Gained**:
- Advanced terraform configuration patterns
- Variable-driven infrastructure design
- Cross-resource dependency management
- Data source integration
- Complex resource relationships

## 🎯 What's Next?

**Exercise 3: Race Operations** - Learn about:
- Okta applications and access control
- Advanced resource relationships
- Output organization and reporting
- Complete racing infrastructure management

## 🏁 Racing Wisdom

*"Great drivers aren't born, they're developed through practice and precision. You've just learned to develop infrastructure with the same attention to detail that champions bring to the track!"*

**Team rosters are set! Ready to deploy the racing applications?** 🏎️

---

**Continue to Exercise 3** when you're ready to complete your racing infrastructure with applications and access control!