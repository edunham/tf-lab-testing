# Exercise 2: Driver Roster - Outputs
# These outputs provide information about the created drivers and their team assignments

# Driver Information Outputs
output "created_drivers" {
  description = "Details of all created racing drivers"
  value = var.create_example_drivers ? {
    for driver_key, driver in okta_user.racing_drivers : driver_key => {
      id         = driver.id
      name       = "${driver.first_name} ${driver.last_name}"
      email      = driver.email
      login      = driver.login
      team       = var.drivers[driver_key].team
      driver_number = var.drivers[driver_key].driver_number
      racing_style  = var.drivers[driver_key].racing_style
    }
  } : {}
}

output "driver_count" {
  description = "Total number of drivers created"
  value       = var.create_example_drivers ? length(okta_user.racing_drivers) : 0
}

# Team Assignment Outputs
output "team_memberships" {
  description = "Driver assignments to teams"
  value = var.create_example_drivers ? {
    for driver_key, assignment in local.driver_team_assignments : driver_key => {
      driver_name = assignment.driver_name
      team_name   = assignment.team_name
      group_id    = assignment.group_id
    }
  } : {}
}

# Team Statistics Outputs
output "team_statistics" {
  description = "Championship statistics by team"
  value       = local.team_stats
}

output "drivers_by_team" {
  description = "List of drivers organized by team"
  value = var.create_example_drivers ? {
    for team, driver_keys in local.drivers_by_team : team => [
      for driver_key in driver_keys : {
        key        = driver_key
        name       = "${var.drivers[driver_key].first_name} ${var.drivers[driver_key].last_name}"
        number     = var.drivers[driver_key].driver_number
        championships = var.drivers[driver_key].championships
        racing_style  = var.drivers[driver_key].racing_style
      }
    ]
  } : {}
}

# Championship Analytics
output "championship_summary" {
  description = "Overall championship statistics across all teams and drivers"
  value = var.create_example_drivers ? {
    total_drivers = local.total_drivers
    total_championships = sum([for driver in var.drivers : driver.championships])
    average_championships_per_driver = local.total_drivers > 0 ? (
      sum([for driver in var.drivers : driver.championships]) / local.total_drivers
    ) : 0
    teams_with_drivers = length([
      for team, drivers in local.drivers_by_team : team
      if length(drivers) > 0
    ])
  } : {
    total_drivers = 0
    total_championships = 0
    average_championships_per_driver = 0
    teams_with_drivers = 0
  }
}

# Integration Outputs
# These outputs can be used by other Terraform configurations
output "driver_ids" {
  description = "Map of driver keys to their Okta user IDs (for integration)"
  value = var.create_example_drivers ? {
    for driver_key, driver in okta_user.racing_drivers : driver_key => driver.id
  } : {}
}

output "team_group_mappings" {
  description = "Mapping of team names to their Okta group IDs (for integration)"
  value = {
    "velocity-racing" = data.okta_group.velocity_racing.id
    "thunder-motors"  = data.okta_group.thunder_motors.id
    "phoenix-speed"   = data.okta_group.phoenix_speed.id
    "storm-racing"    = data.okta_group.storm_racing.id
  }
}

# Validation Outputs
output "deployment_summary" {
  description = "Summary of what was deployed in this exercise"
  value = {
    exercise = "02-driver-roster"
    drivers_created = var.create_example_drivers
    metadata_included = var.include_driver_metadata
    racing_season = var.racing_season
    timestamp = timestamp()
    
    # Quick verification
    expected_drivers = length(var.drivers)
    actual_drivers = var.create_example_drivers ? length(okta_user.racing_drivers) : 0
    deployment_successful = var.create_example_drivers ? (
      length(okta_user.racing_drivers) == length(var.drivers)
    ) : true
  }
}