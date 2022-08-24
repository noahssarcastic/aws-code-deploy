# App role.
resource "aws_iam_instance_profile" "app" {
  name = "app"
  role = aws_iam_role.app.name
}

resource "aws_iam_role" "app" {
  name = "app"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    data.aws_iam_policy.ssm.arn,
    aws_iam_policy.code_bucket.arn
  ]
}

# Code Deploy
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

# Systems Manager
data "aws_iam_policy" "ssm" {
  name = "AmazonSSMManagedInstanceCore"
}

# Github Actions
data "aws_iam_policy" "deployer" {
  name = "AWSCodeDeployDeployerAccess"
}

resource "aws_iam_policy" "code_bucket" {
  name        = "CodeBucketWriter"
  description = ""

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
        ]
        Resource = "${data.aws_s3_bucket.code.arn}/*"
      }
    ]
  })
}

resource "aws_iam_user" "deployer" {
  name = "github-deployer"
}

resource "aws_iam_user_policy_attachment" "deployer" {
  user       = aws_iam_user.deployer.name
  policy_arn = data.aws_iam_policy.deployer.arn
}

resource "aws_iam_user_policy_attachment" "code_bucket" {
  user       = aws_iam_user.deployer.name
  policy_arn = aws_iam_policy.code_bucket.arn
}

resource "aws_iam_access_key" "deployer" {
  user = aws_iam_user.deployer.name
}

output "deploy_id" {
  value = aws_iam_access_key.deployer.id
}

output "deploy_secret" {
  value     = aws_iam_access_key.deployer.secret
  sensitive = true
}
