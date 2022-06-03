data "aws_iam_policy" "ssm" {
  name = "AmazonSSMManagedInstanceCore"
}

# data "aws_ssm_document" "configure_aws_package" {
#   name = "AWS-ConfigureAWSPackage"
# }

# resource "aws_ssm_association" "code_deploy" {
#   name                = data.aws_ssm_document.configure_aws_package.name
#   schedule_expression = "cron(0 2 ? * SUN *)"
#   parameters = {
#     action = "Install"
#     name   = "AWSCodeDeployAgent"
#   }

#   targets {
#     key    = "tag:CodeDeployApplication"
#     values = ["app"]
#   }
# }
