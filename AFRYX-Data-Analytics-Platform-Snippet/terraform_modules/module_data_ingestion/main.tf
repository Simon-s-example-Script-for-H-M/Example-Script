terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = "${var.st_name}${var.env}"
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    resource-group-name = var.rg_name
    env                 = var.env
    format              = "excel, csv and json"
  }
}

resource "null_resource" "run_python_script_trigger" {
  triggers = {
    "name" = azurerm_storage_account.storage.id
  }
  provisioner "local-exec" {
    command = format("python ../../adf/functions/change_trigger.py '%s'", azurerm_storage_account.storage.id)
  }
}

resource "null_resource" "run_python_script_dst_datalake1" {
  triggers = {
    "name" = azurerm_storage_data_lake_gen2_filesystem.data_lake.name
  }
  provisioner "local-exec" {
    command = format("python ../../adf/functions/change_dst_datalake.py '%s' '%s'", azurerm_storage_data_lake_gen2_filesystem.data_lake.name, azurerm_storage_container.container.name)
  }
}

resource "null_resource" "run_python_script_dst_datalake2" {
  triggers = {
    "name" = azurerm_storage_container.container.name
  }
  provisioner "local-exec" {
    command = format("python ../../adf/functions/change_dst_datalake.py '%s' '%s'", azurerm_storage_data_lake_gen2_filesystem.data_lake.name, azurerm_storage_container.container.name)
  }
}

resource "null_resource" "run_python_script_linked_service1" {
  triggers = {
    "name" = azurerm_storage_account.storage.name
  }
  provisioner "local-exec" {
    command = format("python ../../adf/functions/change_linked_service.py '%s' '%s'", azurerm_storage_account.storage.name, azurerm_storage_account.storage_lake.name)
  }
}

resource "null_resource" "run_python_script_linked_service2" {
  triggers = {
    "name" = azurerm_storage_account.storage_lake.name
  }
  provisioner "local-exec" {
    command = format("python ../../adf/functions/change_linked_service.py '%s' '%s'", azurerm_storage_account.storage.name, azurerm_storage_account.storage_lake.name)
  }
}

resource "null_resource" "run_create_pipeline" {
  triggers = {
    "name" = var.source_path
  }
  provisioner "local-exec" {
    command = format("python ../../adf/create_pipeline.py '%s' '%s' '%s' '%s' '%s' '%s'", azurerm_storage_account.storage.primary_connection_string, var.source_path, var.source_data_format, var.source_file_name, var.sink_format, var.pipeline_name)
  }
}

# allow creation and management of storage resources 
resource "azurerm_role_assignment" "blob_contributor" {
  scope                = var.rg_scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.client_principal_id
}

resource "azurerm_storage_container" "container" {
  name                  = var.ci_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"

  depends_on = [
    azurerm_storage_account.storage,
  ]
}

resource "azurerm_data_factory" "datafactory" {
  name                = format("%s%s","${var.adf_name}-","${var.env}")
  resource_group_name = var.rg_name
  location            = var.rg_location

  identity {
    type = "SystemAssigned"
  }

  github_configuration {
    account_name    = var.github_organization
    branch_name     = "main"#var.github_branch_name
    git_url         = "https://github.com"
    repository_name = "simons-infra-repo-${var.env}"
    root_folder     = "/"
  }

  tags =  {
    resource-group-name = var.rg_name
  }
}

resource "azurerm_role_assignment" "blob_read" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_data_factory.datafactory.identity[0].principal_id
}

/*
                    Create a data lake
*/
resource "azurerm_storage_account" "storage_lake" {
  name                     = "${var.st_datalake_name}${var.env}"
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"

    tags =  {
    resource-group-name = var.rg_name
    env = var.env
    format = "csv, json and parquet"
  }
}


resource "azurerm_role_assignment" "data_lake_contribute" {
  scope                = azurerm_storage_account.storage_lake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.datafactory.identity[0].principal_id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "data_lake" {
  name               = "${var.dls_filesystem_name}${var.env}"
  storage_account_id = azurerm_storage_account.storage_lake.id

  depends_on = [
    azurerm_storage_account.storage_lake,
  ]
}

# resource "azurerm_storage_blob" "uploadfile" {
#   name                   = "Natural Gas EU - PNGASEUUSDM.xls"
#   storage_account_name   = azurerm_storage_account.storage.name
#   storage_container_name = azurerm_storage_container.container.name
#   type                   = "Block"
#   source                 = "../../utils/Natural Gas EU - PNGASEUUSDM.xls"
#   depends_on = [
#     azurerm_storage_account.storage_lake,
#     azurerm_storage_account.storage,
#     azurerm_data_factory.datafactory
#   ]
# }
