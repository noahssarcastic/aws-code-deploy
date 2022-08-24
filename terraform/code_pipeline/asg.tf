locals {
  asg_size = 2
}

resource "aws_autoscaling_group" "app" {
  vpc_zone_identifier = [aws_subnet.public.id]
  desired_capacity    = local.asg_size
  max_size            = local.asg_size
  min_size            = local.asg_size

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}
