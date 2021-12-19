variable "env_name" {
  type = string
}

variable "ghost_front_url" {
  type = string
  default = "https://rekry.tietokilta.fi"
}

variable "resource_group_name" {
  type = string
  default = "recruiting-platform"
}

variable "resource_group_location" {
  type = string
  default = "West Europe"
}

variable "ghost_db_username" {
  type = string
  default = "tikrekryadmin"
}

variable "ghost_db_password" {
  type = string
}

variable "ghost_mail_host" {
  type = string
  default = "smtp.eu.mailgun.org"
}

variable "ghost_mail_port" {
  type = number
  default = 587
}

variable "ghost_mail_username" {
  type = string
}

variable "ghost_mail_password" {
  type = string
}