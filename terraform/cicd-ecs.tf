//resource "aws_cloudwatch_log_group" "tf-logging" {
//  name = "tf-logging"
//}
//
//resource "aws_kms_key" "example" {
//  description             = "tf_kms_key"
//  deletion_window_in_days = 7
//}
//
//resource "aws_ecs_cluster" "test-cluster" {
//  name = "tf-test-cluster"
//
//  configuration {
//    execute_command_configuration {
//      kms_key_id = aws_kms_key.example.arn
//      logging = "OVERRIDE"
//
//      log_configuration {
//        cloud_watch_encryption_enabled = true
//        cloud_watch_log_group_name = aws_cloudwatch_log_group.tf-logging.name
//      }
//    }
//  }
//}
//
//resource "aws_ecs_task_definition" "monitoring-api" {
//  family = "service"
//  container_definitions = jsonencode([
//    {
//      name      = "first"
//      image     = "service-first"
//      cpu       = 10
//      memory    = 512
//      essential = true
//      portMappings = [
//        {
//          containerPort = 80
//          hostPort      = 80
//        }
//      ]
//    }
//  ])
//
//  volume {
//    name      = "monitor-service-storage"
//    host_path = "/ecs/monitor-service-storage"
//  }
//}
//
//resource "aws_ecs_service" "monitoring-api" {
//  name            = "monitoring-api"
//  cluster         = aws_ecs_cluster.test-cluster.id
//  task_definition = aws_ecs_task_definition.monitoring-api.arn
//  desired_count   = 1
////  iam_role        = aws_iam_role.ecs_task_execution_role.arn
////  depends_on      = [aws_iam_role_policy.foo]
//
//  ordered_placement_strategy {
//    type  = "binpack"
//    field = "cpu"
//  }
//
////  load_balancer {
////    target_group_arn = aws_lb_target_group.foo.arn
////    container_name   = "mongo"
////    container_port   = 8080
////  }
//
//  placement_constraints {
//    type       = "memberOf"
//    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
//  }
//}