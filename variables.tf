variable "env_name" {
  type = string
}

variable "ghost_front_url" {
  type = string
}

/* Ghost SMTP settings */
variable "ghost_mail_host" {
  type = string
}

variable "ghost_mail_port" {
  type = number
}

variable "ghost_mail_username" {
  type = string
}

variable "ghost_mail_password" {
  type = string
}
