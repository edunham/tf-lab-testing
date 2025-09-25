# Terraform 101 with Okta - Root Variables
# These variables control the entire lab deployment
# Demonstrates progressive infrastructure and modular configuration

# EXERCISE CONTROL VARIABLES
# These control which parts of the infrastructure to deploy

variable "enable_drivers" {
  description = "Whether to deploy the racing drivers module (Exercise 2)"
  type        = bool
  default     = false # Start with teams only, then enable drivers

  validation {
    condition     = can(var.enable_drivers == true || var.enable_drivers == false)
    error_message = "enable_drivers must be true or false."
  }
}

variable "create_example_drivers" {
  description = "Whether to create the example racing drivers"
  type        = bool
  default     = true
}

# RACING SEASON CONFIGURATION

variable "racing_season" {
  description = "The current racing season year"
  type        = string
  default     = "2025"

  validation {
    condition     = can(regex("^20[0-9]{2}$", var.racing_season))
    error_message = "Racing season must be a valid year like 2025."
  }
}

# TEAMS CONFIGURATION
# Complex object variable for structured, validated data

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

  default = {
    velocity-racing = {
      display_name   = "Velocity Racing"
      description    = "Speed-focused racing team known for aerodynamic excellence and quick pit stops"
      team_principal = "Sam Velocity"
      home_circuit   = "Monaco Street Circuit"
      specialty      = "aerodynamics"
      team_color     = "velocity-blue"
      founded_year   = 2020
    }
    thunder-motors = {
      display_name   = "Thunder Motors"
      description    = "Power-focused racing team specializing in engine performance and straight-line speed"
      team_principal = "Alex Thunder"
      home_circuit   = "Monza Speedway"
      specialty      = "engine_performance"
      team_color     = "thunder-red"
      founded_year   = 2018
    }
    phoenix-speed = {
      display_name   = "Phoenix Speed"
      description    = "Precision-focused racing team known for strategic race management and consistency"
      team_principal = "Jordan Phoenix"
      home_circuit   = "Suzuka International"
      specialty      = "race_strategy"
      team_color     = "phoenix-orange"
      founded_year   = 2019
    }
    storm-racing = {
      display_name   = "Storm Racing"
      description    = "Strategy-focused racing team excelling in wet weather conditions and adaptability"
      team_principal = "Casey Storm"
      home_circuit   = "Silverstone Circuit"
      specialty      = "weather_strategy"
      team_color     = "storm-purple"
      founded_year   = 2021
    }
  }

  validation {
    condition = alltrue([
      for team in var.racing_teams :
      team.founded_year >= 2010 && team.founded_year <= tonumber(var.racing_season)
    ])
    error_message = "Team founded year must be between 2010 and current racing season."
  }
}

# DRIVERS CONFIGURATION
# Used by the racing-drivers module when enabled

variable "drivers" {
  description = "Configuration for racing drivers with detailed profiles"
  type = map(object({
    first_name     = string
    last_name      = string
    driver_number  = string
    team           = string
    championships  = number
    preferred_tire = string
    racing_style   = string
    email_domain   = string
  }))

  default = {
    "alex-speedwell" = {
      first_name     = "Alex"
      last_name      = "Speedwell"
      driver_number  = "7"
      team           = "velocity-racing"
      championships  = 2
      preferred_tire = "soft"
      racing_style   = "aggressive"
      email_domain   = "velocityracing.com"
    }
    "jordan-swift" = {
      first_name     = "Jordan"
      last_name      = "Swift"
      driver_number  = "23"
      team           = "thunder-motors"
      championships  = 1
      preferred_tire = "medium"
      racing_style   = "calculated"
      email_domain   = "thundermotors.com"
    }
    "casey-turbo" = {
      first_name     = "Casey"
      last_name      = "Turbo"
      driver_number  = "11"
      team           = "phoenix-speed"
      championships  = 0
      preferred_tire = "hard"
      racing_style   = "strategic"
      email_domain   = "phoenixspeed.com"
    }
    "riley-flash" = {
      first_name     = "Riley"
      last_name      = "Flash"
      driver_number  = "44"
      team           = "storm-racing"
      championships  = 3
      preferred_tire = "intermediate"
      racing_style   = "adaptive"
      email_domain   = "stormracing.com"
    }
  }

  # Driver validation - ensures data quality
  validation {
    condition = alltrue([
      for driver in var.drivers :
      can(regex("^[1-9][0-9]?$", driver.driver_number))
    ])
    error_message = "Driver numbers must be between 1-99."
  }

  validation {
    condition = alltrue([
      for driver in var.drivers :
      contains(keys(var.racing_teams), driver.team)
    ])
    error_message = "Driver team must be one of the configured racing teams."
  }

  validation {
    condition = alltrue([
      for driver in var.drivers :
      contains(["soft", "medium", "hard", "intermediate", "wet"], driver.preferred_tire)
    ])
    error_message = "Preferred tire must be one of: soft, medium, hard, intermediate, wet."
  }

  validation {
    condition = alltrue([
      for driver in var.drivers :
      contains(["aggressive", "calculated", "strategic", "adaptive", "defensive"], driver.racing_style)
    ])
    error_message = "Racing style must be one of: aggressive, calculated, strategic, adaptive, defensive."
  }

  validation {
    condition = alltrue([
      for driver in var.drivers :
      driver.championships >= 0 && driver.championships <= 10
    ])
    error_message = "Championships must be between 0 and 10."
  }
}

# LEAGUE CONFIGURATION

variable "league_configuration" {
  description = "Configuration for the racing league"
  type = object({
    name                       = string
    founded_year               = number
    championship_points_system = list(number)
    safety_car_enabled         = bool
  })

  default = {
    name                       = "Formula Infrastructure Racing League"
    founded_year               = 2020
    championship_points_system = [25, 18, 15, 12, 10, 8, 6, 4, 2, 1]
    safety_car_enabled         = true
  }
}