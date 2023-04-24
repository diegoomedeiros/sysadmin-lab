#Declaracao de variaveis do terraform
variable "region" {
  default     = "us-east-1"
  description = "Default Region"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Default Instance Type"
}

variable "env" {
  default     = "dev"
  description = "Default Env Tag Value"
}

variable "vpc_cidr_block" {
  default = "10.1.0.0/16"
}

variable "subrede_cidr_block" {
  default = "10.1.1.0/24"
}

variable "win_private_ip" {
  default = "10.1.1.20"
}

variable "lnx_private_ip" {
  default = "10.1.1.10"
}

variable "backup_schedule" {
  default = "cron(0 0 * * ? *)" /* UTC Time */
}
variable "backup_retention" {
  default = 7
}
