output "username" {
    value = var.username
}

output "password" {
    value = random_password.password.result
}

output "url" {
    value = "http://${var.alb_dns}:${var.user_port}/guacamole"
}

output "sahara_dns" {
    value = aws_instance.sahara.private_dns
}