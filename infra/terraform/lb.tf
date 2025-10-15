data "aws_lb" "this" {
  arn = var.lb_arn
}

resource "aws_lb_target_group" "jitsi" {
  name = module.label.id

  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    path                = "/"
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    timeout             = "5"
    interval            = "30"
    matcher             = "200"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "jitsi" {
  listener_arn = var.https_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jitsi.arn
  }

  condition {
    host_header {
      values = [var.url]
    }
  }

  depends_on = [
    aws_lb_target_group.jitsi
  ]
}

resource "aws_lb_target_group" "jvb_udp_tg_ip" {
  name        = "${module.label.id}-jvb-udp10000-ip"
  port        = 10000
  protocol    = "UDP"
  vpc_id      = var.vpc_id
  target_type = "ip"   # REQUIRED with awsvpc

  # Health checks on UDP TGs must be TCP/HTTP. JVB exposes 8080 (REST)
  health_check {
      protocol            = "HTTP"
      port                = "8080"
      path                = "/about/health"
      matcher             = "200-204"
      interval            = 30
      timeout             = 5
      healthy_threshold   = 2
      unhealthy_threshold = 5
    }
}

resource "aws_lb" "jvb_nlb" {
  name                             = "${module.label.id}-jvb-nlb"
  load_balancer_type               = "network"
  internal                         = false
  subnets                          = var.public_subnets
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "jvb_udp_10000" {
  load_balancer_arn = aws_lb.jvb_nlb.arn
  port              = 10000
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jvb_udp_tg_ip.arn
  }
}