data "aws_iam_policy" "code_deploy" {
  name = "AWSCodeDeployRole"
}

resource "aws_iam_policy" "code_deploy_lt" {
  name        = "AWSCodeDeployRoleForLaunchTemplates"
  description = "Used for service role for Code Deploy when using ASG Launch Templates."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:RunInstances",
          "ec2:CreateTags",
          "iam:PassRole"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "code_deploy" {
  name = "CodeDeployServiceRole"

  managed_policy_arns = [
    data.aws_iam_policy.code_deploy.arn,
    aws_iam_policy.code_deploy_lt.arn
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "",
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

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
