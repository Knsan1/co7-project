output "aws_auth_role_name" {
  value = vault_aws_auth_backend_role.aws.role_id
}

output "instance_profile_id" {
  value = aws_iam_instance_profile.vault-client.id
}