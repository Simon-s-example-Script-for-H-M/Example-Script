/*--------------------------------------------------
#------------resource group parameters--------------
---------------------------------------------------*/

#-----resource gruop
variable "rg_name" {
  description = "resource-group-name"
  type        = string
  default     = "rg-simons-infra"
}

variable "rg_location" {
  description = "resource-group-location"
  type        = string
  default     = "North Europe"
}

#-----tag parameters
variable "env" {
  description = "Name of environment"
  type        = string
  default     = "01"
}

#-----azure key-vault
variable "kv_name" {
  description = "Name of azure key-vault"
  type        = string
  default     = "kv-simons-infra"
}

/*--------------------------------------------------
#---------------module parameters-----------------
---------------------------------------------------*/


#-----module data ingestion parameters
#raw-blob storage
variable "st_name" {
  description = "storage account name"
  type        = string
  default     = "stsimonsinfra"
}

variable "ci_name" {
  description = "container name"
  type        = string
  default     = "rawdata"
}

variable "adf_name" {
  description = "data factory name"
  type        = string
  default     = "adf-simons-infra"
}

#processed-datalake
variable "st_datalake_name" {
  description = "storage account name"
  type        = string
  default     = "dlsimonsinfra"
}

variable "dls_filesystem_name" {
  description = "data lake storage file system name"
  type        = string
  default     = "processed"
}


#--module github repo parameters---

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

#--pipeline configuration-----
variable "source_path" {
  description = "raw data source path"
  type        = string
}

variable "source_data_format" {
  description = "source format for the data factory pipeline"
  type        = string
}

variable "source_file_name" {
  description = "file name for the downloaded raw data"
  type        = string
}

variable "sink_format" {
  description = "sink format for the data factory pipeline"
  type        = string
}

variable "pipeline_name" {
  description = "name for data factory pipeline"
  type        = string
}


