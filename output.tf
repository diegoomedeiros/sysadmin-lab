output "lnx_public_ip" {
  value = aws_instance.web-server.public_ip
}

output "lnx_root_device_name" {
  value = aws_instance.web-server.root_block_device[0].device_name
}

output "lnx_root_volume_id" {
  value = aws_instance.web-server.root_block_device[0].volume_id
}

output "win_public_ip" {
  value = aws_instance.dns-server.public_ip
}

output "win_root_device_name" {
  value = aws_instance.dns-server.root_block_device[0].device_name
}

output "win_root_volume_id" {
  value = aws_instance.dns-server.root_block_device[0].volume_id
}
