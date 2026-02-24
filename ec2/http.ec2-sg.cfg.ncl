let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

{
  name = "http",
  description = "HTTP access",
  vpc_id = "vpc-06e5a067a734f2a92",
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
        from_port = 80,
        to_port = 80,
      }
    }
  ],
} | aws_ec2.SecurityGroupConfig
