let base = import "../../base/schema.ncl" in

{
  providers = {
    "ec2-inst" = {
      kind = "ec2-inst",
      config = import "provider/ec2-inst.ncl"
    },
    "ec2-sg" = {
      kind = "ec2-sg",
      config = import "provider/ec2-sg.ncl"
    },
  },
  providers_concurrency = 32,
} | base.Wye
