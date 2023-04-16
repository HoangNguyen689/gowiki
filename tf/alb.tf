resource "aws_alb" "_" {
  name = local.project_name

  security_groups = var.security_groups
  subnets         = var.subnets

  count = local.alb_count
}

resource "aws_alb_target_group" "_" {
  name = local.project_name

  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = var.health_check_path
  }

  count = local.alb_count
}

resource "aws_alb_listener" "_" {
  load_balancer_arn = aws_alb._[0].id
  port              = var.alb_listen_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group._[0].id
    type             = "forward"
  }

  count = local.alb_count
}