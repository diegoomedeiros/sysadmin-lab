# sysadmin-lab

# Recursos Necessários
- Credencial com permissão para manipular o servido de EC2 no AWS.
- Terraform
https://developer.hashicorp.com/terraform/downloads?product_intent=terraform
- AWS Cli
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

# Antes de começar:
- Configurar o AWS CLi com a credencial criada (Access Key e Secret Access Key)
    aws configure 

- Inicializar o terraform e realizar download do provider: (necessário arquivos aws_provider.tf e aws_variaveis.tf):
   terraform init #Download do provider 

# Primeira Task - Criar uma EC2 Linux e disponibilizar a aplicação (/app/index.html).
## Criar compentes de Rede:
	VPC
	Subrede
	Internet Gateway
	Tabela de Rotas
	Associacao da tabela de rotas com o a subrede
	Security Group

## Criar chaves de acesso 
	Key Pair

## Criar Instância EC2
	Instância EC2
	Instalação das dependencias necessárias
	Implantação da aplicação Web

## Aplicar IaC com Terraform
	Executar comando "terraform fmt" para formatar os arquivos de forma correta.
	Executar comando "terraform plan" para que o terraform verifique os arquivos de configuração elaborados e crie um plano de execução.
	Executar comando "terraform apply" para criar os componentes na AWS conforme especificado no plano de execução.
