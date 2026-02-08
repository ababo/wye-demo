let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

let ssh = import "ssh.ec2-sg.st.json" in
let https = import "https.ec2-sg.st.json" in

{
  description = "NIC for Web instance",
  subnet_id = "subnet-5c90aa357fade182f",
  public_ipv4 = 'ephemeral,
  primary_private_ip = "10.1.0.2",
  security_group_ids = [ssh.id, https.id],
  tags = {
    "environment" = "production",
  }
} | aws_ec2.NetworkInterfaceConfig
