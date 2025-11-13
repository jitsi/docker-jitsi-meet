variable "name" {
  type    = string
}

variable "environment" {
  type        = string
  description = "Environment of the namespace"
}


variable "namespace" {
  type        = string
  description = "Name of the namespace to create label names and tags"
}

variable "region" {
  type        = string
  description = "Which region to host mainly"
}

variable "jitsi_version" {
  type        = string
  description = "Jitsi version"
}

variable "vpc_id" {
  type        = string
  description = "Which VPC to launch the environment in"
}

variable "lb_arn" {
  type        = string
  description = "ARN of the load balancer"
}

variable "https_listener_arn" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "url" {
  type = string
}

variable "letsencrypt_email" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "event_sync_api_url" {
  type = string
}

variable "jwt_app_id" {
  type = string
}

variable "jwt_app_secret" {
  type = string
}

variable "ec2_security_group_id" {
  type = string
}

variable "jvb_nlb_public_ips" {
  type = string
}