output "tgw_id"           { value = aws_ec2_transit_gateway.tgw.id }
output "rt_app_id"        { value = aws_ec2_transit_gateway_route_table.rt_app.id }
output "rt_db_id"         { value = aws_ec2_transit_gateway_route_table.rt_db.id }
output "rt_inspection_id" { value = aws_ec2_transit_gateway_route_table.rt_inspection.id }
output "scp_id"           { value = aws_organizations_policy.deny_dangerous.id }
