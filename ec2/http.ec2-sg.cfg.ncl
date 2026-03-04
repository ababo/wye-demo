let aws_ec2 = import "../../../provider/aws-ec2/schema.ncl" in

{
  name = "http",
  description = "HTTP(S) access",
  vpc_id = "vpc-06e5a067a734f2a92",
  ingress = [
    {
      tcp = {
        sources = [
          {
            cidr = {
              net = "0.0.0.0/0",
            }
          }
        ],
        from_port = 80,
        to_port = 80,
      }
    },
    {
      tcp = {
        sources = [
          {
            cidr = {
              net = "0.0.0.0/0",
            }
          }
        ],
        from_port = 443,
        to_port = 443,
      }
    }
  ],
} | aws_ec2.SecurityGroupConfig
