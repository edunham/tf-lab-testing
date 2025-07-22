# Terraform 101 Racing Lab - Main Configuration
# This file defines the core infrastructure for our racing team identity management

# Configure Terraform settings and required providers
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
# The provider handles authentication and communication with Okta's API
provider "okta" {
  # Authentication is handled via environment variables:
  # OKTA_ORG_NAME, OKTA_BASE_URL, OKTA_API_TOKEN
  # This keeps sensitive credentials out of our code
}

# Racing Teams - Create groups for each team in our racing organization
# Each team will have different access to racing applications and data
# This uses variables to make the configuration flexible and reusable

resource "okta_group" "racing_teams" {
  for_each = var.team_principals
  
  name        = title(replace(each.key, "-", " "))
  description = "${each.value.specialty} focused racing team managed by ${each.value.name}${var.okta_group_description_suffix}"
  
  # Custom attributes for racing-specific metadata
  custom_profile_attributes = jsonencode({
    team_color      = var.team_colors[each.key]
    team_principal  = each.value.name
    home_circuit    = var.home_circuits[each.key]
    specialty       = each.value.specialty
    experience_years = each.value.experience_years
    season          = var.racing_season
  })
}

# Racing Drivers - Create users for our team drivers
# Each driver belongs to a specific team and has racing-specific profile data

resource "okta_user" "alex_speedwell" {
  first_name = "Alex"
  last_name  = "Speedwell"
  login      = "alex.speedwell@velocityracing.com"
  email      = "alex.speedwell@velocityracing.com"
  
  custom_profile_attributes = jsonencode({
    driver_number    = "7"
    racing_team      = "Velocity Racing"
    championships    = "2"
    preferred_tire   = "soft"
    racing_style     = "aggressive"
  })
}

resource "okta_user" "jordan_swift" {
  first_name = "Jordan"
  last_name  = "Swift"
  login      = "jordan.swift@thundermotors.com"
  email      = "jordan.swift@thundermotors.com"
  
  custom_profile_attributes = jsonencode({
    driver_number    = "23"
    racing_team      = "Thunder Motors"
    championships    = "1"
    preferred_tire   = "medium"
    racing_style     = "calculated"
  })
}

resource "okta_user" "casey_turbo" {
  first_name = "Casey"
  last_name  = "Turbo"
  login      = "casey.turbo@phoenixspeed.com"
  email      = "casey.turbo@phoenixspeed.com"
  
  custom_profile_attributes = jsonencode({
    driver_number    = "11"
    racing_team      = "Phoenix Speed"
    championships    = "0"
    preferred_tire   = "hard"
    racing_style     = "strategic"
  })
}

resource "okta_user" "riley_flash" {
  first_name = "Riley"
  last_name  = "Flash"
  login      = "riley.flash@stormracing.com"
  email      = "riley.flash@stormracing.com"
  
  custom_profile_attributes = jsonencode({
    driver_number    = "44"
    racing_team      = "Storm Racing"
    championships    = "3"
    preferred_tire   = "intermediate"
    racing_style     = "adaptive"
  })
}

# Team Memberships - Assign drivers to their respective teams
# This creates the organizational structure for access control

resource "okta_group_memberships" "velocity_racing_members" {
  group_id = okta_group.velocity_racing.id
  users = [
    okta_user.alex_speedwell.id
  ]
}

resource "okta_group_memberships" "thunder_motors_members" {
  group_id = okta_group.thunder_motors.id
  users = [
    okta_user.jordan_swift.id
  ]
}

resource "okta_group_memberships" "phoenix_speed_members" {
  group_id = okta_group.phoenix_speed.id
  users = [
    okta_user.casey_turbo.id
  ]
}

resource "okta_group_memberships" "storm_racing_members" {
  group_id = okta_group.storm_racing.id
  users = [
    okta_user.riley_flash.id
  ]
}

# Racing Applications - Create applications that teams will use
# These represent the digital tools our racing teams need access to

resource "okta_app_oauth" "race_dashboard" {
  label                     = "Race Dashboard"
  type                      = "web"
  grant_types               = ["authorization_code"]
  redirect_uris             = ["https://race-dashboard.racing.local/callback"]
  response_types            = ["code"]
  token_endpoint_auth_method = "client_secret_basic"
  
  # Application metadata for racing context
  custom_profile_attributes = jsonencode({
    app_type        = "racing_telemetry"
    data_sensitivity = "high"
    real_time       = true
    description     = "Real-time race telemetry and live timing data for teams and drivers"
  })
}

resource "okta_app_oauth" "timing_portal" {
  label                     = "Timing Portal"
  type                      = "web"
  grant_types               = ["authorization_code"]
  redirect_uris             = ["https://timing-portal.racing.local/callback"]
  response_types            = ["code"]
  token_endpoint_auth_method = "client_secret_basic"
  
  custom_profile_attributes = jsonencode({
    app_type        = "timing_system"
    data_sensitivity = "medium"
    real_time       = true
    description     = "Lap timing analysis and sector performance tracking"
  })
}

resource "okta_app_oauth" "team_communication" {
  label                     = "Team Communication"
  type                      = "web"
  grant_types               = ["authorization_code"]
  redirect_uris             = ["https://team-comm.racing.local/callback"]
  response_types            = ["code"]
  token_endpoint_auth_method = "client_secret_basic"
  
  custom_profile_attributes = jsonencode({
    app_type        = "communication"
    data_sensitivity = "high"
    real_time       = true
    description     = "Secure team communications between pit wall and drivers"
  })
}

resource "okta_app_oauth" "data_analytics" {
  label                     = "Data Analytics"
  type                      = "web"
  grant_types               = ["authorization_code"]
  redirect_uris             = ["https://analytics.racing.local/callback"]
  response_types            = ["code"]
  token_endpoint_auth_method = "client_secret_basic"
  
  custom_profile_attributes = jsonencode({
    app_type        = "analytics"
    data_sensitivity = "medium"
    real_time       = false
    description     = "Historical performance data and strategic race analysis"
  })
}

# Application Assignments - Give teams access to racing applications
# This implements our access control policy for the racing organization

# All teams get access to basic race dashboard
resource "okta_app_group_assignment" "race_dashboard_velocity" {
  app_id   = okta_app_oauth.race_dashboard.id
  group_id = okta_group.velocity_racing.id
}

resource "okta_app_group_assignment" "race_dashboard_thunder" {
  app_id   = okta_app_oauth.race_dashboard.id
  group_id = okta_group.thunder_motors.id
}

resource "okta_app_group_assignment" "race_dashboard_phoenix" {
  app_id   = okta_app_oauth.race_dashboard.id
  group_id = okta_group.phoenix_speed.id
}

resource "okta_app_group_assignment" "race_dashboard_storm" {
  app_id   = okta_app_oauth.race_dashboard.id
  group_id = okta_group.storm_racing.id
}

# Teams get access to timing portal based on their focus
resource "okta_app_group_assignment" "timing_portal_velocity" {
  app_id   = okta_app_oauth.timing_portal.id
  group_id = okta_group.velocity_racing.id
}

resource "okta_app_group_assignment" "timing_portal_thunder" {
  app_id   = okta_app_oauth.timing_portal.id
  group_id = okta_group.thunder_motors.id
}

# Team communication for coordination
resource "okta_app_group_assignment" "team_comm_velocity" {
  app_id   = okta_app_oauth.team_communication.id
  group_id = okta_group.velocity_racing.id
}

resource "okta_app_group_assignment" "team_comm_thunder" {
  app_id   = okta_app_oauth.team_communication.id
  group_id = okta_group.thunder_motors.id
}

resource "okta_app_group_assignment" "team_comm_phoenix" {
  app_id   = okta_app_oauth.team_communication.id
  group_id = okta_group.phoenix_speed.id
}

resource "okta_app_group_assignment" "team_comm_storm" {
  app_id   = okta_app_oauth.team_communication.id
  group_id = okta_group.storm_racing.id
}

# Data analytics for strategy teams (Phoenix and Storm)
resource "okta_app_group_assignment" "analytics_phoenix" {
  app_id   = okta_app_oauth.data_analytics.id
  group_id = okta_group.phoenix_speed.id
}

resource "okta_app_group_assignment" "analytics_storm" {
  app_id   = okta_app_oauth.data_analytics.id
  group_id = okta_group.storm_racing.id
}