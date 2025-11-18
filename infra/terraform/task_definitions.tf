resource "random_password" "jvb_auth" {
  length  = 32
  special = false
}

resource "random_password" "jicofo_auth" {
  length  = 32
  special = false
}

resource "random_password" "jicofo_component" {
  length  = 32
  special = false
}

resource "aws_ssm_parameter" "jvb_auth_password" {
  name  = "/jitsi/${var.environment}/jvb_auth_password"
  type  = "SecureString"
  value = random_password.jvb_auth.result
}

resource "aws_ssm_parameter" "jicofo_auth_password" {
  name  = "/jitsi/${var.environment}/jicofo_auth_password"
  type  = "SecureString"
  value = random_password.jicofo_auth.result
}

resource "aws_ssm_parameter" "jicofo_component_secret" {
  name  = "/jitsi/${var.environment}/jicofo_component_secret"
  type  = "SecureString"
  value = random_password.jicofo_component.result
}

resource "aws_ecs_task_definition" "jitsi" {
  family                        = module.label.id
  container_definitions         = templatefile("${path.module}/task_definitions/jitsi.json.tpl", {
    awslogs_group               = module.label.id
    region                      = var.region
    version                     = var.jitsi_version
    public_url                  = var.url
    prosody_plugins             = "lobby_autostart_on_owner"
    jvb_auth_password_arn       = aws_ssm_parameter.jvb_auth_password.arn
    jicofo_auth_password_arn    = aws_ssm_parameter.jicofo_auth_password.arn
    jicofo_component_secret_arn = aws_ssm_parameter.jicofo_component_secret.arn
    event_sync_api_url          = var.event_sync_api_url
    jwt_app_id                  = var.jwt_app_id
    jwt_app_secret              = var.jwt_app_secret
    letsencrypt_email           = var.letsencrypt_email
    jvb_nlb_dns                 = aws_lb.jvb_nlb.dns_name
    ecr_web_image_uri           = module.ecr_web.repository_url

  })

  volume {
    name = "config-prosody"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.jitsi.id
      root_directory          = "/"                 # will be created if missing
      transit_encryption      = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.prosody.id
        iam                   = "ENABLED"
      }
    }
  }

  volume {
    name = "prosody-plugins"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.jitsi.id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.prosody_plugins.id
        iam             = "ENABLED"
      }
    }
  }

  volume {
    name = "config-jicofo"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.jitsi.id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.jicofo.id
        iam                   = "ENABLED"
      }
    }
  }

  volume {
    name = "config-jvb"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.jitsi.id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.jvb.id
        iam                   = "ENABLED"
      }
    }
  }

  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
}
