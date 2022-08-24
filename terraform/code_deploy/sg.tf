resource "aws_security_group" "app" {
  name   = "app"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group_rule" "ssh_in" {
  security_group_id = aws_security_group.app.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nodejs" {
  security_group_id = aws_security_group.app.id
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_out" {
  security_group_id = aws_security_group.app.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
