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
    account_name = var.storage_account_name
    access_key   = var.storage_account_key
    share_name   = var.storage_share_name
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
    url = var.ghost_front_url
    
    # Database
    database__client                     = "mysql"
    database__connection__host           = var.mysql_fqdn
    database__connection__user           = var.mysql_connection_user
    database__connection__password       = var.mysql_password
    database__connection__database       = "ghost"
    database__connection__ssl            = "true"
    database__connection__ssl_minVersion = "TLSv1.2"
    
    # Email
    mail__transport           = "SMTP"
    mail__options__service    = "Mailgun"
    mail__options__host       = var.ghost_mail_host
    mail__options__port       = var.ghost_mail_port
    mail__options__secure     = "true"
    mail__options__auth__user = var.ghost_mail_username
    mail__options__auth__pass = var.ghost_mail_password
  }
}
