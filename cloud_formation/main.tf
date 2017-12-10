data "template_file" "cloud_formation_user_data" {
  template = "${file("${path.module}/cf-user-data.yml.tpl")}"

  vars {
    cf_name                      = "${var.name}"
    applicaster2_reset_users     = "${var.applicaster2_reset_users}"
    applicaster2_reset_ingestion = "${var.applicaster2_reset_ingestion}"
  }
}

resource "aws_instance" "cloud_formation" {
  ami                  = "${var.ami}"
  availability_zone    = "us-east-1a"
  ebs_optimized        = true
  instance_type        = "m3.xlarge"
  monitoring           = false
  key_name             = "${var.aws_key_name}"
  user_data            = "${data.template_file.cloud_formation_user_data.rendered}"
  iam_instance_profile = "service-applicaster2"

  security_groups = ["${var.security_groups}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  tags {
    "Name" = "cloud-formation-${var.name}"
  }
}

resource "aws_route53_zone" "cf_zone" {
  name    = "${var.name}.applicaster.com."
  comment = ""
}

resource "aws_route53_record" "applicaster_com_ns_record" {
  zone_id = "${var.route53_zone_id_applicaster_com}"
  name    = "${var.name}.applicaster.com."
  type    = "NS"
  records = ["${aws_route53_zone.cf_zone.name_servers}"]
  ttl     = "86400"
}

resource "aws_route53_record" "cf_wildcard_cname" {
  zone_id = "${aws_route53_zone.cf_zone.id}"
  name    = "*.${var.name}.applicaster.com."
  type    = "CNAME"
  records = ["${aws_instance.cloud_formation.public_dns}"]
  ttl     = "300"
}

resource "aws_route53_record" "cms_cname" {
  count   = "${var.create_cms_cname}"
  zone_id = "${aws_route53_zone.cf_zone.id}"
  name    = "cms.${var.name}.applicaster.com."
  type    = "CNAME"
  records = ["${var.cms_public_dns}"]
  ttl     = "300"
}
