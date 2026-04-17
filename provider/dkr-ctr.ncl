let docker = import "../../wye/provider/docker/schema.ncl" in

{
  transport = {
    ssh = {
      host_provider_id = "dkr-host",
      keys = {
        "key" = { key_file = "vault/ssh-key.pem" },
      },
    },
  },
  concurrency = 32,
} | docker.ContainerProvider
