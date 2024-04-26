resource "github_repository_branch" "update_branch" {
  repository = "test terraform"
  branch     = "update-version-${var.program_version}"
  source_branch = "main"
}

# Use the new branch in the Dockerfile resource
resource "github_repository_file" "dockerfile" {
  repository  = "test-terraform"
  branch      = github_repository_branch.update_branch.branch
  file        = ".devcontainer/Dockerfile"
  content     = <<-EOF
                FROM ghcr.io/the-exploration-company/scaling-carnival:${var.program_version}
                RUN apt-get update && apt-get install -y graphviz
                USER vscode
                EOF
  commit_message = "Update Dockerfile to version ${var.program_version}"
}

resource "github_repository_pull_request" "update_pr" {
  base_repository = "test-terraform"
  base_branch     = "main"
  head_branch     = github_repository_branch.update_branch.branch
  title           = "Update Dockerfile to version ${var.program_version}"
  body            = "This PR updates the Dockerfile to the new program version."
}