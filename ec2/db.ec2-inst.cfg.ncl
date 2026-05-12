let aws_ec2 = import "../../wye/provider/aws-ec2/schema.ncl" in

let env = import "../env.json" in

let eni = import "db.ec2-eni.obs.json" in

{
  ami_id = env.ami,
  instance_type = '"t3.nano",
  is_stopped = false,
  key_name = env.key,
  metadata = {
    enforce_imdsv2 = false,
  },
  primary_network_interface_id = eni.id,
  root_block_device = {
    type = 'gp3,
    size_gb = 20,
    encrypted = false,
  }
} | aws_ec2.InstanceConfig
