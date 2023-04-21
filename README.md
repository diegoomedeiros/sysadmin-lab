# sysadmin-lab

## Recursos Necessários
- Criar uma credencial através do IAM com permissão para manipular o servido de EC2 no AWS.
- Ter o Terraform instalado:
https://developer.hashicorp.com/terraform/downloads?product_intent=terraform
- Ter o AWS Cli instalado:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

## Antes de começar:
- Configurar o AWS CLi com a credencial criada (Access Key e Secret Access Key)
 ```
    aws configure 
 ```
- Criar arquivos de configuração do terraform:
 ```
 # arquivo aws_provider.tf
 terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
# Provider
provider "aws" {
  profile = "default"
  region  = var.region
}
 
 # arquivo aws_variaveis.tf
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
 ```
- Inicialiar terraform e baixar provider:
 ```
 terraform init  
 ```
## Primeira Task - Criar uma EC2 Linux e disponibilizar a aplicação (/app/index.html).
### Criar compentes de Rede:
- VPC -  https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
    ```
    # VPC
    resource "aws_vpc" "lab-vpc" {
    cidr_block           = "10.1.0.0/16"
    enable_dns_hostnames = "true"
    tags = {
        env = var.env
        }
    }
    ```
- Subrede -  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
    ```
    # Subrede Pública
    resource "aws_subnet" "lab-subnet-1" {
    vpc_id                  = aws_vpc.lab-vpc.id  // Referencia a VPC criada acima
    cidr_block              = "10.1.1.0/24"
    map_public_ip_on_launch = "true" // subnet pública
    tags = {
        env = var.env
        }
    }   
    ``` 
- Internet Gateway - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
    ```
    # Internet Gateway
    resource "aws_internet_gateway" "lab-gw" {
    vpc_id = aws_vpc.lab-vpc.id  // Referencia a VPC criada acima
    tags = {
        env = var.env
        }
    }
    ```
- Tabela de Rotas - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
	``` 
    # Route table 
    resource "aws_route_table" "lab-public-rt" {
    vpc_id = aws_vpc.lab-vpc.id // Referencia a VPC criada acima
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.lab-gw.id // Referencia o Internet Gateway criado acima
    }
    tags = {
        env = var.env
        }
    }
    ```
- Associação da tabela de rotas com o a subrede - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
	``` 
    # Route table e public subnets
    resource "aws_route_table_association" "lab-rt-public-subnet-1" {
    subnet_id      = aws_subnet.lab-subnet-1.id  // Referencia a subrede criada acima
    route_table_id = aws_route_table.lab-public-rt.id // Referencia a tabela de rota criada acima
    }
    ```
 - Security Group - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
    ```
    # Security group
    resource "aws_security_group" "ssh_http_allowed" {
    vpc_id      = aws_vpc.lab-vpc.id  // Referencia a VPC criada acima
    name        = "ssh_http_allowed"
    description = "Libera entrada de trafego SSH e HTTP e saída"

    egress { //Saída liberada
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { //Entrada liberada na porta 22 para toda a internet
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { //Entrada liberada na porta 80 para toda internet
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        env = var.env
     }
    }
    ```
### Criar chaves de acesso 
- Key Pair
    ```
    # Criar chave privada.
    resource "tls_private_key" "key_pair" {
    algorithm = "RSA"
    rsa_bits  = 4096
    }
    # Gera a chave pública.
    resource "aws_key_pair" "key_pair" {
    key_name   = "lab-key-pair"
    public_key = tls_private_key.key_pair.public_key_openssh
    }
    # Salva a chave privada em um arquivo local para conexao ssh.
    resource "local_file" "ssh_key" {
    filename = "${aws_key_pair.key_pair.key_name}.pem"
    content  = tls_private_key.key_pair.private_key_pem
    }
    ```
### Criar Instância EC2
	Instância EC2
	Instalação das dependencias necessárias
	Implantação da aplicação Web

### Aplicar IaC com Terraform
	Executar comando `terraform fmt` para corrigir problema de formatação nos arquivos `.tf` .
	Executar comando `terraform plan` para que o terraform verifique os arquivos de configuração elaborados e crie um plano de execução.
	Executar comando `terraform apply` para criar os componentes na AWS conforme especificado no plano de execução.

## Segunda Task - Criar um servidor Windows e disponibilizar o serviço de DNS.
