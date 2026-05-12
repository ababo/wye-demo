
# Wye Demo Setup

This is a minimal Wye setup intended for demonstration purposes. It consists of two Docker containers running on dedicated EC2 instances: a Wiki.js web server and a PostgreSQL database.

## Repository Structure

The project root contains the following:

* **docker/** — Docker host and container resources.
* **ec2/** — Resources for EC2 security groups, network interfaces, and instances.
* **provider/** — Provider configuration files.
* **script/** — Bootstrap and teardown scripts.
* **vault/** — Secrets vault containing an SSH key for EC2 instances (not part of the repo).
* **.gitignore** — Git ignore rules.
* **.wyeignore** — Wye ignore rules.
* **README.md** — This file.
* **env.json** — EC2 environment configuration (not part of the repo).
* **wye.ncl** — Main Wye configuration file.

---

## Steps

1. **Ensure you have the AWS CLI** installed and configured with valid access to AWS.
2. **Ensure that jq is installed.**
3. **Bootstrap the demo environment** with the following command:

	```shell
	script/bootstrap.sh
	```
	This script will:
	* create a new AWS VPC;
	* create a subnet with `CIDR = 10.0.0.0/24` associated with this VPC;
	* create an Internet Gateway associated with this VPC;
	* create a Route Table associated with this VPC;
	* add a rule to the route table for Internet access (0.0.0.0/0);
	* create a Key Pair, download the generated key, and move it to `vault/ssh-key.pem`;
	* create an `env.json` file that will be used by the configuration files;

4. **Remove all resources from the Git index.** In Wye, the index always reflects the current system state:

	```shell
	git rm --cached ec2/* docker/*
	```

5. **Reconcile the worktree resources with the system** (deploy all resources):

	```shell
	wye stage $(git ls-files --others --exclude-standard)
	```

	**Note**: When a resource is reconciled, it is immediately reflected in the index. This is helpful if the `stage` command fails mid-process, as the index clearly shows which resource changes were applied.

	**Note 2**: Each resource includes an associated `.obs.json` file containing the observed state (e.g., IDs, IP addresses). These are imported by dependent configuration files. They are ephemeral, excluded from the repository, and regenerated during resource updates or manual scans.

	**Note 3**: Ensure resources are added to the index so the live system corresponds to `HEAD`. Extract the `primary_public_ipv4` from `ec2/web.ec2-inst.obs.json` and open `http://<this-ip>` in your browser to view the Wiki.js setup page.

6. **Scan for real changes** by comparing the live system against your configuration:

	```shell
	wye scan-sync -d
	```

	**Note**: If any unknown resources are detected during the scan, an `untracked/` directory will be created containing `.obs.json` and `.cfgdiff.json` files. The latter detail the differences between your configuration and the actual state. Since no such resources were yet introduced, the `untracked/` directory is not present.

7. **Simulate an issue** by stopping the `db` container. Extract the `primary_public_ipv4` from `ec2/db.ec2-inst.obs.json`, connect to the instance, and stop the `wiki-storage` container:

	```shell
	ssh -i vault/ssh-key.pem ubuntu@<ip-address> sudo docker stop wiki-storage
	```

8. **Launch a live scan** to diagnose the issue:

	```shell
	wye scan-sync -d
	```

	**Note**: The command output will contain:
	```text
	WARN  base::registry::synchronize] detected non-empty config diff for docker/db.dkr-ctr
	```
	You will also find a new `docker/db.dkr-ctr.cfgdiff.json` file containing:
	```text
	{"stopped":true}
	```

9. **Heal the system** by enforcing the `db` container configuration:

	```shell
	wye stage docker/db.dkr-ctr.cfg.ncl
	```

	**Note**: This command triggers a resource update. Wye detects that the `is_stopped` attribute differs from the expected state and issues a `docker start` command. After this, a subsequent scan should no longer show the warning.

10. **Add an untracked security group** into the current VPC:

	```shell
	aws ec2 create-security-group \
	  --group-name external \
	  --description "Untracked security group" \
	  --region <your-region> \
	  --vpc-id <your-vpc-id>
	```

11. **Run the scan again**:

	```shell
	wye scan-sync -d
	```

	**Note**: Now you can find corresponding `.cfgdiff.json` and `.obs.json` files in the `untracked/` directory.

12. **Remove the untracked security group**:

	```shell
	aws ec2 delete-security-group \
	  --group-id <untracked-group-id> \
	  --region <your-region>
	```

13. **Destroy the setup** to conclude the demo:

	```shell
	rm ec2/*.cfg.ncl docker/*.cfg.ncl
	wye stage $(git diff --name-only --diff-filter=D)
	```

14. **Teardown the demo environment** with the following command:

	```shell
	script/teardown.sh
	```
