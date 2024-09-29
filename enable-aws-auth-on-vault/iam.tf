resource "aws_iam_user" "lb" {
  name = "vault-auth-admin"
  path = "/"

}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.lb.name
}

data "aws_iam_policy_document" "vault-server" {
  statement {
    sid    = "VaultAWSAuthMethod"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:ListRoles",
      "iam:GetRole"
    ]
    resources = ["*"]
  }
}


resource "aws_iam_user_policy" "lb_ro" {
  name   = "vault-auth-policy"
  user   = aws_iam_user.lb.name
  policy = data.aws_iam_policy_document.vault-server.json
}

##Create IAM Role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "AWS_EC2_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "vault-client" {
  name = "vault-client-instance-profile"
  role = aws_iam_role.ec2_role.id
}