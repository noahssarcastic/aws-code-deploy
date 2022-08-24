resource "aws_codepipeline" "codepipeline" {
  name     = "tf-test-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }
}

resource "aws_codestarconnections_connection" "github" {
  name          = "test-github-connection"
  provider_type = "GitHub"
}
