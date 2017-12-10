data "template_file" "vpc_cidr_prefix" {
  template = "172.${16 + var.vpc_index}"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${data.template_file.vpc_cidr_prefix.rendered}.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_route53_zone" "vpc_zone" {
  name = "${ var.cluster_domain }"
}
