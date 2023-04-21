# Criar private key em formato PEM.
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Gera a chave publica para configuracao
resource "aws_key_pair" "key_pair" {
  key_name   = "lab-key-pair"
  public_key = tls_private_key.key_pair.public_key_openssh
}
# Salva a private key em um arquivo local para conexao ssh.
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}