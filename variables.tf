# Terraform 101 Racing Lab - Variable Definitions
# Variables make our infrastructure code flexible and reusable
# Think of variables as the "configuration settings" for our racing teams

# Organization Settings
# These variables control the basic setup of our racing organization

variable "racing_organization_name" {
  description = "Name of the racing organization managing multiple teams"
  type        = string
  default     = "Formula Infrastructure Racing League"
  
  validation {
    condition     = length(var.racing_organization_name) > 0
    error_message = "Racing organization name cannot be empty. Every racing series needs a name!"
  }
}

variable "racing_season" {
  description = "Current racing season year for organizational context"
  type        = string
  default     = "2024"
  
  validation {
    condition     = can(regex("^20[0-9]{2}$", var.racing_season))
    error_message = "Racing season must be a valid year (e.g., 2024). Time to update for the current season!"
  }
}

# Team Configuration
# Variables that control how our racing teams are set up

variable "team_principals" {
  description = "Map of racing teams to their team principals (like team managers)"
  type = map(object({
    name           = string
    experience_years = number
    specialty      = string
  }))
  
  default = {
    "velocity-racing" = {
      name           = "Sam Velocity"
      experience_years = 15
      specialty      = "aerodynamics"
    }
    "thunder-motors" = {
      name           = "Alex Thunder"
      experience_years = 12
      specialty      = "engine_performance"
    }
    "phoenix-speed" = {
      name           = "Jordan Phoenix"
      experience_years = 18
      specialty      = "race_strategy"
    }
    "storm-racing" = {
      name           = "Casey Storm"
      experience_years = 20
      specialty      = "weather_strategy"
    }
  }
  
  validation {
    condition = length(var.team_principals) >= 2
    error_message = "Need at least 2 teams for a proper racing championship!"
  }
}

variable "team_colors" {
  description = "Official team colors for branding and identification"
  type        = map(string)
  
  default = {
    "velocity-racing" = "velocity-blue"
    "thunder-motors"  = "thunder-red"
    "phoenix-speed"   = "phoenix-orange"
    "storm-racing"    = "storm-purple"
  }
}

variable "home_circuits" {
  description = "Home racing circuits for each team (like home stadiums in sports)"
  type        = map(string)
  
  default = {
    "velocity-racing" = "Monaco Street Circuit"
    "thunder-motors"  = "Monza Speedway"
    "phoenix-speed"   = "Suzuka International"
    "storm-racing"    = "Silverstone Circuit"
  }
}

# Driver Configuration
# Variables for setting up our racing drivers

variable "drivers" {
  description = "Configuration for racing drivers including their details and team assignments"
  type = map(object({
    first_name       = string
    last_name        = string
    driver_number    = string
    team            = string
    championships   = number
    preferred_tire  = string
    racing_style    = string
    email_domain    = string
  }))
  
  default = {
    "alex-speedwell" = {
      first_name       = "Alex"
      last_name        = "Speedwell"
      driver_number    = "7"
      team            = "velocity-racing"
      championships   = 2
      preferred_tire  = "soft"
      racing_style    = "aggressive"
      email_domain    = "velocityracing.com"
    }
    "jordan-swift" = {
      first_name       = "Jordan"
      last_name        = "Swift"
      driver_number    = "23"
      team            = "thunder-motors"
      championships   = 1
      preferred_tire  = "medium"
      racing_style    = "calculated"
      email_domain    = "thundermotors.com"
    }
    "casey-turbo" = {
      first_name       = "Casey"
      last_name        = "Turbo"
      driver_number    = "11"
      team            = "phoenix-speed"
      championships   = 0
      preferred_tire  = "hard"
      racing_style    = "strategic"
      email_domain    = "phoenixspeed.com"
    }
    "riley-flash" = {
      first_name       = "Riley"
      last_name        = "Flash"
      driver_number    = "44"
      team            = "storm-racing"
      championships   = 3
      preferred_tire  = "intermediate"
      racing_style    = "adaptive"
      email_domain    = "stormracing.com"
    }
  }
  
  validation {
    condition = length(var.drivers) >= 1
    error_message = "Need at least 1 driver to start racing!"
  }
  
  validation {
    condition = alltrue([
      for driver in var.drivers : 
      contains(["soft", "medium", "hard", "intermediate", "wet"], driver.preferred_tire)
    ])
    error_message = "Driver preferred tire must be one of: soft, medium, hard, intermediate, wet"
  }
}

# Application Configuration
# Variables for the racing applications our teams will use

variable "racing_applications" {
  description = "Configuration for racing applications and their access requirements"
  type = map(object({
    display_name     = string
    description      = string
    app_type         = string
    data_sensitivity = string
    real_time        = bool
    redirect_uri     = string
  }))
  
  default = {
    "race-dashboard" = {
      display_name     = "Race Dashboard"
      description      = "Real-time race telemetry and live timing data for teams and drivers"
      app_type         = "racing_telemetry"
      data_sensitivity = "high"
      real_time        = true
      redirect_uri     = "https://race-dashboard.racing.local/callback"
    }
    "timing-portal" = {
      display_name     = "Timing Portal"
      description      = "Lap timing analysis and sector performance tracking"
      app_type         = "timing_system"
      data_sensitivity = "medium"
      real_time        = true
      redirect_uri     = "https://timing-portal.racing.local/callback"
    }
    "team-communication" = {
      display_name     = "Team Communication"
      description      = "Secure team communications between pit wall and drivers"
      app_type         = "communication"
      data_sensitivity = "high"
      real_time        = true
      redirect_uri     = "https://team-comm.racing.local/callback"
    }
    "data-analytics" = {
      display_name     = "Data Analytics"
      description      = "Historical performance data and strategic race analysis"
      app_type         = "analytics"
      data_sensitivity = "medium"
      real_time        = false
      redirect_uri     = "https://analytics.racing.local/callback"
    }
  }
  
  validation {
    condition = alltrue([
      for app in var.racing_applications : 
      contains(["low", "medium", "high"], app.data_sensitivity)
    ])
    error_message = "Application data sensitivity must be one of: low, medium, high"
  }
}

# Access Control Configuration
# Variables that control which teams can access which applications

variable "application_access_matrix" {
  description = "Defines which teams have access to which racing applications"
  type = map(object({
    teams_with_access = list(string)
    access_level      = string
    requires_approval = bool
  }))
  
  default = {
    "race-dashboard" = {
      teams_with_access = ["velocity-racing", "thunder-motors", "phoenix-speed", "storm-racing"]
      access_level      = "read-write"
      requires_approval = false
    }
    "timing-portal" = {
      teams_with_access = ["velocity-racing", "thunder-motors"]
      access_level      = "read-only"
      requires_approval = false
    }
    "team-communication" = {
      teams_with_access = ["velocity-racing", "thunder-motors", "phoenix-speed", "storm-racing"]
      access_level      = "read-write"
      requires_approval = true
    }
    "data-analytics" = {
      teams_with_access = ["phoenix-speed", "storm-racing"]
      access_level      = "read-write"
      requires_approval = false
    }
  }
  
  validation {
    condition = alltrue([
      for app in var.application_access_matrix : 
      contains(["read-only", "read-write", "admin"], app.access_level)
    ])
    error_message = "Access level must be one of: read-only, read-write, admin"
  }
}

# Environment Configuration
# Variables for different deployment environments (dev, staging, production)

variable "environment" {
  description = "Deployment environment (development, staging, production)"
  type        = string
  default     = "development"
  
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be one of: development, staging, production"
  }
}

variable "enable_advanced_features" {
  description = "Enable advanced racing features like real-time telemetry and advanced analytics"
  type        = bool
  default     = false
}

variable "resource_tags" {
  description = "Tags to apply to all resources for organization and cost tracking"
  type        = map(string)
  
  default = {
    Project     = "terraform-101-racing-lab"
    Environment = "development"
    Owner       = "racing-infrastructure-team"
    Purpose     = "educational"
  }
}

# Okta-specific Configuration
# Variables specific to Okta identity management

variable "okta_org_name" {
  description = "Your Okta organization name (from your Okta URL)"
  type        = string
  default     = "dev-123456"
  
  validation {
    condition     = length(var.okta_org_name) > 0
    error_message = "Okta organization name is required."
  }
}

variable "okta_base_url" {
  description = "Your Okta base URL (okta.com or oktapreview.com)"
  type        = string
  default     = "oktapreview.com"
  
  validation {
    condition     = contains(["okta.com", "oktapreview.com"], var.okta_base_url)
    error_message = "Okta base URL must be either okta.com or oktapreview.com."
  }
}

variable "okta_group_description_suffix" {
  description = "Suffix to add to all Okta group descriptions for consistency"
  type        = string
  default     = " (Managed by Terraform Racing Lab)"
}

variable "user_password_policy" {
  description = "Password policy settings for racing team members"
  type = object({
    min_length        = number
    require_uppercase = bool
    require_lowercase = bool
    require_numbers   = bool
    require_symbols   = bool
  })
  
  default = {
    min_length        = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
  }
}

variable "session_timeout_hours" {
  description = "Session timeout for racing applications in hours"
  type        = number
  default     = 8
  
  validation {
    condition     = var.session_timeout_hours >= 1 && var.session_timeout_hours <= 24
    error_message = "Session timeout must be between 1 and 24 hours for security and usability."
  }
}