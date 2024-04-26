provider "github" {
  token        = var.github_token
  owner        = var.github_owner
}

variable "github_token" {}
variable "github_owner" {}