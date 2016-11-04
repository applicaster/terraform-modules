output "id" { value = "${ aws_vpc.vpc.id }" }
output "azs" { value = "${ var.azs }" }

output "gateway_id" { value = "${ aws_internet_gateway.gateway.id }" }
output "route_table_id" { value = "${ aws_route_table.private.id }" }
output "default_security_group_id" { value = "${ aws_vpc.vpc.default_security_group_id }" }
output "route53_zone_id" { value = "${ aws_route53_zone.vpc_zone.id }" }

output "subnet_ids" { value = "${ join(",", aws_subnet.public.*.id) }" }
output "subnet_ids_private" { value = "${ join(",", aws_subnet.private.*.id) }" }

output "route53_zone_name_servers" {
    value = "${ join(",", aws_route53_zone.vpc_zone.name_servers) }"
}
