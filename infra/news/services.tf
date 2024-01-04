# #############################################
# # Quotes service in apprunner
# #############################################

# # Create a role for App Runner to access ECR

# #############################################
# # Apprunner IAM Role
# #############################################

# variable "apprunner-service-role" {
#     description = "This role gives App Runner permission to access ECR"
#     default     = "quotes"
#     type = string
# }

# resource "aws_iam_role" "apprunner-service-role" {
#     name = "${var.apprunner-service-role}AppRunnerECRAccessRole"
#     path = "/"
#     assume_role_policy = data.aws_iam_policy_document.apprunner-service-assume-policy.json
# }

# data "aws_iam_policy_document" "apprunner-service-assume-policy" {
#   statement {
#     effect = "Allow"
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = [
#         "build.apprunner.amazonaws.com",
#         "tasks.apprunner.amazonaws.com"
#         ]
#     }
#   }
# }

# resource "aws_iam_role_policy_attachment" "apprunner-service-role-attachment" {
#   role       = aws_iam_role.apprunner-service-role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
# }

# # resource "aws_iam_role" "apprunner-instance-role" {
# #   name = "${var.apprunner-service-role}AppRunnerInstanceRole"
# #   path = "/"
# #   assume_role_policy = data.aws_iam_policy_document.apprunner-instance-assume-policy.json
# # }

# # resource "aws_iam_policy" "Apprunner-policy" {
# #   name = "Apprunner-getSSM"
# #   policy = data.aws_iam_policy_document.apprunner-instance-role-policy.json
# # }

# # resource "aws_iam_role_policy_attachment" "apprunner-instance-role-attachment" {
# #   role = aws_iam_role.apprunner-instance-role.name
# #   policy_arn = aws_iam_policy.Apprunner-policy.arn
# # }

# # data "aws_iam_policy_document" "apprunner-instance-assume-policy" {
# #   statement {
# #     actions = ["sts:AssumeRole"]

# #     principals {
# #       type = "Service"
# #       identifiers = ["tasks.apprunner.amazonaws.com"]
# #     }
# #   }
# # }

# # data "aws_iam_policy_document" "apprunner-instance-role-policy" {
# #   statement {
# #     actions = ["ssm:GetParameter"]
# #     effect = "Allow"
# #     resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter${data.aws_ssm_parameter.dbpassword.name}"]
# #   }
# # }

# data "aws_caller_identity" "current" {}


# # data "aws_iam_policy_document" "access_asume_role" {
# #   statement {
# #     actions = [
# #       "sts:AssumeRole"
# #     ]
# #     principals {
# #       type = "Service"
# #       identifiers = [
# #         "build.apprunner.amazonaws.com",
# #         "tasks.apprunner.amazonaws.com"
# #       ]
# #     }
# #   }
# # }

# # data "aws_iam_policy" "AWSAppRunnerServicePolicyForECRAccess" {
# #   arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
# # }

# # resource "aws_iam_role" "access" {
# #   name               = "quotes-acces"
# #   assume_role_policy = data.aws_iam_policy_document.access_asume_role.json
# # }

# # resource "aws_iam_role_policy_attachment" "access" {
# #   policy_arn = data.aws_iam_policy.AWSAppRunnerServicePolicyForECRAccess.arn
# #   role       = aws_iam_role.access.name
# # }

# resource "aws_apprunner_service" "quotes" {
#   service_name = "quotes"

#   source_configuration {
#     authentication_configuration {
#       access_role_arn = aws_iam_role.apprunner-service-role.arn
#     }
#     image_repository {
#       image_repository_type = "ECR"
#       image_identifier      = "${local.ecr_url}quotes:latest"
#       image_configuration {
#         port = 8082
#       }
#     }
#   }
#   instance_configuration {
#     cpu    = "1 vCPU"
#     memory = "2 GB"
#   }

#   network_configuration {
#     # ingress_configuration {
#     #   is_publicly_accessible = false
#     # }
#     # egress_configuration {
#     #   egress_type = "VPC"
#     # }
#   }

#   tags = {
#     Name      = "quotes"
#     createdBy = "infra-${var.prefix}/news"
#   }
# }