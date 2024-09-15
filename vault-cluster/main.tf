resource "hcp_hvn" "vault_hvn" {
  hvn_id         = "co7-hvn"
  cloud_provider = "aws"
  region         = "ap-southeast-1"
  cidr_block     = "172.25.16.0/20"
}

resource "hcp_vault_cluster" "vault_cluster" {
  cluster_id = "co7-vault-cluster"
  hvn_id     = hcp_hvn.vault_hvn.hvn_id
  tier       = "dev"
  public_endpoint = true
}

resource "hcp_vault_cluster_admin_token" "admin_token" {
  cluster_id = hcp_vault_cluster.vault_cluster.cluster_id
}