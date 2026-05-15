let aws_ec2 = import "../../wye/provider/aws-ec2/schema.ncl" in

let env = import "../env.json" in

{
  ec2 = {
    region = env.region,
  },
  vpc_id = env.vpc,
} | aws_ec2.SecurityGroupProvider
