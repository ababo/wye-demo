let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

{
  ec2 = {
    region = "us-east-1"
  }
} | aws_ec2.SgProvider
