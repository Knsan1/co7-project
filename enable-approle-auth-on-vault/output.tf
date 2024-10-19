output "Role_ID" {
  value     = vault_approle_auth_backend_role.aws_approle.role_id
  sensitive = true
}

output "Secret_ID" {
  value     = vault_approle_auth_backend_role_secret_id.id.secret_id
  sensitive = true
}