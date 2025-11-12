variable "name" {
  type    = string
  default = "jitsi"
}

variable "environment" {
  type        = string
  default = "test"
  description = "Environment of the namespace"
}


variable "namespace" {
  type        = string
  default     = "portal"
  description = "Name of the namespace to create label names and tags"
}

variable "region" {
  type        = string
  description = "Which region to host mainly"
  default = "us-east-1"
}

variable "jitsi_version" {
  type        = string
  description = "Jitsi version"
  default = "stable-10532-1"
}

variable "vpc_id" {
  type        = string
  description = "Which VPC to launch the environment in"
  default = "vpc-070cd92c0ffb0aac6"
}

variable "lb_arn" {
  type        = string
  description = "ARN of the load balancer"
  default = "arn:aws:elasticloadbalancing:us-east-1:233718569638:loadbalancer/app/stella-prod/2a3d5b565fbe34ea"
}

variable "https_listener_arn" {
  type = string
  default = "arn:aws:elasticloadbalancing:us-east-1:233718569638:listener/app/stella-prod/2a3d5b565fbe34ea/6b23b144f05117d0"
}

variable "cluster_name" {
  type = string
  default     = "stella-dev"
}

variable "url" {
  type = string
  default = "meet-staging.stellabrainhealth.com"
}

variable "letsencrypt_email" {
  type = string
  default = "brice.aminou@stellacenter.com"
}

variable "private_subnets" {
  type = list(string)
  default     = ["subnet-0c11ebff31507d123","subnet-0f8145d20ca0d4a28","subnet-0424f6cd294b7f6f2"]
}

variable "public_subnets" {
  type = list(string)
  default     = ["subnet-0abf7c7bbca7b39d5","subnet-041ce230df8de0c73","subnet-0a9c485f562bc586b"]
}

variable "event_sync_api_url" {
  type = string
  default = "https://webhook.site/57d446ce-9102-4df7-a67c-2ed1ce218f55"
}

variable "jwt_app_id" {
  type = string
  default = "FTJitsi"
}

variable "jwt_app_secret" {
  type = string
  default = "Kshdkfj987hsKJHGg7wer"
}

variable "ec2_security_group_id" {
  type = string
  default = "sg-05ae0e3e0c4bca2fb"
  
}