let aws_ec2 = import "../../wye/provider/aws-ec2/schema.ncl" in

let env = import "../env.json" in

{
  ec2 = {
    region = env.region,
  },
  cache_root_block_device = true,
  wait_secs = 300,
} | aws_ec2.InstanceProvider
