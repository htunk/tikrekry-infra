output "resource_group_name" {
  value = azurerm_resource_group.tikjob_rg.name
}

output "resource_group_location" {
  value = azurerm_resource_group.tikjob_rg.location
}

/* MySQL */
output "mysql_fqdn" {
  value = azurerm_mysql_server.tikjob_mysql.fqdn
}

output "mysql_connection_user" {
  value = "${azurerm_mysql_server.tikjob_mysql.administrator_login}@${azurerm_mysql_server.tikjob_mysql.name}"
}

output "mysql_password" {
  value = azurerm_mysql_server.tikjob_mysql.administrator_login_password
}

/* Storage */
output "storage_account_name" {
  value = azurerm_storage_account.tikjob_storage_account.name
}

output "storage_account_key" {
  value = azurerm_storage_account.tikjob_storage_account.primary_access_key
}

output "storage_share_name" {
  value = azurerm_storage_share.tikjob_storage_share.name
}
