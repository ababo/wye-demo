let aws_ec2 = import "../../wye/provider/aws-ec2/schema.ncl" in

let env = import "../env.json" in

{
  name = "http",
  description = "HTTP(S) access",
  vpc_id = env.vpc,
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
