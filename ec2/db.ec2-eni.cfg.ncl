let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

let ssh = import "ssh.ec2-sg.st.json" in
let postgres = import "postgres.ec2-sg.st.json" in

{
  description = "NIC for DB instance",
  subnet_id = "subnet-5c90aa357fade182f",
  primary_private_ip = "10.1.0.1",
  security_group_ids = [ssh.id, postgres.id],
  tags = {
    "environment" = "production",
  }
} | aws_ec2.NetworkInterfaceConfig
