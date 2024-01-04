variable "instance_type" {
  description = "AWS EC2 instance type"
  default     = "t3.nano"
  type        = string
}
variable "docker_image_tag" {
  description = "Tag for the docker image to deploy"
  default     = "latest"
  type        = string
}
variable "prefix" {
  description = "Prefix for all resources"
  default     = "news4321"
  type        = string
}
