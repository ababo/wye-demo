let docker = import "../../../provider/docker/schema.ncl" in

let db = import "../ec2/db.ec2-inst.obs.json" in

{
    target = {
        ssh = {
            endpoint = {
              user = "ubuntu",
              host = db.public_ip,
            },
            key_name = "key",
        }
    },
    docker = {},
} | docker.HostConfig
