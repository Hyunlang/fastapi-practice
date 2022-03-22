//resource "aws_s3_bucket" "codepipeline_artifacts" {
//  bucket = "pipeline-artifacts-monitoring-api"
//}
//
//resource "aws_s3_bucket_acl" "codepipeline_artifacts" {
//  bucket = aws_s3_bucket.codepipeline_artifacts.id
//  acl    = "private"
//}