resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  depends_on = ["aws_internet_gateway.gateway"]

  allocation_id = "${ aws_eip.nat.id }"
  subnet_id     = "${ aws_subnet.public.0.id }"
}

resource "aws_subnet" "private" {
  count = "${ var.num_private_subnets }"

  availability_zone = "${ element( split(",", var.azs), count.index ) }"
  cidr_block        = "${data.template_file.vpc_cidr_prefix.rendered}.${ count.index + 10 }.0/24"
  vpc_id            = "${ aws_vpc.vpc.id }"

  tags {
    Name = "${var.vpc_name}-private"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${ aws_vpc.vpc.id }"

  tags {
    Name = "${var.vpc_name}-private"
  }
}

resource "aws_route" "nat" {
  route_table_id         = "${ aws_route_table.private.id }"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${ aws_nat_gateway.nat.id }"
}

resource "aws_route_table_association" "private" {
  count = "${ var.num_private_subnets }"

  route_table_id = "${ aws_route_table.private.id }"
  subnet_id      = "${ element(aws_subnet.private.*.id, count.index) }"
}
