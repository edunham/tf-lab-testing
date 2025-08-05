# Exercise 2: Driver Roster - Variables
# This exercise demonstrates advanced variable concepts:
# - Object variables with complex structures
# - Variable validation with business rules
# - Default values and optional configuration

# Control Variables
# These determine what gets created and how

variable "create_example_drivers" {
  description = "Whether to create the example racing drivers"
  type        = bool
  default     = true
}

variable "include_driver_metadata" {
  description = "Whether to include racing-specific metadata in driver profiles"
  type        = bool
  default     = true
}

variable "racing_season" {
  description = "Current racing season year"
  type        = string
  default     = "2025"

  validation {
    condition     = can(regex("^20[0-9]{2}$", var.racing_season))
    error_message = "Racing season must be a valid year (e.g., 2025)."
  }
}

# Driver Configuration
# Complex object variable demonstrating structured data

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
  # These ensure data quality and catch configuration errors

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
      contains(["velocity-racing", "thunder-motors", "phoenix-speed", "storm-racing"], driver.team)
    ])
    error_message = "Driver team must be one of: velocity-racing, thunder-motors, phoenix-speed, storm-racing."
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

# Team Configuration Reference
# These help validate and organize team-related data

variable "valid_teams" {
  description = "List of valid team identifiers (used for validation)"
  type        = list(string)
  default = [
    "velocity-racing",
    "thunder-motors",
    "phoenix-speed",
    "storm-racing"
  ]
}

variable "team_display_names" {
  description = "Map of team IDs to display names"
  type        = map(string)
  default = {
    "velocity-racing" = "Velocity Racing"
    "thunder-motors"  = "Thunder Motors"
    "phoenix-speed"   = "Phoenix Speed"
    "storm-racing"    = "Storm Racing"
  }
}

# Advanced Configuration Options
# These demonstrate more complex variable patterns

variable "driver_email_domain" {
  description = "Override email domain for all drivers (optional)"
  type        = string
  default     = null

  validation {
    condition     = var.driver_email_domain == null || can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]\\.[a-zA-Z]{2,}$", var.driver_email_domain))
    error_message = "Email domain must be a valid domain name (e.g., example.com)."
  }
}

variable "minimum_experience_years" {
  description = "Minimum years of experience for drivers"
  type        = number
  default     = 0

  validation {
    condition     = var.minimum_experience_years >= 0 && var.minimum_experience_years <= 30
    error_message = "Minimum experience years must be between 0 and 30."
  }
}

variable "auto_assign_driver_numbers" {
  description = "Whether to automatically assign driver numbers if not specified"
  type        = bool
  default     = false
}

# Learning Reference Variables
# These help explain concepts but aren't used in the actual configuration

variable "variable_learning_examples" {
  description = "Examples of different variable types (for learning purposes)"
  type = object({
    string_example = string
    number_example = number
    bool_example   = bool
    list_example   = list(string)
    map_example    = map(string)
    object_example = object({
      nested_string = string
      nested_number = number
    })
  })
  default = {
    string_example = "This is a string"
    number_example = 42
    bool_example   = true
    list_example   = ["item1", "item2", "item3"]
    map_example    = { key1 = "value1", key2 = "value2" }
    object_example = {
      nested_string = "nested value"
      nested_number = 100
    }
  }
}

# Local Values for Complex Calculations
# These demonstrate computed values and reduce repetition

locals {
  # Validation helpers
  unique_driver_numbers = distinct([for driver in var.drivers : driver.driver_number])
  duplicate_numbers     = length(local.unique_driver_numbers) != length(var.drivers)

  # Team statistics
  drivers_per_team = {
    for team in var.valid_teams : team => length([
      for driver in var.drivers : driver
      if driver.team == team
    ])
  }

  # Championship calculations
  total_championships = sum([for driver in var.drivers : driver.championships])
  avg_championships   = local.total_championships / length(var.drivers)

  # Most experienced driver
  max_championships = max([for driver in var.drivers : driver.championships])
  champions = [
    for driver_key, driver in var.drivers : driver_key
    if driver.championships == local.max_championships
  ]

  # Email domain override logic
  effective_email_domains = {
    for driver_key, driver in var.drivers : driver_key =>
    var.driver_email_domain != null ? var.driver_email_domain : driver.email_domain
  }
}