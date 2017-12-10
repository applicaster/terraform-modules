variable "name" {}
variable "ami" {}
variable "aws_key_name" {}
variable "route53_zone_id_applicaster_com" {}

variable "create_cms_cname" {
  default = false
}

variable "cms_public_dns" {
  default = ""
}

variable "security_groups" {
  type = "list"
}

variable "applicaster2_reset_users" {
  default = false
}

variable "applicaster2_reset_ingestion" {
  default = true
}
