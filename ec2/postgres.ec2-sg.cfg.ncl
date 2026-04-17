let aws_ec2 = import "../../wye/provider/aws-ec2/schema.ncl" in

let env = import "../env.ncl" in

{
  name = "postgres",
  description = "PostgreSQL access",
  vpc_id = env.vpc_id,
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
        from_port = 5432,
        to_port = 5432,
      }
    }
  ],
} | aws_ec2.SecurityGroupConfig
