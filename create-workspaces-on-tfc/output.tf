output "workspaces_with_directories" {
  description = "List of created Terraform Cloud workspaces with their working directories, organization, and project"
  value = {
    for ws, dir in var.workspaces : ws => {
      "github_repo"      = var.repo_name,
      "working_directory"    = dir,
      "organization" = var.organization_name,
      "project"      = var.project_name
    }
  }
}
