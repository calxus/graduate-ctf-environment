variable "vpc_id" {
    type = string
}

variable "private_subnet_id" {
    type = string
}

variable "alb_arn" {
    type = string
}

variable "alb_sg_id" {
    type = string
}

variable "source_cidr_block" {
    type = string
}

variable "username" {
    type = string
}

variable "user_port" {
    type = number
}

variable "alb_dns" {
    type = string
}