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

module "backend" {
  source                  = "./backend"

  env_name                = var.env_name
  resource_group_location = "West Europe"
  ghost_db_username       = "tikrekryadmin"
}

 module "frontend" {
  source                  = "./frontend"
  
  env_name                = var.env_name
  resource_group_name     = module.backend.resource_group_name
  resource_group_location = module.backend.resource_group_location
  ghost_front_url         = var.ghost_front_url

  mysql_fqdn              = module.backend.mysql_fqdn
  mysql_connection_user   = module.backend.mysql_connection_user
  mysql_password          = module.backend.mysql_password

  storage_account_name    = module.backend.storage_account_name
  storage_account_key     = module.backend.storage_account_key
  storage_share_name      = module.backend.storage_share_name

  ghost_mail_host         = var.ghost_mail_host
  ghost_mail_port         = var.ghost_mail_port
  ghost_mail_username     = var.ghost_mail_username
  ghost_mail_password     = var.ghost_mail_password
}
