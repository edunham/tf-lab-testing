# Racing Drivers Module - Outputs
# These outputs provide information about created drivers and their assignments

output "created_drivers" {
  description = "Details of all created racing drivers"
  value = var.create_drivers ? {
    for driver_key, driver in okta_user.racing_drivers : driver_key => {
      id            = driver.id
      name          = "${driver.first_name} ${driver.last_name}"
      email         = driver.email
      login         = driver.login
      team          = var.drivers[driver_key].team
      driver_number = var.drivers[driver_key].driver_number
      racing_style  = var.drivers[driver_key].racing_style
    }
  } : {}
}

output "driver_count" {
  description = "Total number of drivers created"
  value       = var.create_drivers ? length(okta_user.racing_drivers) : 0
}

output "team_memberships" {
  description = "Driver assignments to teams"
  value = var.create_drivers ? {
    for driver_key, assignment in local.driver_team_assignments : driver_key => {
      driver_name = assignment.driver_name
      team_name   = assignment.team_name
      group_id    = assignment.group_id
    }
  } : {}
}

output "team_statistics" {
  description = "Championship statistics by team"
  value       = local.team_stats
}

output "drivers_by_team" {
  description = "List of drivers organized by team"
  value = var.create_drivers ? {
    for team, driver_keys in local.drivers_by_team : team => [
      for driver_key in driver_keys : {
        key           = driver_key
        name          = "${var.drivers[driver_key].first_name} ${var.drivers[driver_key].last_name}"
        number        = var.drivers[driver_key].driver_number
        championships = var.drivers[driver_key].championships
        racing_style  = var.drivers[driver_key].racing_style
      }
    ]
  } : {}
}

output "championship_summary" {
  description = "Overall championship statistics across all teams and drivers"
  value = var.create_drivers ? {
    total_drivers                    = local.total_drivers
    total_championships              = sum([for driver in var.drivers : driver.championships])
    average_championships_per_driver = local.total_drivers > 0 ? (sum([for driver in var.drivers : driver.championships]) / local.total_drivers) : 0
    teams_with_drivers = length([
      for team, drivers in local.drivers_by_team : team
      if length(drivers) > 0
    ])
    } : {
    total_drivers                    = 0
    total_championships              = 0
    average_championships_per_driver = 0
    teams_with_drivers               = 0
  }
}

output "driver_ids" {
  description = "Map of driver keys to their Okta user IDs (for integration)"
  value = var.create_drivers ? {
    for driver_key, driver in okta_user.racing_drivers : driver_key => driver.id
  } : {}
}