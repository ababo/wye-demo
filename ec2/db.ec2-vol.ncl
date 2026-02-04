let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

{
  availability_zone = "us-east-1a",
  type = 'gp3,
  size_gb = 50,
  encrypted = true,
  tags = {
    "environment" = "production",
  }
} | aws_ec2.VolumeConfig
