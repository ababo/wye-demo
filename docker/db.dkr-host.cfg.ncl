let docker = import "../../wye/provider/docker/schema.ncl" in

let db = import "../ec2/db.ec2-inst.obs.json" in

{
  target = {
    ssh = {
      endpoint = {
        user = "ubuntu",
        host = db.primary_public_ipv4,
      },
      key_name = "key",
    }
  },
  docker = {},
} | docker.HostConfig
