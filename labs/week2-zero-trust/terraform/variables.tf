variable "region" { type = string, default = "us-east-1" }

variable "app_vpc_id"        { type = string }
variable "db_vpc_id"         { type = string }
variable "inspection_vpc_id" { type = string }

variable "app_subnet_ids"        { type = list(string) }
variable "db_subnet_ids"         { type = list(string) }
variable "inspection_subnet_ids" { type = list(string) }

# (Optional) CIDRs so routes can be strict (replace with your real CIDRs)
variable "app_cidr" { type = string, default = "10.0.0.0/16" }
variable "db_cidr"  { type = string, default = "10.1.0.0/16" }
