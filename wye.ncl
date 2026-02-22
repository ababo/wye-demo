let base = import "../../base/schema.ncl" in

{
  providers = {
    "ec2-eni" = {
      kind = "aws-ec2-eni",
      config = import "provider/ec2-eni.ncl"
    },
    "ec2-inst" = {
      kind = "aws-ec2-inst",
      config = import "provider/ec2-inst.ncl"
    },
    "ec2-sg" = {
      kind = "aws-ec2-sg",
      config = import "provider/ec2-sg.ncl"
    },
    "ec2-vol" = {
      kind = "aws-ec2-vol",
      config = import "provider/ec2-vol.ncl"
    },
  },
  providers_concurrency = 32,
} | base.Wye
