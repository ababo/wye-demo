let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

{
  availability_zone = "us-east-1a",
  type = 'gp3,
  size_gb = 20,
  encrypted = false,
  tags = {
    "environment" = "production",
  }
} | aws_ec2.VolumeConfig
