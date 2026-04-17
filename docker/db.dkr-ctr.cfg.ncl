let docker = import "../../wye/provider/docker/schema.ncl" in

let db = import "../ec2/db.ec2-inst.obs.json" in

let _ = import "../docker/db.dkr-host.obs.json" in

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
  docker = {
    command = ["postgres"],
    container_name = "wiki-storage",
    environment = {
      # Image-injected.
      "GOSU_VERSION" = "1.19",
      "LANG" = "en_US.utf8",
      "PATH" = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/postgresql/18/bin",
      "PGDATA" = "/var/lib/postgresql/18/docker",
      "PG_MAJOR" = "18",
      "PG_VERSION" = "18.3-1.pgdg13+1",
      # Custom.
      "POSTGRES_USER" = "postgres",
      "POSTGRES_PASSWORD" = "postgres",
      "POSTGRES_DB" = "wiki",
    },
    image = "postgres:18.3",
    ports = { "5432" = [{ port = 5432 }] },
    storage = {
      volumes = { "/var/lib/postgresql" = { path = "/home/ubuntu/pgdata" } },
    },
  },
} | docker.ContainerConfig
