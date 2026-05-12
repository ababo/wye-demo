let aws_ec2 = import "../../wye/provider/aws-ec2/schema.ncl" in

let env = import "../env.json" in

let ssh = import "ssh.ec2-sg.obs.json" in
let postgres = import "postgres.ec2-sg.obs.json" in
let http = import "http.ec2-sg.obs.json" in

{
  description = "NIC for DB instance",
  subnet_id = env.subnet,
  public_ipv4 = 'ephemeral,
  primary_private_ip = "10.0.0.5",
  security_group_ids = [ssh.id, postgres.id, http.id],
} | aws_ec2.NetworkInterfaceConfig
