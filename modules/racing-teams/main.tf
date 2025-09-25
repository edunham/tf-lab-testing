# Racing Teams Module
# This module creates and manages F1 racing teams as Okta groups
# Demonstrates: resource creation, for_each patterns, locals usage

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
  }
}

# Create Racing Teams using for_each for scalable, maintainable code
#
#

resource "okta_group" "racing_teams" {
  for_each = var.racing_teams

  # Use descriptive, consistent naming
  name = each.value.display_name

  # Build descriptions from structured data
  description = "${each.value.description} | Team Principal: ${each.value.team_principal} | Home Circuit: ${each.value.home_circuit} | Specialty: ${title(replace(each.value.specialty, "_", " "))} | Season: ${var.racing_season}"
}

# Use locals for computed values and business logic
#
locals {
  # Calculate values dynamically
  total_teams = length(var.racing_teams)

  # Build comprehensive team summary from variable data and resource attributes
  team_summary = {
    for team_key, team_config in var.racing_teams : team_key => {
      group_id       = okta_group.racing_teams[team_key].id
      group_name     = okta_group.racing_teams[team_key].name
      specialty      = team_config.specialty
      team_principal = team_config.team_principal
      home_circuit   = team_config.home_circuit
      team_color     = team_config.team_color
      founded_year   = team_config.founded_year
    }
  }

  # Add useful computed values for outputs and other resources
  teams_by_specialty = {
    for specialty in distinct([for team in var.racing_teams : team.specialty]) : specialty => [
      for team_key, team in var.racing_teams : team_key
      if team.specialty == specialty
    ]
  }

  # Consistent tagging strategy (would be used if Okta supported tags)
  common_tags = {
    Environment = "lab"
    Purpose     = "terraform-101"
    Season      = var.racing_season
    League      = var.league_configuration.name
  }

  # Create lookup maps for other modules to use
  team_id_map = {
    for team_key, team_config in var.racing_teams : team_key => okta_group.racing_teams[team_key].id
  }

  team_display_names = {
    for team_key, team_config in var.racing_teams : team_key => team_config.display_name
  }
}