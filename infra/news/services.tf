# #############################################
# # front-end service in apprunner
# #############################################

# # Create a role for App Runner to access ECR

# #############################################
# # Apprunner IAM Role
# #############################################

# create a role for App Runner to access ECR
variable "apprunner_service_role" {
  description = "This role gives App Runner permission to access ECR"
  default     = "front-end"
  type        = string
}

data "aws_iam_policy_document" "apprunner_service_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "build.apprunner.amazonaws.com",
        "tasks.apprunner.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "apprunner_service_role" {
  name               = "${var.apprunner_service_role}AppRunnerECRAccessRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.apprunner_service_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "apprunner_service_role_attachment" {
  role       = aws_iam_role.apprunner_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

# data "aws_caller_identity" "current" {}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "connector"
  subnets            = [local.subnet_id]
  security_groups = [
    "${aws_security_group.front_end_sg.id}",
    "${aws_security_group.ssh_access.id}"
  ]
}

resource "aws_apprunner_service" "fron-end" {
  service_name = "front-end"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_service_role.arn
    }

    auto_deployments_enabled = false

    image_repository {
      image_repository_type = "ECR"
      image_identifier      = "${local.ecr_url}front_end:latest"
      image_configuration {
        port = 8080
        runtime_environment_variables = {
          QUOTE_SERVICE_URL      = "http://${aws_instance.quotes.private_ip}:8082"
          NEWSFEED_SERVICE_URL   = "http://${aws_instance.newsfeed.private_ip}:8081"
          STATIC_URL             = "http://${aws_s3_bucket.news.website_endpoint}"
          NEWSFEED_SERVICE_TOKEN = "T1&eWbYXNWG1w1^YGKDPxAWJ@^et^&kX"
          // add more environment variables as needed
        }
      }
    }
  }
  instance_configuration {
    cpu    = "1 vCPU"
    memory = "2 GB"
  }

  network_configuration {
    ingress_configuration {
      is_publicly_accessible = true
    }
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.connector.arn
    }
    # vpc_connector {
    #   vpc_connector_arn = aws_vpc_connector.example.arn
    #   security_group_ids = [aws_security_group.example.id]
    #   subnet_ids = [aws_subnet.example.id]
    # }
  }

  tags = {
    Name      = "quotes"
    createdBy = "infra-${var.prefix}/news"
  }
}