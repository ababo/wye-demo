let aws_ec2 = import "../../wye/provider/aws-ec2/schema.ncl" in

let env = import "../env.json" in

let ssh = import "ssh.ec2-sg.obs.json" in
let http = import "http.ec2-sg.obs.json" in

{
  description = "NIC for Web instance",
  subnet_id = env.subnet,
  public_ipv4 = 'ephemeral,
  primary_private_ip = "10.0.0.4",
  security_group_ids = [ssh.id, http.id],
} | aws_ec2.NetworkInterfaceConfig
