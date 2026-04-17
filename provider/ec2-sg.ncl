let aws_ec2 = import "../../wye/provider/aws-ec2/schema.ncl" in

let env = import "../env.ncl" in

{
  ec2 = {
    region = env.region,
  }
} | aws_ec2.SecurityGroupProvider
