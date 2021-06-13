data "aws_ami" "kali" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["kali-linux-*"]
  }
}

resource "random_password" "password" {
  length  = 8
  special = false
}

data "template_file" "kali" {
  template = file("${path.module}/kali_user_data.sh")
  vars = {
    kali_user = var.username
    kali_pass = random_password.password.result
  }
}

resource "aws_instance" "kali" {
  ami                         = data.aws_ami.kali.image_id
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.kali.id]
  subnet_id                   = var.private_subnet_id
  user_data                   = data.template_file.kali.rendered

  root_block_device {
    volume_type = "standard"
    volume_size = "40"
  }
}

resource "aws_lb_listener" "kali" {
  load_balancer_arn = var.alb_arn
  port              = var.user_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kali.arn
  }
}

resource "aws_lb_target_group" "kali" {
  name     = "${var.username}-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "kali" {
  target_group_arn = aws_lb_target_group.kali.arn
  target_id        = aws_instance.kali.id
  port             = 8080
}

resource "aws_security_group" "kali" {
  name        = join(" ", [var.username, "security group"])
  description = "Kali machine security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "grad_ctf_ingress" {
  description       = "Rule to allow traffic to vault from local cidr"
  type              = "ingress"
  protocol          = "TCP"
  from_port         = var.user_port
  to_port           = var.user_port
  security_group_id = var.alb_sg_id
  cidr_blocks       = [var.source_cidr_block]
}

resource "aws_security_group_rule" "grad_ctf_egress_kali" {
  description              = "Allow vault to talk to VPC Endpoints (KMS)"
  type                     = "egress"
  protocol                 = "TCP"
  from_port                = 8080
  to_port                  = 8080
  security_group_id        = var.alb_sg_id
  source_security_group_id = aws_security_group.kali.id
}

resource "aws_security_group_rule" "kali_ingress_grad_ctf" {
  description              = "Allow vault to talk to VPC Endpoints (KMS)"
  type                     = "ingress"
  protocol                 = "TCP"
  from_port                = 8080
  to_port                  = 8080
  security_group_id        = aws_security_group.kali.id
  source_security_group_id = var.alb_sg_id
}

resource "aws_security_group_rule" "kali_egress_sahara" {
  description              = "Allow vault to talk to VPC Endpoints (KMS)"
  type                     = "egress"
  protocol                 = "TCP"
  from_port                = 0
  to_port                  = 65535
  security_group_id        = aws_security_group.kali.id
  source_security_group_id = aws_security_group.sahara.id
}

resource "aws_security_group_rule" "kali_ingress_sahara" {
  description              = "Allow vault to talk to VPC Endpoints (KMS)"
  type                     = "ingress"
  protocol                 = "TCP"
  from_port                = 0
  to_port                  = 65535
  security_group_id        = aws_security_group.kali.id
  source_security_group_id = aws_security_group.sahara.id
}