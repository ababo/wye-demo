let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

{
  ec2 = {
    region = "us-east-1"
  },
  cache_ephemeral_public_ipv4 = true,
  wait_secs = 60,
} | aws_ec2.NetworkInterfaceProvider
