resource "aws_ecs_cluster" "_" {
  name = local.ecs_name_cluster
}

resource "aws_ecs_task_definition" "_" {
  family                   = local.ecs_name_task_definition
  container_definitions    = data.template_file.task_definition.rendered
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  network_mode             = "awsvpc"

  task_role_arn      = local.ecs_role_arn
  execution_role_arn = local.ecs_role_arn
}

resource "aws_ecs_service" "_" {
  name            = local.ecs_name_service
  cluster         = aws_ecs_cluster._.id
  task_definition = aws_ecs_task_definition._.arn
  launch_type     = "FARGATE"

  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  network_configuration {
    security_groups  = [aws_security_group.alb_ecs[0].id]
    subnets          = var.subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group._[0].arn
    container_name   = local.ecs_name_task_definition
    container_port   = var.container_port
  }

  depends_on = [
    aws_alb_listener._,
  ]

  count = local.alb_count
}

resource "aws_ecs_service" "no_alb" {
  name            = local.ecs_name_service
  cluster         = aws_ecs_cluster._.id
  task_definition = aws_ecs_task_definition._.arn
  launch_type     = "FARGATE"

  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  network_configuration {
    security_groups  = var.security_groups
    subnets          = var.subnets
    assign_public_ip = true
  }

  count = local.alb_count == 1 ? 0 : 1
}