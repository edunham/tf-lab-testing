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

# BEST PRACTICE: Use computed outputs rather than hard-coded values
output "racing_teams" {
  description = "Details about all racing teams created (dynamically generated)"
  value       = local.team_summary
}

# Quick reference for Okta admin console
# BEST PRACTICE: Generate dynamic lists rather than hard-coding
output "okta_admin_links" {
  description = "Helpful links to view your work in Okta"
  value = {
    okta_admin_console = "Check your Okta admin console under Directory > Groups"
    groups_to_find     = [for team in var.racing_teams : team.display_name]
  }
}

# Learning checkpoint - what concepts you just mastered
output "terraform_concepts_learned" {
  description = "Terraform concepts you just learned in this exercise"
  value = {
    workflow = {
      init  = "terraform init - Initialize and download providers"
      plan  = "terraform plan - Preview changes before applying"
      apply = "terraform apply - Create infrastructure"
      show  = "terraform show - Display current state"
    }

    syntax = {
      terraform_block = "Defines required providers and versions"
      provider_block  = "Configures authentication and connection"
      resource_block  = "Creates infrastructure components"
      output_block    = "Displays information about created resources"
    }

    concepts = {
      infrastructure_as_code = "Infrastructure defined in code files"
      declarative            = "Describe desired state, not steps"
      idempotent             = "Running apply multiple times gives same result"
      state_management       = "Terraform tracks what it manages"
    }
  }
}

# Fun racing statistics
# BEST PRACTICE: Compute statistics dynamically from data
output "racing_team_stats" {
  description = "Fun statistics about your racing organization (computed dynamically)"
  value = {
    total_teams          = local.total_teams
    specialties          = distinct([for team in var.racing_teams : team.specialty])
    circuits_represented = distinct([for team in var.racing_teams : team.home_circuit])
    team_colors          = distinct([for team in var.racing_teams : team.team_color])
    teams_by_specialty   = local.teams_by_specialty
    average_team_age     = floor((tonumber(var.racing_season) - (sum([for team in var.racing_teams : team.founded_year]) / length(var.racing_teams))))
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
      learning_focus   = "Variables, data sources, and resource dependencies"
      what_youll_build = "Add racing drivers to your teams"
      new_concepts     = ["for_each loops", "variable validation", "locals"]
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

# BEST PRACTICE: Document what best practices are demonstrated
output "terraform_best_practices_demonstrated" {
  description = "Terraform best practices shown in this exercise"
  value = {
    resource_organization = {
      for_each_pattern     = "Using for_each instead of duplicating resources"
      variable_driven      = "Resources configured from variables, not hard-coded"
      consistent_naming    = "Consistent snake_case for resource names"
      dynamic_descriptions = "Descriptions built from structured data"
    }

    variable_management = {
      structured_data   = "Complex object variables for related configuration"
      validation_rules  = "Input validation to catch errors early"
      descriptive_names = "Clear, descriptive variable names"
      sensible_defaults = "Thoughtful default values for ease of use"
    }

    code_organization = {
      locals_for_logic    = "Business logic separated into locals blocks"
      computed_outputs    = "Outputs calculated from resources, not hard-coded"
      dry_principle       = "Don't Repeat Yourself - reusable patterns"
      separation_concerns = "Variables, resources, locals, and outputs well-organized"
    }

    maintainability = {
      scalable_design  = "Easy to add/remove teams by updating variables"
      data_driven      = "Configuration drives infrastructure, not code duplication"
      clear_comments   = "Educational comments explaining best practices"
      consistent_style = "Uniform formatting and naming conventions"
    }
  }
}