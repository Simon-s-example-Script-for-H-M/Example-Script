output "dl_primary_access_key" {
    value = azurerm_storage_account.storage_lake.primary_access_key
}

output "dl_st_name" {
    value = azurerm_storage_account.storage_lake.name
}

output "dls_filesystem_name" {
    value = azurerm_storage_data_lake_gen2_filesystem.data_lake.name
}

output "storage_account_name" {  
    value = azurerm_storage_account.storage.name
}

output "storage_account_id" {
    value = azurerm_storage_account.storage.id
}

output "storage_account_uri" {
    value = azurerm_storage_account.storage.primary_blob_endpoint
}

output "storage_container_name" { 
    value = azurerm_storage_container.container.name
}

output "datalake_account_name" {
    value = azurerm_storage_account.storage_lake.name
}

output "datalake_container_name" {
    value = azurerm_storage_data_lake_gen2_filesystem.data_lake.name
}
