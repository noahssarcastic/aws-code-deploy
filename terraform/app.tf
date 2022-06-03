resource "aws_security_group" "app" {
  name   = "app"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  security_group_id = aws_security_group.app.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http" {
  security_group_id = aws_security_group.app.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.app.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.app.id]
  # user_data                   = file("user_data.sh")
  key_name = var.ssh_key

  tags = {
    Name = "test-app-v${var.app_version}"
  }

  depends_on = [aws_internet_gateway.main]
}
