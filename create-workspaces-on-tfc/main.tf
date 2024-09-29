provider "tfe" {
  hostname = "app.terraform.io" # or your HCP Terraform hostname
}

# Read Terraform Cloud Organization
data "tfe_organization" "my_org" {
  name = var.organization_name # Replace with your desired organization name
}

# Read Terraform Cloud Project under the organization
data "tfe_project" "my_project" {
  name         = var.project_name                  # Replace with your desired project name
  organization = data.tfe_organization.my_org.name # Link to the organization
}

data "tfe_oauth_client" "github" {
  organization     = data.tfe_organization.my_org.name
  service_provider = "github"
  name             = var.git_vcs_name
}

####Manual Connect between TFC and Github
# Create workspaces with variables
resource "tfe_workspace" "workspace" {
  for_each               = var.workspaces
  name                   = each.key
  organization           = data.tfe_organization.my_org.name
  project_id             = data.tfe_project.my_project.id
  description            = "Workspace for handling ${each.key}"
  allow_destroy_plan     = true
  auto_apply_run_trigger = true
  file_triggers_enabled  = true
  queue_all_runs         = false
  working_directory      = each.value
  tag_names              = var.tag_names

  vcs_repo {
    identifier     = var.repo_name                               # Use the variable for GitHub repo
    branch         = var.branch_name                             # Use the variable for branch
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id # OAuth token from tfe_oauth_client
  }
}

