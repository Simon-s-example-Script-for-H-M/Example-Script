#authentication parameters
variable "client_principal_id" {
  description = "client-principal-id"
  type        = string
}

variable "client_tenant_id" {
  description = "client-tenant-id"
  type        = string
}


variable "rg_scope" {
  description = "resource-group-scope"
  type        = string
}

#resource group
variable "rg_name" {
  description = "resource-group-name"
  type        = string
}

variable "rg_location" {
  description = "resource-group-location"
  type        = string
}

#tag parameters
variable "env" {
  description = "Name of environment"
  type        = string
}

#storage 
#raw-001
variable "st_name" {
  description = "storage account name"
  type        = string
}

variable "ci_name" {
  description = "container name"
  type        = string
}


#processed-002
variable "st_datalake_name" {
  description = "storage account name"
  type        = string
}

variable "dls_filesystem_name" {
  description = "data lake storage file system name"
  type        = string
}

#datafactory

variable "adf_name" {
  description = "data factory name"
  type        = string
}

#github
variable "github_organization" {
  description = "Organization for Github"
  type        = string
}

#pipeline configuration
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
