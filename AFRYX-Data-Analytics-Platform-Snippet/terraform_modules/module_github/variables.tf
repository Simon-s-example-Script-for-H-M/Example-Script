#github
variable "env" {
  description = "environment tag"
  type        = string
}

variable "github_pat" {
  description = "Personal Access Token for Github"
  type        = string
}

variable "github_organization" {
  description = "Organization for Github"
  type        = string
}

variable "github_team_username" {
  description = "Username assigned to the Github team"
  type        = string
}

# pipeline
variable "pipeline_name" {
  description = "name of pipeline"
  type        = string
}