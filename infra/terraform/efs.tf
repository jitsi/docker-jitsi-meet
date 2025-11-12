resource "aws_efs_file_system" "jitsi" {
  encrypted = true
  lifecycle_policy { transition_to_ia = "AFTER_30_DAYS" }
  tags = { Name =module.label.id }
}

resource "aws_efs_mount_target" "jitsi" {
  for_each        = toset(var.private_subnets) # or your private subnets
  file_system_id  = aws_efs_file_system.jitsi.id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_access_point" "prosody" {
  file_system_id = aws_efs_file_system.jitsi.id

  posix_user {
    uid = 0
    gid = 0
  }

  root_directory {
    path = "/prosody"

    creation_info {
      owner_uid   = 0
      owner_gid   = 0
      permissions = "0755"
    }
  }
}

resource "aws_efs_access_point" "jicofo" {
  file_system_id = aws_efs_file_system.jitsi.id

  posix_user {
    uid = 0
    gid = 0
  }

  root_directory {
    path = "/jicofo"

    creation_info {
      owner_uid   = 0
      owner_gid   = 0
      permissions = "0755"
    }
  }
}

resource "aws_efs_access_point" "jvb" {
  file_system_id = aws_efs_file_system.jitsi.id

  posix_user {
    uid = 0
    gid = 0
  }

  root_directory {
    path = "/jvb"

    creation_info {
      owner_uid   = 0
      owner_gid   = 0
      permissions = "0755"
    }
  }
}

resource "aws_efs_access_point" "prosody_plugins" {
  file_system_id = aws_efs_file_system.jitsi.id
  posix_user { 
    uid = 0
    gid = 0 
  }
  root_directory {
    path = "/prosody-plugins"
    creation_info { 
      owner_uid = 0 
      owner_gid = 0 
      permissions = "0755" 
    }
  }
}