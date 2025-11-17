[
  {
    "name": "prosody",
    "image": "jitsi/prosody:${version}",
    "memory": 1024,
    "essential": true,
    "portMappings": [
      { "protocol": "tcp", "containerPort": 5222, "hostPort": 5222 },
      { "protocol": "tcp", "containerPort": 5269, "hostPort": 5269 },
      { "protocol": "tcp", "containerPort": 5347, "hostPort": 5347 },
      { "protocol": "tcp", "containerPort": 5280, "hostPort": 5280 }
    ],
    "mountPoints": [
      { "sourceVolume": "config-prosody", "containerPath": "/config", "readOnly": false },
      { "sourceVolume": "prosody-plugins",  "containerPath": "/prosody-plugins",  "readOnly": true  }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${awslogs_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs",
        "awslogs-create-group": "true"
      }
    },
    "environment": [
      { "name": "CONFIG", "value": "/config" },
      { "name": "LOG_LEVEL", "value": "info" },
      { "name": "XMPP_DOMAIN", "value": "meet.jitsi" },
      { "name": "XMPP_AUTH_DOMAIN", "value": "auth.meet.jitsi" },
      { "name": "XMPP_MUC_DOMAIN", "value": "muc.meet.jitsi" },

      { "name": "XMPP_INTERNAL_MUC_DOMAIN", "value": "internal-muc.meet.jitsi" },
      { "name": "XMPP_GUEST_DOMAIN", "value": "guest.meet.jitsi" },
      { "name": "JWT_APP_ID", "value": "${jwt_app_id}" },
      { "name": "JWT_APP_SECRET", "value": "${jwt_app_secret}" },
      { "name": "JWT_ACCEPTED_ISSUERS", "value": "fth_iss" },
      { "name": "JWT_ACCEPTED_AUDIENCES", "value": "fth_aud" },
      
      { "name": "ENABLE_AUTH", "value": "1" },
      { "name": "AUTH_TYPE", "value": "jwt" },
      { "name": "ENABLE_GUESTS", "value": "1" },
      { "name": "ENABLE_LOBBY", "value": "1" },
      { "name": "LOBBY_MUC", "value": "lobby.meet.jitsi" },
      { "name": "ENABLE_AUTO_OWNER", "value": "0" },
      { "name": "XMPP_MUC_MODULES", "value": "lobby_autostart_on_owner,event_sync_component" },
      { "name": "XMPP_MUC_CONFIGURATION", "value": "muc_component='muc.meet.jitsi', api_prefix='${event_sync_api_url}'" },
      { "name": "ENABLE_AUTO_OWNER","value": "0" },
      { "name": "ENABLE_LETSENCRYPT","value": "0" },
      { "name": "LETSENCRYPT_DOMAIN","value": "${public_url}" },
      { "name": "LETSENCRYPT_EMAIL","value": "${letsencrypt_email}" }

    ],
    "secrets": [
      { "name": "JVB_AUTH_PASSWORD", "valueFrom": "${jvb_auth_password_arn}" },
      { "name": "JICOFO_AUTH_PASSWORD", "valueFrom": "${jicofo_auth_password_arn}" },
      { "name": "JICOFO_COMPONENT_SECRET", "valueFrom": "${jicofo_component_secret_arn}" }
    ]
  },
  {
    "name": "jicofo",
    "image": "jitsi/jicofo:${version}",
    "memory": 1024,
    "essential": true,
    "portMappings": [ { "containerPort": 8888 } ],
    "dependsOn": [ { "containerName": "prosody", "condition": "START" } ],
    "mountPoints": [
      { "sourceVolume": "config-jicofo", "containerPath": "/config", "readOnly": false }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${awslogs_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs",
        "awslogs-create-group": "true"
      }
    },
    "environment": [
      { "name": "XMPP_SERVER", "value": "127.0.0.1" },
      { "name": "XMPP_DOMAIN", "value": "meet.jitsi" },
      { "name": "CONFIG", "value": "/config" },
      { "name": "ENABLE_AUTH", "value": "1" },
      { "name": "AUTH_TYPE", "value": "jwt" }
    ],
    "secrets": [
      { "name": "JVB_AUTH_PASSWORD", "valueFrom": "${jvb_auth_password_arn}" },
      { "name": "JICOFO_AUTH_PASSWORD", "valueFrom": "${jicofo_auth_password_arn}" },
      { "name": "JICOFO_COMPONENT_SECRET", "valueFrom": "${jicofo_component_secret_arn}" }
    ]
  },
  {
    "name": "jvb",
    "image": "jitsi/jvb:${version}",
    "memory": 4096,
    "essential": true,
    "dependsOn": [ { "containerName": "prosody", "condition": "START" } ],
    "portMappings": [
      { "protocol": "udp", "containerPort": 10000, "hostPort": 10000 },
      { "protocol": "tcp", "containerPort": 4443, "hostPort": 4443 },
      { "protocol": "tcp", "containerPort": 8080, "hostPort": 8080 }
    ],
    "mountPoints": [
      { "sourceVolume": "config-jvb", "containerPath": "/config", "readOnly": false }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${awslogs_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs",
        "awslogs-create-group": "true"
      }
    },
    "environment": [
      { "name": "XMPP_SERVER", "value": "127.0.0.1" },
      { "name": "XMPP_DOMAIN", "value": "meet.jitsi" },
      { "name": "JVB_ENABLE_APIS", "value": "rest,xmpp" },
      { "name": "CONFIG", "value": "/config" },
      { "name": "JVB_PORT", "value": "10000" },
      { "name": "JVB_TCP_HARVESTER_DISABLED", "value": "true" },
      { "name": "JVB_NLB_DNS", "value": "${jvb_nlb_dns}" },
      { "name": "JAVA_SYS_PROP_org.jitsi.videobridge.DISABLE_STUN", "value": "true" },
      { "name": "JVB_ADVERTISE_IPS", "value": "52.45.152.241,98.88.168.215,34.226.172.199" },
      { "name": "JAVA_SYS_PROP_org.jitsi.videobridge.rest.jetty.enabled", "value": "true" },
      { "name": "JAVA_SYS_PROP_org.jitsi.videobridge.rest.jetty.port",    "value": "8080" },
      { "name": "JAVA_SYS_PROP_org.ice4j.ice.harvest.DISABLE_STUN", "value": "true" },
      { "name": "JVB_WS_SERVER_ID",         "value": "jvb" },
      { "name": "ENABLE_AUTH", "value": "1" },
      { "name": "AUTH_TYPE", "value": "jwt" }
    ],
    "secrets": [
      { "name": "JVB_AUTH_PASSWORD", "valueFrom": "${jvb_auth_password_arn}" },
      { "name": "JICOFO_AUTH_PASSWORD", "valueFrom": "${jicofo_auth_password_arn}" },
      { "name": "JICOFO_COMPONENT_SECRET", "valueFrom": "${jicofo_component_secret_arn}" }
    ]
  },
  {
    "name": "web",
    "image": "${ecr_web_image_uri}",
    "essential": true,
    "memory": 128,
    "dependsOn": [ { "containerName": "prosody", "condition": "START" } ],
    "portMappings": [
      { "protocol": "tcp", "containerPort": 80, "hostPort": 80 },
      { "protocol": "tcp", "containerPort": 443, "hostPort": 443 }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${awslogs_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs",
        "awslogs-create-group": "true"
      }
    },
    "environment": [
      { "name": "CONFIG", "value": "/config" },
      { "name": "XMPP_SERVER", "value": "127.0.0.1" },
      { "name": "NGINX_RESOLVER", "value": "127.0.0.1" },
      { "name": "XMPP_BOSH_URL_BASE", "value": "http://127.0.0.1:5280" },
      { "name": "XMPP_WEBSOCKET_URL", "value": "ws://127.0.0.1:5280/xmpp-websocket" },
      { "name": "JVB_WS_SERVER_ID", "value": "jvb" },
      { "name": "PUBLIC_URL", "value": "${public_url}" },
      { "name": "TZ", "value": "UTC" },

      { "name": "ENABLE_LOBBY", "value": "1" },
      { "name": "ENABLE_PREJOIN_PAGE", "value": "0" },
      { "name": "ENABLE_CLOSE_PAGE", "value": "1" },
      { "name": "ENABLE_WELCOME_PAGE", "value": "0" },
      { "name": "ENABLE_AUTH", "value": "1" },
      { "name": "ENABLE_GUESTS", "value": "1" },
      { "name": "XMPP_DOMAIN",       "value": "meet.jitsi" },
      { "name": "XMPP_GUEST_DOMAIN", "value": "guest.meet.jitsi" },

      { "name": "AUTH_TYPE", "value": "jwt" },
      { "name": "JWT_APP_ID", "value": "${jwt_app_id}" },
      { "name": "JWT_APP_SECRET", "value": "${jwt_app_secret}" },
      { "name": "JWT_ACCEPTED_ISSUERS", "value": "fth_iss" },
      { "name": "JWT_ACCEPTED_AUDIENCES", "value": "fth_aud" },

      { "name": "ENABLE_LETSENCRYPT","value": "0" },
      { "name": "LETSENCRYPT_DOMAIN","value": "${public_url}" },
      { "name": "LETSENCRYPT_EMAIL","value": "${letsencrypt_email}" },

      { "name": "ENABLE_XMPP_WEBSOCKET","value": "1" },
      { "name": "disableDeepLinking", "value": "true" }
    ]
  }
]
