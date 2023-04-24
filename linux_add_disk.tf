resource "aws_ebs_volume" "new_disk" {
  availability_zone = aws_instance.web-server.availability_zone
  size              = 20
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.new_disk.id
  instance_id = aws_instance.web-server.id
}

