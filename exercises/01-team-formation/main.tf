# Exercise 1: Team Formation - Main Configuration
# This exercise focuses on creating racing teams as Okta groups
# We'll start simple and build complexity in later exercises

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
# - OKTA_BASE_URL: okta.com or oktapreview.com  
# - OKTA_API_TOKEN: your API token
provider "okta" {
  # All configuration comes from environment variables
  # This keeps sensitive information out of our code
}

# Create Racing Teams as Okta Groups
# Each team represents a different racing organization with unique characteristics

resource "okta_group" "velocity_racing" {
  name        = "Velocity Racing"
  description = "Speed-focused racing team known for aerodynamic excellence and quick pit stops"
  
  # Optional: Custom attributes for racing-specific metadata
  # In a real scenario, these could drive access policies
  custom_profile_attributes = jsonencode({
    team_color      = "velocity-blue"
    team_principal  = "Sam Velocity"
    home_circuit    = "Monaco Street Circuit"
    specialty       = "aerodynamics"
    season          = "2024"
  })
}

resource "okta_group" "thunder_motors" {
  name        = "Thunder Motors"
  description = "Power-focused racing team specializing in engine performance and straight-line speed"
  
  custom_profile_attributes = jsonencode({
    team_color      = "thunder-red"
    team_principal  = "Alex Thunder"
    home_circuit    = "Monza Speedway"
    specialty       = "engine_performance"
    season          = "2024"
  })
}

resource "okta_group" "phoenix_speed" {
  name        = "Phoenix Speed"
  description = "Precision-focused racing team known for strategic race management and consistency"
  
  custom_profile_attributes = jsonencode({
    team_color      = "phoenix-orange"
    team_principal  = "Jordan Phoenix"
    home_circuit    = "Suzuka International"
    specialty       = "race_strategy"
    season          = "2024"
  })
}

resource "okta_group" "storm_racing" {
  name        = "Storm Racing"
  description = "Strategy-focused racing team excelling in wet weather conditions and adaptability"
  
  custom_profile_attributes = jsonencode({
    team_color      = "storm-purple"
    team_principal  = "Casey Storm"
    home_circuit    = "Silverstone Circuit"
    specialty       = "weather_strategy"
    season          = "2024"
  })
}

# Local values help organize and compute information
# Think of these as "calculated fields" based on our resources
locals {
  # Count total teams created
  total_teams = 4
  
  # Create a summary of all teams
  team_summary = {
    velocity_racing = {
      id           = okta_group.velocity_racing.id
      name         = okta_group.velocity_racing.name
      specialty    = "aerodynamics"
      team_principal = "Sam Velocity"
    }
    thunder_motors = {
      id           = okta_group.thunder_motors.id
      name         = okta_group.thunder_motors.name
      specialty    = "engine_performance"
      team_principal = "Alex Thunder"
    }
    phoenix_speed = {
      id           = okta_group.phoenix_speed.id
      name         = okta_group.phoenix_speed.name
      specialty    = "race_strategy"
      team_principal = "Jordan Phoenix"
    }
    storm_racing = {
      id           = okta_group.storm_racing.id
      name         = okta_group.storm_racing.name
      specialty    = "weather_strategy"
      team_principal = "Casey Storm"
    }
  }
}