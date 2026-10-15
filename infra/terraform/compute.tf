data "aws_ssm_parameter" "ubuntu_2204" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

resource "aws_instance" "web" {
  ami                         = data.aws_ssm_parameter.ubuntu_2204.value
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.web.name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.project_name}-web"
    Tier = "Public"
  }

  depends_on = [
    aws_iam_role_policy_attachment.web_ssm
  ]
}

resource "aws_instance" "database" {
  ami                    = data.aws_ssm_parameter.ubuntu_2204.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.database.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.database.name

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.project_name}-database"
    Tier = "Private"
  }

  depends_on = [
    aws_iam_role_policy_attachment.database_ssm
  ]
}

output "web_public_ip" {
  description = "Public IPv4 address of the web server"
  value       = aws_instance.web.public_ip
}

output "database_private_ip" {
  description = "Private IPv4 address of the database server"
  value       = aws_instance.database.private_ip
}
