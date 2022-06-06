locals {
  app_ami             = data.aws_ami.app.id
  app_instance_type   = "t3.micro"
  app_security_groups = [aws_security_group.app.id]
  app_user_data       = filebase64("${path.module}/user_data.sh")
  app_key_name        = var.ssh_key
}

resource "aws_instance" "app" {
  # Disable
  count = 0

  ami              = local.app_ami
  instance_type    = local.app_instance_type
  user_data_base64 = local.app_user_data
  key_name         = local.app_key_name

  # Allow public traffic
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  security_groups             = local.app_security_groups


  tags = {
    Name = "test-app"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_launch_template" "app" {
  image_id      = local.app_ami
  instance_type = local.app_instance_type
  user_data     = local.app_user_data
  key_name      = local.app_key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.app.arn
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = local.app_security_groups
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                  = "test-app"
      CodeDeployApplication = "app"
    }
  }
}
