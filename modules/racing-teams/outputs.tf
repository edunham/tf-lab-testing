# Racing Teams Module - Outputs
# These outputs are used by other modules and the root configuration

# Export key resource attributes for other modules
output "team_ids" {
  description = "Map of team keys to their Okta group IDs"
  value       = local.team_id_map
}

output "team_names" {
  description = "Map of team keys to their display names"
  value       = local.team_display_names
}

output "team_summary" {
  description = "Complete summary of all team information"
  value       = local.team_summary
}

output "teams_by_specialty" {
  description = "Teams organized by their specialty"
  value       = local.teams_by_specialty
}

output "total_teams" {
  description = "Total number of teams created"
  value       = local.total_teams
}

# Export computed statistics for root module outputs
output "team_statistics" {
  description = "Computed team statistics"
  value = {
    total_teams          = local.total_teams
    specialties          = distinct([for team in var.racing_teams : team.specialty])
    circuits_represented = distinct([for team in var.racing_teams : team.home_circuit])
    team_colors          = distinct([for team in var.racing_teams : team.team_color])
    teams_by_specialty   = local.teams_by_specialty
    average_team_age     = floor((tonumber(var.racing_season) - (sum([for team in var.racing_teams : team.founded_year]) / length(var.racing_teams))))
  }
}