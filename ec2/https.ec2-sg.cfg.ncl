let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

{
  name = "postgres",
  description = "PostgreSQL access",
  vpc_id = "vpc-0a1b2c3d4e5f6a7b8",
  ingress = [
    {
      tcp = {
        sources = [
          {
            cidr = {
              net = "0.0.0.0/0",
              description = "from any machine",
            }
          }
        ],
        from_port = 443,
        to_port = 443,
      }
    }
  ],
  egress = [],
  tags = {
    "environment" = "production",
  }
} | aws_ec2.SecurityGroupConfig
