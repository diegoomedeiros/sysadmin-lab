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
