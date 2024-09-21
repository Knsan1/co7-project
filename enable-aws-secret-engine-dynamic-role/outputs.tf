output "aws_access_key" {
  description = "Dynamic Role iam user access key"
  value = data.vault_aws_access_credentials.creds.access_key
}

output "aws_secret_key" {
  description = "Dynamic Role iam user access key"
  value = data.vault_aws_access_credentials.creds.secret_key
}