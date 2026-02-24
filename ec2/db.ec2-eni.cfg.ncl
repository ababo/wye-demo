let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

let postgres = import "postgres.ec2-sg.obs.json" in

{
  description = "NIC for DB instance",
  subnet_id = "subnet-0ebc0f4935a485b30",
  primary_private_ip = "10.0.0.5",
  security_group_ids = [postgres.id],
} | aws_ec2.NetworkInterfaceConfig
