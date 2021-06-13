resource "aws_lb" "grad_ctf" {
  name               = "grad-ctf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.grad_ctf.id]
  subnets            = [aws_subnet.grad_ctf_public_a.id, aws_subnet.grad_ctf_public_b.id]
}

resource "aws_security_group" "grad_ctf" {
  name        = "Graduate CTF Load balancer security group"
  description = "Graduate CTF Load balancer security group"
  vpc_id      = aws_vpc.grad_ctf.id
}