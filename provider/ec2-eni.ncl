let aws_ec2 = import "../../wye/provider/aws-ec2/schema.ncl" in

let env = import "../env.json" in

{
  ec2 = {
    region = env.region,
  },
  cache_ephemeral_public_ipv4 = true,
  wait_secs = 60,
} | aws_ec2.NetworkInterfaceProvider
