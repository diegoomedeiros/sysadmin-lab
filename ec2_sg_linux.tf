# Security group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "ssh_http_allowed" {
  vpc_id      = aws_vpc.lab-vpc.id
  name        = "ssh_http_allowed"
  description = "Allow SSH and HTTP inbound traffic and full outbound"

  egress { //Saida liberada
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
  ingress { //Libera acesso ao Netdata na subrede
    from_port   = 19999
    to_port     = 19999
    protocol    = "tcp"
    cidr_blocks = ["10.1.1.0/24"]
  }
  ingress { //Libera icmp na subrede
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.1.1.0/24"]
  }
  tags = {
    env = var.env
  }
}