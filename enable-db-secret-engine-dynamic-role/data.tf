###Reading Output Data from workspace state 
data "terraform_remote_state" "rds" {
  backend = "remote"
  config = {
    organization = "Hellocloud-kns"
    workspaces = {
      name = "create-ec2-and-rds_Step08"
    }
  }
}