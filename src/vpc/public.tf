resource "aws_subnet" "public" {
  count = "${ var.num_public_subnets }"

  availability_zone = "${ element( split(",", var.azs), count.index ) }"
  cidr_block        = "${data.template_file.vpc_cidr_prefix.rendered}.${ count.index }.0/24"
  vpc_id            = "${ aws_vpc.vpc.id }"

  tags {
    Name              = "${var.vpc_name}-public"
  }
}

resource "aws_route" "public" {
  route_table_id         = "${ aws_vpc.vpc.main_route_table_id }"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${ aws_internet_gateway.gateway.id }"
}

resource "aws_route_table_association" "public" {
  count = "${ var.num_public_subnets }"

  route_table_id = "${ aws_vpc.vpc.main_route_table_id }"

  /*route_table_id = "${ aws_route_table.public.id }"*/
  subnet_id = "${ element(aws_subnet.public.*.id, count.index) }"
}
