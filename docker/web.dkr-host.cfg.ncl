let docker = import "../../wye/provider/docker/schema.ncl" in

let web = import "../ec2/web.ec2-inst.obs.json" in

{
  target = {
    ssh = {
      endpoint = {
        user = "ubuntu",
        host = web.primary_public_ipv4,
      },
      key_name = "key",
    }
  },
  docker = {},
} | docker.HostConfig
