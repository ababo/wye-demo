let docker = import "../../../provider/docker/schema.ncl" in

{
  transport = {
    ssh = {
      host_provider_id = "dkr-host",
      keys = {
        "key" = { key_file = "../vault/wye-poc.pem" },
      },
    },
  },
  concurrency = 32,
} | docker.ContainerProvider
