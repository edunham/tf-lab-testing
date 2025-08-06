# Racing Drivers Module
# This module creates racing drivers and assigns them to teams
# Demonstrates: conditional resources, data processing, module dependencies

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
  }
}

# Create Racing Drivers using for_each
# This demonstrates variable-driven resource creation
resource "okta_user" "racing_drivers" {
  for_each = var.create_drivers ? var.drivers : {}

  first_name = each.value.first_name
  last_name  = each.value.last_name
  login      = "${each.value.first_name}.${each.value.last_name}@${each.value.email_domain}"
  email      = "${each.value.first_name}.${each.value.last_name}@${each.value.email_domain}"

  # Note: Custom profile attributes would require schema definition first
  # For this educational lab, we keep the user profile simple and standard
}

# BEST PRACTICE: Assign Drivers to Teams using Group Memberships
# This demonstrates resource dependencies and proper module integration
resource "okta_group_memberships" "team_memberships" {
  for_each = var.create_drivers ? local.driver_team_assignments : {}

  group_id = each.value.group_id
  users    = [okta_user.racing_drivers[each.key].id]
}

# BEST PRACTICE: Use locals for computed values and business logic
locals {
  # Create a map of driver keys to their team group IDs
  # This uses the team_ids passed from the racing-teams module
  driver_team_assignments = {
    for driver_key, driver in var.drivers : driver_key => {
      driver_name = "${driver.first_name} ${driver.last_name}"
      team_name   = driver.team
      group_id    = var.team_ids[driver.team]
    }
  }

  # Calculate total drivers
  total_drivers = length(var.drivers)

  # Group drivers by team using the valid teams list
  drivers_by_team = {
    for team in keys(var.team_ids) : team => [
      for driver_key, driver in var.drivers : driver_key
      if driver.team == team
    ]
  }

  # Calculate team statistics
  team_stats = {
    for team in keys(var.team_ids) : team => {
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