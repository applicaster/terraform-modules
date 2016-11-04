variable "vpc_name" {}
variable "azs" {}
variable "cluster_domain" {}

variable "num_public_subnets" {
  default = 3
}
variable "num_private_subnets" {
  default = 3
}

variable "vpc_index" {
    description = <<DESC
A unique index for the vpc.
This will be used to build the CIDR block for the VPC.
should be an integer in the range 0-10
DESC
}
