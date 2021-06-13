variable "availability_zone" {
    type = string
    default = "eu-west-1a"
}

variable "availability_zone_secondary" {
    type = string
    default = "eu-west-1b"
}

variable "cidr_block" {
    description = "(Required) VPC configuration block"
    type = object({
        vpc                     = string
        private_subnet          = string
        public_subnet_primary   = string
        public_subnet_secondary = string
    })
    default = {
        vpc                     = "172.16.0.0/16"
        private_subnet          = "172.16.10.0/24"
        public_subnet_primary   = "172.16.20.0/24"
        public_subnet_secondary = "172.16.30.0/24"
    }
}

variable "usernames" {
    type = list(string)
    default = ["user001", "user002"]
}