let docker = import "../../wye/provider/docker/schema.ncl" in

let db = import "../ec2/db.ec2-inst.obs.json" in
let web = import "../ec2/web.ec2-inst.obs.json" in

let _ = import "../docker/db.dkr-ctr.obs.json" in
let _ = import "../docker/web.dkr-host.obs.json" in

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
  docker = {
    command = ["node", "--no-deprecation", "server"],
    container_name = "wiki-server",
    environment = {
      # Image-injected.
      "NODE_VERSION" = "24.13.0",
      "YARN_VERSION" = "1.22.22",
      # Custom.
      "DB_TYPE" = "postgres",
      "DB_HOST" = db.primary_public_ipv4,
      "DB_PORT" = "5432",
      "DB_USER" = "postgres",
      "DB_PASS" = "postgres",
      "DB_NAME" = "wiki",
    },
    image = "requarks/wiki:2.5",
    labels = [
        # Image-injected.
        "maintainer=requarks.io",
    ],
    ports = { "3000" = [{ port = 80 }] },
    user = "node",
  },
} | docker.ContainerConfig
