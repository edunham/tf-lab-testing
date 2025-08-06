# Racing Teams Module - Variables
# This module's input variables for team configuration

variable "racing_season" {
  description = "The current racing season year"
  type        = string

  validation {
    condition     = can(regex("^20[0-9]{2}$", var.racing_season))
    error_message = "Racing season must be a valid year like 2025."
  }
}

variable "racing_teams" {
  description = "Configuration for racing teams to be created as Okta groups"
  type = map(object({
    display_name   = string
    description    = string
    team_principal = string
    home_circuit   = string
    specialty      = string
    team_color     = string
    founded_year   = number
  }))

  validation {
    condition = alltrue([
      for team in var.racing_teams :
      team.founded_year >= 2010 && team.founded_year <= 2030
    ])
    error_message = "Team founded year must be between 2010 and 2030."
  }
}

variable "league_configuration" {
  description = "Configuration for the racing league"
  type = object({
    name                       = string
    founded_year               = number
    championship_points_system = list(number)
    safety_car_enabled         = bool
  })
}