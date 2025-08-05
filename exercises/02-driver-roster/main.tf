# Exercise 2: Driver Roster - Main Configuration
# This exercise focuses on variables, data sources, and resource dependencies
# We'll create racing drivers and assign them to teams from Exercise 1

# Configure Terraform and required providers
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
provider "okta" {
  # Authentication through environment variables:
  # - OKTA_ORG_NAME, OKTA_BASE_URL, OKTA_API_TOKEN
}

# BEST PRACTICE: Use data sources to reference existing infrastructure
# This demonstrates building on previous Exercise 1 infrastructure
# Data sources are preferred over hard-coding for dependencies

data "okta_group" "racing_teams" {
  for_each = var.team_display_names
  name     = each.value
}

# Create Racing Drivers using for_each
# This demonstrates variable-driven resource creation
resource "okta_user" "racing_drivers" {
  for_each = var.create_example_drivers ? var.drivers : {}

  first_name = each.value.first_name
  last_name  = each.value.last_name
  login      = "${each.value.first_name}.${each.value.last_name}@${each.value.email_domain}"
  email      = "${each.value.first_name}.${each.value.last_name}@${each.value.email_domain}"

  # Note: Custom profile attributes would require schema definition first
  # For this educational lab, we keep the user profile simple and standard
}

# Assign Drivers to Teams using Group Memberships
# This demonstrates resource dependencies and data source usage
resource "okta_group_memberships" "team_memberships" {
  for_each = var.create_example_drivers ? local.driver_team_assignments : {}

  group_id = each.value.group_id
  users    = [okta_user.racing_drivers[each.key].id]
}

# Local Values for Organization and Computation
# This demonstrates computed values and DRY principles
locals {
  # BEST PRACTICE: Use dynamic lookups instead of hard-coded conditionals
  # This creates a map from team identifiers to their actual group IDs
  team_id_map = {
    for team_key, team_name in var.team_display_names : team_key => data.okta_group.racing_teams[team_key].id
  }

  # Create a map of driver keys to their team group IDs
  driver_team_assignments = {
    for driver_key, driver in var.drivers : driver_key => {
      driver_name = "${driver.first_name} ${driver.last_name}"
      team_name   = driver.team
      group_id    = local.team_id_map[driver.team]
    }
  }

  # Calculate total drivers
  total_drivers = length(var.drivers)

  # Group drivers by team
  drivers_by_team = {
    for team in ["velocity-racing", "thunder-motors", "phoenix-speed", "storm-racing"] : team => [
      for driver_key, driver in var.drivers : driver_key
      if driver.team == team
    ]
  }

  # Calculate team statistics
  team_stats = {
    for team in ["velocity-racing", "thunder-motors", "phoenix-speed", "storm-racing"] : team => {
      driver_count = length(local.drivers_by_team[team])
      total_championships = sum([
        for driver_key in local.drivers_by_team[team] : var.drivers[driver_key].championships
      ])
      avg_championships = length(local.drivers_by_team[team]) > 0 ? (
        sum([for driver_key in local.drivers_by_team[team] : var.drivers[driver_key].championships]) /
        length(local.drivers_by_team[team])
      ) : 0
    }
  }
}

# Alternative approach using a more dynamic data source lookup
# This shows advanced terraform patterns (commented out for simplicity)
/*
locals {
  # Dynamic team lookup - more scalable but more complex
  team_data_sources = {
    "velocity-racing" = data.okta_group.velocity_racing
    "thunder-motors"  = data.okta_group.thunder_motors
    "phoenix-speed"   = data.okta_group.phoenix_speed
    "storm-racing"    = data.okta_group.storm_racing
  }
  
  # More dynamic driver team assignments
  driver_team_assignments_dynamic = {
    for driver_key, driver in var.drivers : driver_key => {
      driver_name = "${driver.first_name} ${driver.last_name}"
      team_name   = driver.team
      group_id    = local.team_data_sources[driver.team].id
    }
  }
}
*/