data "aws_ami" "windows-2022" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]
  }
}
# PowerShell Script
data "template_file" "windows-userdata" {
  template = <<EOF
<powershell>
# Install DNS
Install-WindowsFeature -Name DNS -IncludeManagementTools ;
# Config Zona LAB.COM
Add-DNSServerPrimaryZone -name lab.com -Zonefile lab.com.DNS -DynamicUpdate NonsecureAndSecure
# Add entrata DNS tipo A para o servidor web-server
Add-DNSServerResourceRecordA -name web-server -Zonename lab.com -AllowUpdateAny -IPv4Address "${aws_instance.web-server.private_ip}"
# Incluindo o proprio servidor como DNS primário.
$index = Get-NetIPAddress | Where-Object -FilterScript { $_.IPv4Address -eq "${var.win_private_ip}"} | Select-Object -Property InterfaceIndex
Set-DnsClientServerAddress -InterfaceIndex $index.InterfaceIndex -ServerAddresses ("${var.win_private_ip}")
</powershell>
EOF
}
#Interface de Rede com ip fixo e sg.
resource "aws_network_interface" "win_interface" {
  subnet_id       = aws_subnet.lab-subnet-1.id
  private_ips     = [var.win_private_ip]
  security_groups = [aws_security_group.rdp_allowed.id]
}

# Instancia EC2 - Windows
resource "aws_instance" "dns-server" {
  ami           = data.aws_ami.windows-2022.id
  instance_type = var.instance_type
  tags = {
    Name = "dns-server"
    env  = var.env
  }
  network_interface {
    network_interface_id = aws_network_interface.win_interface.id
    device_index         = 0
  }
  # root disk
  root_block_device {
    volume_size           = 30
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
  }
  #monitoring             = true
  # the Public SSH key
  key_name = aws_key_pair.key_pair.key_name
  #Exec powershell
  user_data = data.template_file.windows-userdata.rendered

}


