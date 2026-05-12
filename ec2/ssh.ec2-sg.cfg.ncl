let aws_ec2 = import "../../wye/provider/aws-ec2/schema.ncl" in

let env = import "../env.json" in

{
  name = "ssh",
  description = "SSH access",
  vpc_id = env.vpc,
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
        from_port = 22,
        to_port = 22,
      }
    }
  ],
} | aws_ec2.SecurityGroupConfig
