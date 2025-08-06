# Terraform 101 with Okta - Root Outputs
# These outputs demonstrate module composition and progressive deployment

# EXERCISE PROGRESSION SUMMARY
output "exercise_progress" {
  description = "Current exercise progression status"
  value = {
    teams_deployed   = true
    drivers_deployed = var.enable_drivers
    next_step = var.enable_drivers ? (
      var.create_example_drivers ? "✅ Full lab completed!" : "Enable create_example_drivers to create racing drivers"
    ) : "Set enable_drivers = true to proceed to Exercise 2"
  }
}

# TEAMS MODULE OUTPUTS (Always Available)
output "racing_teams" {
  description = "Complete team information from racing-teams module"
  value       = module.racing_teams.team_summary
}

output "team_statistics" {
  description = "Team statistics and analytics"
  value       = module.racing_teams.team_statistics
}

output "okta_admin_links" {
  description = "Helpful links to view your work in Okta"
  value = {
    okta_admin_console = "Check your Okta admin console under Directory > Groups"
    groups_to_find     = values(module.racing_teams.team_names)
  }
}

# DRIVERS MODULE OUTPUTS (Conditional - Only When Enabled)
output "racing_drivers" {
  description = "Racing drivers information (only available when enable_drivers = true)"
  value       = var.enable_drivers ? local.driver_outputs.created_drivers : {}
}

output "driver_count" {
  description = "Total number of drivers created"
  value       = var.enable_drivers ? local.driver_outputs.driver_count : 0
}

output "team_memberships" {
  description = "Driver assignments to teams"
  value       = var.enable_drivers ? local.driver_outputs.team_memberships : {}
}

output "drivers_by_team" {
  description = "Drivers organized by team"
  value       = var.enable_drivers ? local.driver_outputs.drivers_by_team : {}
}

output "championship_summary" {
  description = "Championship statistics across all drivers"
  value = var.enable_drivers ? local.driver_outputs.championship_summary : {
    total_drivers                    = 0
    total_championships              = 0
    average_championships_per_driver = 0
    teams_with_drivers               = 0
  }
}

# LEARNING OUTPUTS
output "terraform_concepts_learned" {
  description = "Terraform concepts demonstrated in this lab"
  value = {
    workflow = {
      init  = "terraform init - Initialize and download providers"
      plan  = "terraform plan - Preview changes before applying"
      apply = "terraform apply - Create infrastructure"
      show  = "terraform show - Display current state"
    }

    modules = {
      composition  = "How to combine multiple modules in a root configuration"
      dependencies = "How to pass outputs from one module to another"
      conditional  = "How to conditionally deploy modules based on variables"
      source_paths = "How to reference local modules with relative paths"
    }

    advanced_concepts = {
      progressive_deployment = "Deploy infrastructure in stages (teams first, then drivers)"
      single_state_file      = "Manage all resources in one state file (best practice)"
      module_outputs         = "How to surface module outputs through root outputs"
      conditional_outputs    = "How to handle outputs when modules aren't deployed"
    }
  }
}

output "terraform_best_practices_demonstrated" {
  description = "Best practices shown in this modular architecture"
  value = {
    module_design = {
      single_responsibility = "Each module has a clear, focused purpose"
      reusability           = "Modules can be reused in different configurations"
      testability           = "Modules can be tested independently"
      encapsulation         = "Module internals are hidden, only exposing necessary outputs"
    }

    state_management = {
      single_state        = "All resources managed in one state file"
      no_state_conflicts  = "No multiple state files managing same resources"
      proper_dependencies = "Module dependencies properly expressed"
    }

    variable_design = {
      progressive_control = "Variables control which modules deploy"
      validation          = "Input validation ensures data quality"
      sensible_defaults   = "Good defaults allow easy experimentation"
    }

    real_world_patterns = {
      conditional_deployment = "Deploy different configurations for different environments"
      module_composition     = "Combine specialized modules into complete solutions"
      progressive_rollout    = "Deploy infrastructure incrementally"
    }
  }
}

# NEXT STEPS GUIDANCE
output "next_steps" {
  description = "What to do next in your Terraform journey"
  value = {
    current_deployment = var.enable_drivers ? "Full lab (teams + drivers)" : "Teams only"

    immediate_actions = var.enable_drivers ? [
      "1. Verify all resources in Okta admin console",
      "2. Try modifying variables and re-applying",
      "3. Experiment with adding new teams or drivers"
      ] : [
      "1. Verify teams exist in Okta admin console",
      "2. Set enable_drivers = true in terraform.tfvars",
      "3. Run terraform plan to see the driver module changes",
      "4. Run terraform apply to deploy drivers"
    ]

    advanced_exercises = [
      "Add a fifth racing team by modifying the racing_teams variable",
      "Create a new module for racing applications (OAuth apps)",
      "Add module for group rules based on driver attributes",
      "Experiment with terraform workspaces for multiple environments"
    ]

    production_considerations = [
      "Use remote state (S3 + DynamoDB for locking)",
      "Implement proper CI/CD with terraform plan in PRs",
      "Add module versioning with git tags",
      "Consider using terraform-docs for module documentation"
    ]
  }
}

# DEPLOYMENT SUMMARY
output "deployment_summary" {
  description = "Summary of what was deployed in this run"
  value = {
    timestamp = timestamp()
    season    = var.racing_season

    modules_deployed = {
      racing_teams   = true
      racing_drivers = var.enable_drivers
    }

    resource_counts = {
      teams   = module.racing_teams.total_teams
      drivers = var.enable_drivers ? local.driver_outputs.driver_count : 0
    }

    configuration = {
      teams_enabled           = true
      drivers_enabled         = var.enable_drivers
      example_drivers_created = var.enable_drivers ? var.create_example_drivers : false
    }
  }
}