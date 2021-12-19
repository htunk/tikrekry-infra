terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.57.0"
    }
  }
}

provider "azurerm" {
  features {}
}

/* Actual module code below*/

resource "azurerm_mysql_server" "tikjob_mysql" {
  name                = "tikjob-ghost-database"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  administrator_login          = var.ghost_db_username
  administrator_login_password = var.ghost_db_password

  sku_name   = "B_Gen5_1"
  storage_mb = 5120 #MB
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

/* STORAGE */

resource "azurerm_storage_account" "tikjob_storage_account" {
  name                     = "tikjobpersistentcontent"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "tikjob_storage_share" {
  name                 = "ghost-content"
  storage_account_name = azurerm_storage_account.tikjob_storage_account.name
  quota                = 2 #GB
}



resource "azurerm_app_service_plan" "tikjob_plan" {
  name                = "tikjob-${var.env_name}-plan"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  kind     = "linux"
  reserved = true # Needs to be true for linux

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "tikjob_ghost" {
  name                = "tikjob-${var.env_name}-app-ghost"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.tikjob_plan.id

  https_only = true

  site_config {
    ftps_state       = "Disabled"
    always_on        = true
    linux_fx_version = "DOCKER|docker.io/library/ghost:4-alpine"
  }
  
  storage_account {
    name         = "ghost-persistent-content-files"
    type         = "AzureFiles"
    account_name = azurerm_storage_account.tikjob_storage_account.name
    access_key   = azurerm_storage_account.tikjob_storage_account.primary_access_key
    share_name   = azurerm_storage_share.tikjob_storage_share.name
    mount_path   = "/var/lib/ghost/content"
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 100
      }
    }
  }

  app_settings = {
    HOST              = "0.0.0.0"
    PORT              = 2368
    
    # GHOST CONFIGURATION
    #url = var.ghost_front_url
    
    # Database
    database__client = "mysql"
    database__connection__host = azurerm_mysql_server.tikjob_mysql.fqdn
    database__connection__user = "${azurerm_mysql_server.tikjob_mysql.administrator_login}@${azurerm_mysql_server.tikjob_mysql.name}"
    database__connection__password = var.ghost_db_password
    database__connection__database = "ghost"
    database__connection__ssl = "true"
    database__connection__ssl_minVersion = "TLSv1.2"
    
    # Email
    mail__transport = "SMTP"
    mail__options__service = "Mailgun"
    mail__options__host = var.ghost_mail_host
    mail__options__port = var.ghost_mail_port
    mail__options__secure = "false"
    mail__options__auth__user = var.ghost_mail_username
    mail__options__auth__pass = var.ghost_mail_password
  }
}

# Enable access from other Azure services
resource "azurerm_mysql_firewall_rule" "tikjob_mysql_access" {
  name                = "tikjob-${var.env_name}-mysql-access"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.tikjob_mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
