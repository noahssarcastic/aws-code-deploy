resource "aws_codedeploy_app" "app" {
  compute_platform = "Server"
  name             = "app"
}

resource "aws_codedeploy_deployment_group" "app" {
  app_name              = aws_codedeploy_app.app.name
  deployment_group_name = "app"
  service_role_arn      = aws_iam_role.code_deploy.arn

  autoscaling_groups = [aws_autoscaling_group.app.name]

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
