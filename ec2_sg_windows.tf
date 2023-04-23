# Security group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "rdp_allowed" {
  vpc_id      = aws_vpc.lab-vpc.id
  name        = "RDP_allowed"
  description = "Allow RDP inbound traffic and full outbound"

  egress { //Saida liberada
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { //Entrada liberada na porta 3389 para toda a internet
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { //Libera DNS subrede
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["10.1.1.0/24"]
  }
  ingress { //Libera DNS subrede
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
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