data "aws_ami" "sahara" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["import-ami-0b13532f4408d6d12"]
  }
}

resource "aws_instance" "sahara" {
  ami                         = data.aws_ami.sahara.image_id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.sahara.id]
  subnet_id                   = var.private_subnet_id

  root_block_device {
    volume_type = "standard"
    volume_size = "40"
  }
}

resource "aws_security_group" "sahara" {
  name        = join(" ", [var.username, "sahara security group"])
  description = "sahara machine security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "sahara_ingress_kali" {
  description              = "Allow vault to talk to VPC Endpoints (KMS)"
  type                     = "ingress"
  protocol                 = "TCP"
  from_port                = 0
  to_port                  = 65535
  security_group_id        = aws_security_group.sahara.id
  source_security_group_id = aws_security_group.kali.id
}

resource "aws_security_group_rule" "sahara_egress_kali" {
  description              = "Allow vault to talk to VPC Endpoints (KMS)"
  type                     = "egress"
  protocol                 = "TCP"
  from_port                = 0
  to_port                  = 65535
  security_group_id        = aws_security_group.sahara.id
  source_security_group_id = aws_security_group.kali.id
}