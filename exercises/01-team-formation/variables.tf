# Exercise 1: Team Formation - Variables
# This exercise introduces basic variable concepts
# Variables make our code flexible and reusable

# Basic string variable with validation
variable "racing_season" {
  description = "The current racing season year"
  type        = string
  default     = "2024"
  
  # Validation ensures we get a valid year format
  validation {
    condition     = can(regex("^20[0-9]{2}$", var.racing_season))
    error_message = "Racing season must be a valid year like 2024."
  }
}

# Simple boolean variable for learning
variable "include_team_metadata" {
  description = "Whether to include detailed team metadata in group attributes"
  type        = bool
  default     = true
}

# Number variable with constraints
variable "max_teams_per_league" {
  description = "Maximum number of teams allowed in the racing league"
  type        = number
  default     = 10
  
  validation {
    condition     = var.max_teams_per_league >= 2 && var.max_teams_per_league <= 20
    error_message = "Must have between 2 and 20 teams for a proper racing league."
  }
}

# List variable for organizing information
variable "team_specialties" {
  description = "List of specialties that racing teams can focus on"
  type        = list(string)
  default = [
    "aerodynamics",
    "engine_performance",
    "race_strategy", 
    "weather_strategy",
    "tire_management",
    "pit_stop_efficiency"
  ]
}

# Map variable for organizing key-value data
variable "circuit_locations" {
  description = "Map of racing circuits to their locations"
  type        = map(string)
  default = {
    "Monaco Street Circuit"  = "Monte Carlo, Monaco"
    "Monza Speedway"        = "Monza, Italy"
    "Suzuka International"  = "Suzuka, Japan"
    "Silverstone Circuit"   = "Silverstone, United Kingdom"
  }
}

# Complex object variable (optional for advanced learners)
variable "league_configuration" {
  description = "Configuration for the racing league"
  type = object({
    name            = string
    founded_year    = number
    championship_points_system = list(number)
    safety_car_enabled = bool
  })
  
  default = {
    name            = "Formula Infrastructure Racing League"
    founded_year    = 2024
    championship_points_system = [25, 18, 15, 12, 10, 8, 6, 4, 2, 1]
    safety_car_enabled = true
  }
}

# Learning notes for workshop participants
# These aren't used in the code but help explain concepts
locals {
  variable_learning_notes = {
    types = {
      string = "Text values like team names"
      number = "Numeric values like years or counts"
      bool   = "True/false values like feature flags"
      list   = "Ordered collections like [item1, item2]"
      map    = "Key-value pairs like {key1 = value1}"
      object = "Complex structures with multiple typed fields"
    }
    
    best_practices = {
      descriptions = "Always include clear descriptions"
      validation   = "Use validation blocks to catch errors early"
      defaults     = "Provide sensible defaults when possible"
      naming       = "Use descriptive names like 'racing_season' not 'rs'"
    }
    
    usage_patterns = {
      required = "Variables without defaults must be provided"
      optional = "Variables with defaults are optional to override"
      computed = "Some values are calculated from other variables"
    }
  }
}