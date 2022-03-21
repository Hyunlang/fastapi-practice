resource "aws_codebuild_project" "tf-build-image" {
  name          = "tf-build-image"
  description   = "Build and push monitoring image"
  service_role  = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
 }
 source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec.yml")
 }
}


resource "aws_codestarconnections_connection" "github" {
  name          = "github-connection"
  provider_type = "GitHub"
}


resource "aws_codepipeline" "cicd_pipeline" {

    name = "tf-cicd"
    role_arn = aws_iam_role.tf-codepipeline-role.arn

    artifact_store {
        type="S3"
        location = aws_s3_bucket.codepipeline_artifacts.id
    }

    stage {
        name = "Source"
        action{
            name = "Source"
            category = "Source"
            owner = "AWS"
            provider = "CodeStarSourceConnection"
            version = "1"
            output_artifacts = ["source_output"]
            configuration = {
                FullRepositoryId = "Hyunlang/fastapi-practice"
                BranchName   = "main"
                ConnectionArn = aws_codestarconnections_connection.github.arn
            }
        }
    }

    stage {
        name ="Build and push image"
        action{
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["source_output"]
            output_artifacts = ["build_output"]
            configuration = {
                ProjectName = aws_codebuild_project.tf-build-image.name
            }
        }
    }

    stage {
        name ="Deploy"
        action{
            name = "Deploy"
            category = "Deploy"
            provider = "ECS"
            version = "1"
            owner = "AWS"
            input_artifacts = ["build_output"]
            configuration = {
              ClusterName = aws_ecs_cluster.test-cluster.name
              ServiceName = aws_ecs_service.monitoring-api.name
              FileName = "imagedefinitions.json"
            }
        }
    }

}
