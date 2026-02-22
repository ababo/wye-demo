let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

let eni = import "db.ec2-eni.obs.json" in

{
  ami_id = "ami-0f1b9964277dbd54e",
  instance_type = '"t4g.nano",
  is_stopped = false,
  key_name = "key",
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
