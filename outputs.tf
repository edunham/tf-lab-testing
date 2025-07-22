# Terraform 101 Racing Lab - Output Definitions
# Outputs display useful information after Terraform creates our infrastructure
# Think of outputs as the "race results" - showing what we accomplished

# Racing Organization Summary
# High-level information about our racing infrastructure

output "racing_organization_summary" {
  description = "Summary of the racing organization infrastructure"
  value = {
    organization_name = var.racing_organization_name
    season           = var.racing_season
    environment      = var.environment
    total_teams      = length(local.team_keys)
    total_drivers    = length(local.driver_keys)
    total_apps       = length(local.app_keys)
  }
}

# Team Information
# Details about each racing team we created

output "racing_teams" {
  description = "Information about all racing teams and their Okta group IDs"
  value = {
    for team_key, team in local.teams_config : team_key => {
      group_id      = okta_group.racing_teams[team_key].id
      group_name    = okta_group.racing_teams[team_key].name
      team_principal = var.team_principals[team_key].name
      specialty     = var.team_principals[team_key].specialty
      team_color    = var.team_colors[team_key]
      home_circuit  = var.home_circuits[team_key]
      member_count  = length([
        for driver_key, driver in var.drivers : driver_key 
        if driver.team == team_key
      ])
    }
  }
}

# Driver Information
# Details about each racing driver we created

output "racing_drivers" {
  description = "Information about all racing drivers and their Okta user IDs"
  value = {
    for driver_key, driver in var.drivers : driver_key => {
      user_id        = okta_user.racing_drivers[driver_key].id
      full_name      = "${driver.first_name} ${driver.last_name}"
      email         = okta_user.racing_drivers[driver_key].email
      driver_number = driver.driver_number
      team          = driver.team
      championships = driver.championships
      racing_style  = driver.racing_style
      preferred_tire = driver.preferred_tire
    }
  }
}

# Application Information
# Details about racing applications and their access

output "racing_applications" {
  description = "Information about racing applications and their Okta app IDs"
  value = {
    for app_key, app in var.racing_applications : app_key => {
      app_id       = okta_app_oauth.racing_apps[app_key].id
      app_name     = app.display_name
      app_type     = app.app_type
      description  = app.description
      redirect_uri = app.redirect_uri
      real_time    = app.real_time
      data_sensitivity = app.data_sensitivity
      teams_with_access = var.application_access_matrix[app_key].teams_with_access
    }
  }
}

# Access Control Matrix
# Shows which teams have access to which applications

output "access_control_matrix" {
  description = "Matrix showing team access to racing applications"
  value = {
    for app_key, access in var.application_access_matrix : app_key => {
      application_name = var.racing_applications[app_key].display_name
      teams_with_access = [
        for team_key in access.teams_with_access : {
          team_key   = team_key
          team_name  = title(replace(team_key, "-", " "))
          group_id   = okta_group.racing_teams[team_key].id
        }
      ]
      access_level      = access.access_level
      requires_approval = access.requires_approval
    }
  }
}

# Quick Reference URLs
# Helpful links for workshop participants

output "quick_reference" {
  description = "Quick reference information for workshop participants"
  value = {
    okta_admin_url = "https://${var.okta_org_name}.${var.okta_base_url}/admin"
    terraform_docs = "https://registry.terraform.io/providers/okta/okta/latest/docs"
    
    # Application URLs for testing (these would be real in production)
    application_urls = {
      for app_key, app in var.racing_applications : app_key => app.redirect_uri
    }
    
    # Useful Terraform commands for reference
    terraform_commands = {
      validate = "terraform validate"
      plan     = "terraform plan"
      apply    = "terraform apply"
      show     = "terraform show"
      destroy  = "terraform destroy"
    }
  }
}

# Racing Statistics
# Fun statistics about our racing infrastructure

output "racing_statistics" {
  description = "Fun statistics about the racing infrastructure"
  value = {
    total_championships = sum([for driver in var.drivers : driver.championships])
    teams_by_specialty = {
      for specialty in distinct([for principal in var.team_principals : principal.specialty]) :
      specialty => [
        for team_key, principal in var.team_principals : team_key
        if principal.specialty == specialty
      ]
    }
    drivers_by_tire_preference = {
      for tire in distinct([for driver in var.drivers : driver.preferred_tire]) :
      tire => [
        for driver_key, driver in var.drivers : driver_key
        if driver.preferred_tire == tire
      ]
    }
    most_experienced_team_principal = {
      for team_key, principal in var.team_principals :
      team_key => principal
      if principal.experience_years == max([for p in var.team_principals : p.experience_years])...
    }
  }
}

# Environment Information
# Information about the deployment environment

output "environment_info" {
  description = "Information about the deployment environment"
  value = {
    environment = var.environment
    advanced_features_enabled = var.enable_advanced_features
    session_timeout_hours = var.session_timeout_hours
    resource_tags = var.resource_tags
    okta_configuration = {
      org_name = var.okta_org_name
      base_url = var.okta_base_url
    }
  }
}

# Workshop Progress Indicators
# Helpful outputs for tracking workshop progress

output "workshop_progress" {
  description = "Workshop progress indicators for participants"
  value = {
    phase_1_complete = length(okta_group.racing_teams) > 0 ? "✅ Teams Created" : "❌ Teams Not Created"
    phase_2_complete = length(okta_user.racing_drivers) > 0 ? "✅ Drivers Added" : "❌ Drivers Not Added"
    phase_3_complete = length(okta_app_oauth.racing_apps) > 0 ? "✅ Applications Deployed" : "❌ Applications Not Deployed"
    
    next_steps = length(okta_app_oauth.racing_apps) > 0 ? [
      "🏁 Congratulations! You've completed the racing lab!",
      "🔍 Explore the Okta admin console to see your infrastructure",
      "📊 Check out the racing statistics above",
      "🚀 Consider the optional advanced exercises"
    ] : [
      "📝 Continue following the workshop exercises",
      "💡 Use 'terraform plan' to preview changes before applying",
      "❓ Ask for help if you encounter any issues"
    ]
  }
}

# Local Values for Complex Calculations
# These help organize our output calculations

locals {
  # Extract keys for counting
  team_keys   = keys(var.team_principals)
  driver_keys = keys(var.drivers)
  app_keys    = keys(var.racing_applications)
  
  # Create team configuration objects
  teams_config = {
    for team_key in local.team_keys : team_key => {
      name           = title(replace(team_key, "-", " "))
      team_principal = var.team_principals[team_key].name
      specialty      = var.team_principals[team_key].specialty
      color         = var.team_colors[team_key]
      home_circuit  = var.home_circuits[team_key]
    }
  }
}