provider "github" {
  token = var.github_pat
  organization = var.github_organization
}

resource "github_repository" "github-repo" {
  name        = "simons-infra-repo-${var.env}"
  description = "repo to store all developments made for data factory in Simon's example infrasturcture"

  visibility = "private"
  auto_init = true

  default_branch = "main"
}

resource "github_team" "github-team" {
  name        = "simons-infra-repo-team-${var.env}"
  description = "Developer team to work with datafactory in "
  privacy     = "closed"
}

resource "github_team_membership" "team-member1" {
  team_id  = "${github_team.github-team.id}"
  username = var.github_team_username
  role     = "member"
}

resource "github_team_repository" "AXD-time-series-analysis-team-repo" {
  team_id    = "${github_team.github-team.id}"
  repository = "${github_repository.github-repo.name}"
  permission = "admin"
}

resource "github_repository_file" "dst_datalake_csv" {
  repository = github_repository.github-repo.name
  branch     = "main"
  file       = "dataset/dst_datalake_csv.json"
  content    = file("../../adf/dataset/dst_datalake_csv.json")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "dst_datalake_json" {
  repository = github_repository.github-repo.name
  branch     = "main"
  file       = "dataset/dst_datalake_json.json"
  content    = file("../../adf/dataset/dst_datalake_json.json")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "dst_datalake_parquet" {
  repository = github_repository.github-repo.name
  branch     = "main"
  file       = "dataset/dst_datalake_parquet.json"
  content    = file("../../adf/dataset/dst_datalake_parquet.json")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "src_blob_csv" {
  repository = github_repository.github-repo.name
  branch     = "main"
  file       = "dataset/src_blob_csv.json"
  content    = file("../../adf/dataset/src_blob_csv.json")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "src_blob_excel" {
  repository = github_repository.github-repo.name
  branch     = "main"
  file       = "dataset/src_blob_excel.json"
  content    = file("../../adf/dataset/src_blob_excel.json")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "src_blob_json" {
  repository = github_repository.github-repo.name
  branch     = "main"
  file       = "dataset/src_blob_json.json"
  content    = file("../../adf/dataset/src_blob_json.json")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "linkedService_AzureBlobStorage" {
  repository = github_repository.github-repo.name
  branch     = "main"
  file       = "linkedService/AzureBlobStorage.json"
  content    = file("../../adf/linkedService/AzureBlobStorage.json")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "linkedService_AzureDataLakeStorage" {
  repository = github_repository.github-repo.name
  branch     = "main"
  file       = "linkedService/AzureDataLakeStorage.json"
  content    = file("../../adf/linkedService/AzureDataLakeStorage.json")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "trigger_universal_trigger" {
  repository = github_repository.github-repo.name
  branch     = "main"
  file       = "trigger/universal_trigger.json"
  content    = file("../../adf/trigger/universal_trigger.json")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_repository_file" "pipeline" {
  repository = github_repository.github-repo.name
  branch     = "main"
  file       = "pipeline/${var.pipeline_name}.json"
  content    = file("../../adf/pipeline/${var.pipeline_name}.json")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}