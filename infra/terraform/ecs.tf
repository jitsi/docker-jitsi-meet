resource "aws_ecs_service" "jitsi" {
  name            = "jitsi"
  task_definition = aws_ecs_task_definition.jitsi.arn
  cluster         = var.cluster_name

  load_balancer {
    target_group_arn = aws_lb_target_group.jitsi.arn
    container_name   = "web"
    container_port   = 80
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.jvb_udp_tg_ip.arn
    container_name   = "jvb"
    container_port   = 10000
  }

  network_configuration {
    subnets         = var.private_subnets                 # e.g., public subnets used by your ALB/NLB
    security_groups = [aws_security_group.jitsi.id]
    assign_public_ip = false
    # assign_public_ip is only for Fargate; omit or leave disabled on EC2.
  }

  launch_type                        = "EC2"
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  force_new_deployment               = true
} 