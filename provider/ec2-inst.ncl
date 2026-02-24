let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

{
  ec2 = {
    region = "eu-north-1"
  },
  cache_root_block_device = true,
  wait_secs = 300,
} | aws_ec2.InstanceProvider
