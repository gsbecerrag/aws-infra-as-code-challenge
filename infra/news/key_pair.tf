resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.prefix}-news"
  public_key = file("${path.module}/../id_rsa.pub")
}