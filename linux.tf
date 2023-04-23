data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_network_interface" "lnx_interface" {
  subnet_id       = aws_subnet.lab-subnet-1.id
  private_ips     = [var.lnx_private_ip]
  security_groups = [aws_security_group.ssh_http_allowed.id]
}

# Instancia EC2 - Linux
resource "aws_instance" "web-server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  tags = {
    Name = "web-server"
    env  = var.env
  }

  network_interface {
    network_interface_id = aws_network_interface.lnx_interface.id
    device_index         = 0
  }
  #Ativar monitoramento detalhado
  #monitoring             = true
  # Chave SSH Publica
  key_name = aws_key_pair.key_pair.key_name

  # nginx e git installation
  # Arquivo que será executado na instancia
  provisioner "file" {
    source      = "linux_config.sh"
    destination = "/tmp/linux_config.sh"
  }

  # Executando o arquivo linux_config.sh
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/linux_config.sh",
      "sudo /tmp/linux_config.sh"
    ]
  }
  # Config para acesso SSH
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("${aws_key_pair.key_pair.key_name}.pem")
  }
}