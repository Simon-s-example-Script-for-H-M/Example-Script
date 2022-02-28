terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }

      github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

provider "github" {
  token = var.github_pat
  organization = var.github_organization
}

# Use this data source to access the configuration of the AzureRM provider.
data "azurerm_client_config" "current" {
}


resource "azurerm_resource_group" "rg" {
  name     = format("%s-%s", var.rg_name, var.env)
  location = var.rg_location
}

resource "azurerm_key_vault" "axd" {
  name                        =  "${var.kv_name}-${var.env}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Update", "Delete",
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Purge"
    ]

    storage_permissions = [
      "Get", "List",
    ]
  }

  tags = {
    resource-group-name = azurerm_resource_group.rg.name
  }
}


module "data_ingestion" {
  source = "../../terraform_modules/module_data_ingestion"
  #static parameters
  env                   = "${var.env}"

  st_name       = "${var.st_name}"
  ci_name               = "${var.ci_name}"
  st_datalake_name      = "${var.st_datalake_name}"
  dls_filesystem_name   = "${var.dls_filesystem_name}"
  adf_name              ="${var.adf_name}"

  github_organization = "${var.github_organization}"

  source_path = "${var.source_path}"
  source_data_format = "${var.source_data_format}"
  source_file_name = "${var.source_file_name}"
  sink_format = "${var.sink_format}"
  pipeline_name = "${var.pipeline_name}"

  # #dynamical parameters 
  rg_name             = azurerm_resource_group.rg.name
  rg_location         = azurerm_resource_group.rg.location
  rg_scope            = azurerm_resource_group.rg.id
  client_principal_id = data.azurerm_client_config.current.object_id
  client_tenant_id    = data.azurerm_client_config.current.tenant_id
}

module "github" {
  source = "../../terraform_modules/module_github"
  env                   = "${var.env}"

  github_pat = "${var.github_pat}"
  github_organization = "${var.github_organization}"
  github_team_username = "${var.github_team_username}"

  pipeline_name = "${var.pipeline_name}"
}