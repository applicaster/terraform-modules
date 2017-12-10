resource "aws_iam_user" "user" {
  name = "${var.service_name}-${var.environment}"
}

resource "aws_iam_access_key" "access_key" {
  user = "${aws_iam_user.user.name}"
}
