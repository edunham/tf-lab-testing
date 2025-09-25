# Racing Drivers Module - Variables
# This module's input variables for driver configuration

variable "create_drivers" {
  description = "Whether to create the racing drivers"
  type        = bool
  default     = true
}

variable "racing_season" {
  description = "Current racing season year"
  type        = string

  validation {
    condition     = can(regex("^20[0-9]{2}$", var.racing_season))
    error_message = "Racing season must be a valid year (e.g., 2025)."
  }
}

# Module receives team information from racing-teams module
variable "team_ids" {
  description = "Map of team keys to their Okta group IDs (from racing-teams module)"
  type        = map(string)
}

variable "team_names" {
  description = "Map of team keys to their display names (from racing-teams module)"
  type        = map(string)
}

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

  # Default driver roster for the racing league
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

  # Validation Rules
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