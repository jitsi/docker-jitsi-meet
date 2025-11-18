module "ecr_web" {
  source = "cloudposse/ecr/aws"
  version                = "1.0.0"
  namespace              = module.label.namespace
  stage                  = module.label.environment
  name                   = "${module.label.name}-web"
  image_tag_mutability   = "MUTABLE"
}