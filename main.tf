# Terraform 101 with Okta - Main Configuration
# This demonstrates progressive infrastructure deployment using modules
# 
# Exercise Progression:
# 1. Deploy teams only (set enable_drivers = false)
# 2. Enable drivers to see full infrastructure (set enable_drivers = true)
#
# This approach demonstrates:
# - Module composition and dependencies
# - Progressive infrastructure deployment
# - Single state file management (best practice)
# - Real-world project structure

# Configure Terraform and the Okta provider
terraform {
  required_version = ">= 1.0"

  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
  }
}

# Configure the Okta Provider
# Authentication happens through environment variables:
# - OKTA_ORG_NAME: your Okta organization name
# - OKTA_BASE_URL: oktapreview.com (for lab orgs) or okta.com (for personal accounts)  
# - OKTA_API_TOKEN: your API token
provider "okta" {
  # All configuration comes from environment variables
  # This keeps sensitive information out of our code
}

# EXERCISE 1: Racing Teams Module
# This module creates the F1 racing teams as Okta groups
# Students start here to learn basic module usage
module "racing_teams" {
  source = "./modules/racing-teams"

  racing_season        = var.racing_season
  racing_teams         = var.racing_teams
  league_configuration = var.league_configuration
}

# EXERCISE 2: Racing Drivers Module (Conditional)
# This module creates drivers and assigns them to teams
# Students enable this after understanding the teams module
# Demonstrates module dependencies and conditional deployment
module "racing_drivers" {
  source = "./modules/racing-drivers"

  # BEST PRACTICE: Conditional module execution
  count = var.enable_drivers ? 1 : 0

  create_drivers = var.create_example_drivers
  racing_season  = var.racing_season
  drivers        = var.drivers

  # BEST PRACTICE: Pass outputs from one module to another
  team_ids   = module.racing_teams.team_ids
  team_names = module.racing_teams.team_names
}

# BEST PRACTICE: Use locals for complex logic and computed values
locals {
  # Determine if drivers module is active
  drivers_module_active = var.enable_drivers && var.create_example_drivers

  # Get driver outputs safely (handles when module isn't deployed)
  driver_outputs = var.enable_drivers ? module.racing_drivers[0] : null

  # Common tags for all resources (if provider supported them)
  common_tags = {
    Environment = "terraform-101-lab"
    Purpose     = "education"
    Season      = var.racing_season
    League      = var.league_configuration.name
  }
}