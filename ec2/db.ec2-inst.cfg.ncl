let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

let eni = import "db.ec2-eni.obs.json" in

{
  ami_id = "ami-00bec3685736827e3",
  instance_type = '"t3.nano",
  is_stopped = false,
  key_name = "wye-poc",
  iam_profile_arn = "arn:aws:iam::446826609862:instance-profile/wye-poc",
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
