# Exercise 1: Team Formation - Outputs
# Outputs display useful information about what we created
# Think of these as the "race results" showing our accomplishments

# Summary of what we built
output "exercise_summary" {
  description = "Summary of Exercise 1 accomplishments"
  value = {
    exercise_name    = "Team Formation"
    teams_created    = local.total_teams
    terraform_basics = "✅ Completed"
    next_exercise    = "02-driver-roster"
  }
}

# Information about each racing team
output "racing_teams" {
  description = "Details about all racing teams created"
  value = {
    velocity_racing = {
      group_id       = okta_group.velocity_racing.id
      group_name     = okta_group.velocity_racing.name
      team_principal = "Sam Velocity"
      specialty      = "aerodynamics"
      home_circuit   = "Monaco Street Circuit"
    }
    thunder_motors = {
      group_id       = okta_group.thunder_motors.id
      group_name     = okta_group.thunder_motors.name
      team_principal = "Alex Thunder"
      specialty      = "engine_performance"
      home_circuit   = "Monza Speedway"
    }
    phoenix_speed = {
      group_id       = okta_group.phoenix_speed.id
      group_name     = okta_group.phoenix_speed.name
      team_principal = "Jordan Phoenix"
      specialty      = "race_strategy"
      home_circuit   = "Suzuka International"
    }
    storm_racing = {
      group_id       = okta_group.storm_racing.id
      group_name     = okta_group.storm_racing.name
      team_principal = "Casey Storm"
      specialty      = "weather_strategy"
      home_circuit   = "Silverstone Circuit"
    }
  }
}

# Quick reference for Okta admin console
output "okta_admin_links" {
  description = "Helpful links to view your work in Okta"
  value = {
    okta_admin_console = "Check your Okta admin console under Directory > Groups"
    groups_to_find = [
      "Velocity Racing",
      "Thunder Motors", 
      "Phoenix Speed",
      "Storm Racing"
    ]
  }
}

# Learning checkpoint - what concepts you just mastered
output "terraform_concepts_learned" {
  description = "Terraform concepts you just learned in this exercise"
  value = {
    workflow = {
      init     = "terraform init - Initialize and download providers"
      plan     = "terraform plan - Preview changes before applying"
      apply    = "terraform apply - Create infrastructure"
      show     = "terraform show - Display current state"
    }
    
    syntax = {
      terraform_block = "Defines required providers and versions"
      provider_block  = "Configures authentication and connection"
      resource_block  = "Creates infrastructure components"
      output_block    = "Displays information about created resources"
    }
    
    concepts = {
      infrastructure_as_code = "Infrastructure defined in code files"
      declarative           = "Describe desired state, not steps"
      idempotent           = "Running apply multiple times gives same result"
      state_management     = "Terraform tracks what it manages"
    }
  }
}

# Fun racing statistics
output "racing_team_stats" {
  description = "Fun statistics about your racing organization"
  value = {
    total_teams = local.total_teams
    specialties = [
      "aerodynamics",
      "engine_performance", 
      "race_strategy",
      "weather_strategy"
    ]
    circuits_represented = [
      "Monaco Street Circuit",
      "Monza Speedway",
      "Suzuka International", 
      "Silverstone Circuit"
    ]
    team_colors = [
      "velocity-blue",
      "thunder-red",
      "phoenix-orange",
      "storm-purple"
    ]
  }
}

# Next steps guidance
output "whats_next" {
  description = "Guidance for continuing your Terraform journey"
  value = {
    immediate_next_steps = [
      "1. Verify teams exist in your Okta admin console",
      "2. Run 'terraform plan' again (should show no changes)",
      "3. Proceed to Exercise 2: Driver Management"
    ]
    
    exercise_2_preview = {
      learning_focus = "Variables, data sources, and resource dependencies"
      what_youll_build = "Add racing drivers to your teams"
      new_concepts = ["for_each loops", "variable validation", "locals"]
    }
    
    terraform_commands_to_remember = {
      validate = "terraform validate - Check syntax"
      plan     = "terraform plan - Preview changes"  
      apply    = "terraform apply - Make changes"
      show     = "terraform show - View current state"
      output   = "terraform output - Display output values"
    }
  }
}