resource "vault_aws_secret_backend" "aws" {
  access_key                = aws_iam_access_key.vault_admin.id
  secret_key                = aws_iam_access_key.vault_admin.secret
  region                    = "ap-southeast-1"
  path                      = "aws-master-account"
  default_lease_ttl_seconds = 900
  max_lease_ttl_seconds     = 1500
}

resource "vault_aws_secret_backend_role" "role" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "master-adminaccess-role"
  credential_type = "iam_user"
  policy_arns     = ["arn:aws:iam::aws:policy/AdministratorAccess"]

}

resource "time_sleep" "wait_before_fetching_creds" {
  depends_on      = [vault_aws_secret_backend_role.role]
  create_duration = "10s"
}

# generally, these blocks would be in a different module
data "vault_aws_access_credentials" "creds" {
  depends_on = [time_sleep.wait_before_fetching_creds]
  backend = vault_aws_secret_backend.aws.path
  role    = vault_aws_secret_backend_role.role.name
}
