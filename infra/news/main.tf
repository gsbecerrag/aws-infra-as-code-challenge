### Front end

resource "aws_security_group" "front_end_sg" {
  vpc_id      = "${local.vpc_id}"
  name        = "${var.prefix}-front_end"
  description = "Security group for front_end"

  tags = {
    Name = "SG for front_end"
    createdBy = "infra-${var.prefix}/news"
  }
}

# Allow all outbound connections
resource "aws_security_group_rule" "front_end_all_out" {
  type        = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.front_end_sg.id}"
}

resource "aws_instance" "front_end" {
  ami           = "${data.aws_ami.amazon_linux_2.id}"
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.ssh_key.key_name}"
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    delete_on_termination = true
  }

  iam_instance_profile = "${var.prefix}-news_host"

  availability_zone = "${var.region}a"

  subnet_id = local.subnet_id

  vpc_security_group_ids = [
    "${aws_security_group.front_end_sg.id}",
    "${aws_security_group.ssh_access.id}"
  ]

  tags = {
    Name = "${var.prefix}-front_end"
    createdBy = "infra-${var.prefix}/news"
  }

  connection {
    host = "${self.public_ip}"
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("${path.module}/../id_rsa")}"
  }

  provisioner "remote-exec" {
    script = "${path.module}/provision-docker.sh"
  }
}

# Allow public access to the front-end server
resource "aws_security_group_rule" "front_end" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]

  security_group_id = "${aws_security_group.front_end_sg.id}"
}
### end of front-end

#############################################
# Quotes service
#############################################

resource "aws_security_group" "quotes_sg" {
  vpc_id      = "${local.vpc_id}"
  name        = "${var.prefix}-quotes_sg"
  description = "Security group for quotes"

  tags = {
    Name = "SG for quotes"
    createdBy = "infra-${var.prefix}/news"
  }
}

# Allow all outbound connections
resource "aws_security_group_rule" "quotes_all_out" {
  type        = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.quotes_sg.id}"
}

#############################################
resource "aws_instance" "quotes" {
  ami           = "${data.aws_ami.amazon_linux_2.id}"
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.ssh_key.key_name}"
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    delete_on_termination = true
  }

  iam_instance_profile = "${var.prefix}-news_host"

  availability_zone = "${var.region}a"

  subnet_id = local.subnet_id

  vpc_security_group_ids = [
    "${aws_security_group.quotes_sg.id}",
    "${aws_security_group.ssh_access.id}"
  ]

  tags = {
    Name = "${var.prefix}-quotes"
    createdBy = "infra-${var.prefix}/news"
  }

  connection {
    host = "${self.public_ip}"
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("${path.module}/../id_rsa")}"
  }

  provisioner "remote-exec" {
    script = "${path.module}/provision-docker.sh"
  }
}
#############################################

# Allow internal access to the quotes HTTP server from front-end
resource "aws_security_group_rule" "quotes_internal_http" {
  type        = "ingress"
  from_port   = 8082
  to_port     = 8082
  protocol    = "tcp"
  source_security_group_id = "${aws_security_group.front_end_sg.id}"
  security_group_id = "${aws_security_group.quotes_sg.id}"
}

resource "null_resource" "quotes_provision" {
  connection {
      host = "${aws_instance.quotes.public_ip}"
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("${path.module}/../id_rsa")}"
  }
  provisioner "file" {
    source = "${path.module}/provision-quotes.sh"
    destination = "/home/ec2-user/provision.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/provision.sh",
      "/home/ec2-user/provision.sh ${local.ecr_url}quotes:latest"
    ]
  }
}

resource "aws_security_group" "newsfeed_sg" {
  vpc_id      = "${local.vpc_id}"
  name        = "${var.prefix}-newsfeed_sg"
  description = "Security group for newsfeed"

  tags = {
    Name = "SG for newsfeed"
    createdBy = "infra-${var.prefix}/news"
  }
}

# Allow all outbound connections
resource "aws_security_group_rule" "newsfeed_all_out" {
  type        = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.newsfeed_sg.id}"
}

resource "aws_instance" "newsfeed" {
  ami           = "${data.aws_ami.amazon_linux_2.id}"
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.ssh_key.key_name}"
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    delete_on_termination = true
  }

  iam_instance_profile = "${var.prefix}-news_host"

  availability_zone = "${var.region}a"

  subnet_id = local.subnet_id

  vpc_security_group_ids = [
    "${aws_security_group.newsfeed_sg.id}",
    "${aws_security_group.ssh_access.id}"
  ]

  tags = {
    Name = "${var.prefix}-newsfeed"
    createdBy = "infra-${var.prefix}/news"
  }

  connection {
    host = "${self.public_ip}"
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("${path.module}/../id_rsa")}"
  }

  provisioner "remote-exec" {
    script = "${path.module}/provision-docker.sh"
  }
}

# Allow internal access to the newsfeed HTTP server from front-end
resource "aws_security_group_rule" "newsfeed_internal_http" {
  type        = "ingress"
  from_port   = 8081
  to_port     = 8081
  protocol    = "tcp"
  source_security_group_id = "${aws_security_group.front_end_sg.id}"
  security_group_id = "${aws_security_group.newsfeed_sg.id}"
}

resource "null_resource" "newsfeed_provision" {
  connection {
      host = "${aws_instance.newsfeed.public_ip}"
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("${path.module}/../id_rsa")}"
  }
  provisioner "file" {
    source = "${path.module}/provision-newsfeed.sh"
    destination = "/home/ec2-user/provision.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/provision.sh",
      "/home/ec2-user/provision.sh ${local.ecr_url}newsfeed:latest"
    ]
  }
}

resource "null_resource" "front_end_provision" {
  connection {
      host = "${aws_instance.front_end.public_ip}"
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("${path.module}/../id_rsa")}"
  }
  provisioner "file" {
    source = "${path.module}/provision-front_end.sh"
    destination = "/home/ec2-user/provision.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/provision.sh",
<<EOF
      /home/ec2-user/provision.sh \
      --region ${var.region} \
      --docker-image ${local.ecr_url}front_end:latest \
      --quote-service-url http://${aws_instance.quotes.private_ip}:8082 \
      --newsfeed-service-url http://${aws_instance.newsfeed.private_ip}:8081 \
      --static-url http://${aws_s3_bucket.news.website_endpoint}
EOF
    ]
  }
}

output "frontend_url" {
  value = "http://${aws_instance.front_end.public_ip}:8080"
}

#############################################
# Quotes service in apprunner
#############################################

# Create a role for App Runner to access ECR
data "aws_iam_policy_document" "apprunner_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "build.apprunner.amazonaws.com",
        "tasks.apprunner.amazonaws.com"
        ]
    }
  }
}

data "aws_iam_policy" "AWSAppRunnerServicePolicyForECRAccess" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role" "apprunner_role" {
  name = "apprunner_role"
  assume_role_policy = data.aws_iam_policy_document.apprunner_policy.json
}

resource "aws_iam_role_policy_attachment" "apprunner" {
  role       = aws_iam_role.apprunner_role.name
  policy_arn = data.aws_iam_policy.AWSAppRunnerServicePolicyForECRAccess.arn
}

resource "app_runner_quotes_service" "quotes" {
  service_name = "quotes"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_role.arn
    }
    image_repository {
      image_repository_type = "ECR"
      image_identifier = "${local.ecr_url}quotes:latest"
      image_configuration {
        port = 8082
      }
    }
  }
  instance_configuration {
    cpu = "1 vCPU"
    memory = "2 GB"
  }
  create_ingress_vpc_connection = true
  network_configuration {
    ingress_configuration {
      is_publicly_accessible = false
    }
    egress_configuration {
      egress_type = "VPC"
    }
  }
  
  tags = {
    Name = "quotes"
    createdBy = "infra-${var.prefix}/news"
  }
}


#############################################
# Front End but in apprunner
#############################################

# resource "aws_apprunner_service" "news" {
#   service_name = "news"
#   source_configuration {
#     authentication_configuration {
#       access_role_arn = aws_iam_role.apprunner.arn
#     }
#     image_repository {
#       image_repository_type = "ECR"
#       image_identifier = "${local.ecr_url}front_end:latest"
#       image_configuration {
#         port = 8080
#       }
#     }
#   }
#   instance_configuration {
#     cpu = "1 vCPU"
#     memory = "2 GB"
#   }
#   network_configuration {
#     egress_configuration {
#       egress_type = "VPC"
      
#     }
#     # vpc_id = local.vpc_id
#     # public_access_enabled = true
#     # port = 8080
#   }
  
#   tags = {
#     Name = "news"
#     createdBy = "infra-${var.prefix}/news"
#   }
# }

# resource "aws_apprunner_service_configuration" "news" {
#   auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration.news.arn
#   service_arn = aws_apprunner_service.news.arn
#   tags = {
#     Name = "news"
#     createdBy = "infra-${var.prefix}/news"
#   }
# }

# resource "aws_apprunner_auto_scaling_configuration" "news" {
#   auto_scaling_configuration_name = "news"
#   max_concurrent_requests = 100
#   max_concurrent_requests_per_instance = 10
#   max_cpu = 80
#   max_memory = 80
#   min_cpu = 20
#   min_memory = 20
#   timeout_in_seconds = 60
#   tags = {
#     Name = "news"
#     createdBy = "infra-${var.prefix}/news"
#   }
# }