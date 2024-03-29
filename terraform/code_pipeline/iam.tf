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
}

resource "aws_iam_policy" "code_bucket" {
  name        = "CodeBucketReader"
  description = ""

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = [
          "s3:GetObject",
        ]
        Resource = "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "code_bucket" {
  policy_arn = aws_iam_policy.code_bucket.arn
  role       = aws_iam_role.app.name
}

resource "aws_iam_policy" "set_revision" {
  name        = "ReadCommitId"
  description = ""

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = [
          "codedeploy:*",
          "codepipeline:*",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "set_revision" {
  policy_arn = aws_iam_policy.set_revision.arn
  role       = aws_iam_role.app.name
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

# CodePipeline

resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${aws_codestarconnections_connection.github.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:GetDeploymentConfig"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeployment"
      ],
      "Resource": "${aws_codedeploy_deployment_group.app.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:RegisterApplicationRevision",
        "codedeploy:GetApplicationRevision"
      ],
      "Resource": "${aws_codedeploy_app.app.arn}"
    }
  ]
}
EOF
}
