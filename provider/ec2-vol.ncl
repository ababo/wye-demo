let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

{
  ec2 = {
    region = "eu-north-1"
  },
  wait_secs = 60,
} | aws_ec2.VolumeProvider
