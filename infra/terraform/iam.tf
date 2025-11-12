
resource "aws_iam_user" "app" {
  name = "${module.label.id}-app"
}


data "aws_iam_policy_document" "assume_by_ecs" {
  statement {
    sid    = "AllowAssumeByEcsTasks"
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution_role" {
  name               = "${module.label.id}_ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_by_ecs.json
}

resource "aws_iam_role" "task_role" {
  name               = "${module.label.id}_ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.assume_by_ecs.json
}


data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs-instance-role" {
  name               = "${module.label.id}-ecs-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-instance-policy.json
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "${module.label.id}-ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs-instance-role.id
}


data "aws_iam_policy_document" "execution_role" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "execution_role" {
  role   = aws_iam_role.execution_role.name
  policy = data.aws_iam_policy_document.execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.execution_role.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.execution_role.name
}


data "aws_iam_policy_document" "ecs_ssm_access" {
  statement {
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]

    resources = [
      aws_ssm_parameter.jvb_auth_password.arn,
      aws_ssm_parameter.jicofo_auth_password.arn,
      aws_ssm_parameter.jicofo_component_secret.arn
    ]
  }
}

resource "aws_iam_policy" "ecs_ssm_access" {
  name   = "${module.label.id}-ssm-access"
  policy = data.aws_iam_policy_document.ecs_ssm_access.json
}

resource "aws_iam_role_policy_attachment" "ecs_ssm_access_attach" {
  role       = aws_iam_role.execution_role.name # your ECS execution role
  policy_arn = aws_iam_policy.ecs_ssm_access.arn
}