module "grad_ctf" {
  source = "../../../modules/grad_ctf"

  count = length(var.usernames)
  vpc_id = aws_vpc.grad_ctf.id
  private_subnet_id = aws_subnet.grad_ctf_private.id
  alb_arn = aws_lb.grad_ctf.arn
  alb_sg_id = aws_security_group.grad_ctf.id
  alb_dns = aws_lb.grad_ctf.dns_name
  source_cidr_block = "51.7.166.226/32"
  username = var.usernames[count.index]
  user_port = 9090 + count.index
}
