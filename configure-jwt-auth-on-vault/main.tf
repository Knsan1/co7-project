resource "vault_jwt_auth_backend" "jwt" {
  path = "jwt"
}

resource "vault_jwt_auth_backend_role" "example" {
  backend         = vault_jwt_auth_backend.jwt.path
  role_name       = "test-role"
  token_policies  = ["default", "dev", "prod"]

  bound_audiences = ["https://myco.test"]
  bound_claims = {
    color = "red,green,blue"
  }
  user_claim      = "https://vault/user"
  role_type       = "jwt"
}



resource "vault_policy" "example" {
  name = "dev-team"

  policy = <<EOT
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
# Create, update, and delete auth methods
path "sys/auth/*"
{
  capabilities = ["create", "update", "delete", "sudo"]
}
# List auth methods
path "sys/auth"
{
  capabilities = ["read"]
}
# Enable and manage the key/value secrets engine at `secret/` path
# List, create, update, and delete key/value secrets
path "secret/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
# Manage secrets engines
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
# List existing secrets engines.
path "sys/mounts"
{
  capabilities = ["read"]
}
path "aws-master-account/" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "aws-master-account/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/policy/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/policy/" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "sys/mounts/example" {
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}
path "example/*" {
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}

EOT
}

resource "vault_jwt_auth_backend_role" "admin_role" {
  backend = vault_jwt_auth_backend.tfc_jwt.path
  role_name = var.admin_role
  token_policies = [vault_policy.tfc_dpc_aws_secret_policy.name]
  bound_audiences = [var.tfc_vault_audience]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${var.tfc_workspace_name}:run_phase:*"
  }
  user_claim = "terraform_full_workspace"
  role_type  = "jwt"
  token_ttl  = 1200
}