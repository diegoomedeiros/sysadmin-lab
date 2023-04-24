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
    Name   = "web-server"
    env    = var.env
    Backup = true
  }

  network_interface {
    network_interface_id = aws_network_interface.lnx_interface.id
    device_index         = 0
  }
  ## Unidade Extra
  ebs_block_device {
    device_name           = "/dev/xvdc"
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }
  #monitoring             = true
  # Chave publica para SSH 
  key_name = aws_key_pair.key_pair.key_name

  # Instalação do nginx
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
  # Setup de conexao ssh para execucao do script linux_config.sh
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("${aws_key_pair.key_pair.key_name}.pem")
  }
}