let docker = import "../../../provider/docker/schema.ncl" in

let web = import "../ec2/web.ec2-inst.obs.json" in

{
    target = {
        ssh = {
            endpoint = {
              user = "ubuntu",
              host = web.public_ip,
            },
            key_name = "key",
        }
    },
    docker = {
    },
} | docker.HostConfig
