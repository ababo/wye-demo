let base = import "../../base/schema.ncl" in

{
    providers = {
        "aws-ec2" = {
            kind = "aws-ec2",
            config = import "provider/aws-ec2.ncl"
        },
        "aws-sg" = {
            kind = "aws-sg",
            config = import "provider/aws-sg.ncl"
        },
    },
    providers_concurrency = 32,
} | base.Wye
