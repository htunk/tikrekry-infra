# tikrekry-infra
Terraform scripts to deploy Tietokilta recruiting platform on Azure.
This repository is for the initial development of the scripts.

## Running
As this is just a development repostitory, the Terraform state is not stored anywhere and held offline.

1. Log in to Azure CLI and select the subscription you want to use. ([See guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli))

2.  `terraform init`

3.  `terraform plan -var-file="ghost-variables.tfvars"` or 
     `terraform apply -var-file="ghost-variables.tfvars"`

Be adviced, the Ghost frontend is available under the automatically generated Azure domain. **If you wish to use a custom domain, you must add/configure SSL certificates manually!**

  

## Variables
Ghost related variables are defined and retrieved from `ghost-variables.tfvars` file.

| variable | description |
|--|--|
| env_name | Environment name, e.g. "prod", "dev"... |
|ghost_front_url| URL for the Ghost frontend. Must be provided with protocol, eg. "**https://**<span>my-ghost-blog</span>.com"|
|ghost_mail_host| Host URL for the SMTP mailing, e.g. "<span>smtp.eu.mailgun</span>.org"|
|ghost_mail_port| Port used for SMTP|
|ghost_mail_username| Username for SMTP|
|ghost_mail_password| Password for SMTP|

  

For SMTP related variables [more information here](https://ghost.org/docs/config/#mail).

**Only env_name is required to match the running instances when destroying resources!**

## Modules

### Backend
The module contains MySQL database for Ghost as well as persistent storage for platform posts, images, etc. This module creates the resource group for the platform.

### Frontend
This module contains a Ghost container running in Azure App Service.