# Mementomori.social Mastodon instance playbooks

[![Build](https://img.shields.io/github/actions/workflow/status/mementomori-social/ansibles/lint.yml?style=for-the-badge&label=build)](https://github.com/mementomori-social/ansibles/actions/workflows/lint.yml)

This repo contains ansible automation to setup and maintain
[mementomori.social Mastodon instance](https://mementomori.social) infra.

In addition to this repo you will need set of variables defined in
secrets/vault.yml file. All such variables are named with prefix `vault_` so
you know to create your own vault if you want to try this automation yourself.

## Prerequisites

1. [Install ansible](https://docs.ansible.com/projects/ansible/latest/getting_started/get_started_ansible.html).
2. Clone this repo and goto that directory
   `git clone https://github.com/mementomori-social/ansibles.git` 
3. Pull required collections
   `ansible-galaxy collection install -r collections/requirements.yml -p collections`
4. Clone secret vault and link to it
   ```sh
   git clone <vault_url> ../secrets
   ln -s ../secrets
   ```
5. Write your vault password to .vaultpw file
6. If you want messages sent to matrix install matrix-client
   `pip install matrix-client`

## Inventories

* `inventory-upcloud.yml` is the dynamic inventory for UpCloud, see
  [the docs](https://upcloud.com/docs/guides/get-started-ansible-inventory/).
  Hosts are grouped by their `role` label, and every host except the bastion
  is reached through the bastion.

Check the inventory contents:

```sh
PYTHONPATH=collections ansible-inventory -i inventory-upcloud.yml --graph --vars
```

## Secrets Vault

We have secrets in ansible vault. It's a good idea to put link to vault in `group_vars/all/` directory.

```sh
cd group_vars/all
ln -s ../../secrets/vault.yml .
```

## Build a server

Servers live in UpCloud zone `fi-hel2` on the private network `10.222.222.0/24`.

1. Create the private network, router and NAT gateway, once per zone:
   ```sh
   ansible-playbook upcloud-network.yml
   ```
2. Create the data disks the server needs, then put each UUID in its
   `upcloud-create-*.yml` (`data_storage_uuid`, `backup_storage_uuid`).
   Data disks live apart from the server, so rebuilding a server keeps its data:
   ```sh
   upctl storage create --zone fi-hel2 --tier maxiops --size 300 --title postgresql.mementomori.social-data
   ```
3. Create the server. Build the bastion first, the other servers are reached
   through it:
   ```sh
   ansible-playbook upcloud-create-bastion.yml
   ansible-playbook upcloud-create-postgresql.yml
   ansible-playbook upcloud-create-elastic.yml
   ansible-playbook upcloud-create-mastodon-0.yml
   ```
4. Configure it, or every server at once with `site.yml`:
   ```sh
   ansible-playbook -i inventory-upcloud.yml postgresql.mementomori.social.yml
   ```

## Playbooks

### Quick health check of the machines

Checks the hosts are reachable and, with `-e send_to=matrix`, posts a summary
to the Matrix channel.

```sh
ansible-playbook -i inventory-upcloud.yml ping.yml
```

### Update hosts

Updates the software packages and restarts a host when the update needs it.

```sh
ansible-playbook -i inventory-upcloud.yml update-host.yml
```


## Roles

We provision services based on roles. Aim is so we can scale and move services
between the hosts if later needed.

* **dev-vm** - Create server for developing mementomori.social features & BirdUI
* **elasticsearch** - Install and configure elastic search for mastodon search
* **mastodon** - Install and configure mastodon services
* **nginx** - Install and configre web server with reverse proxy and cert automation
* **postgresql** - Install and configure database for mastodon
* **valkey** - Install and configure key-val store for mastodon

## Testing

[Molecule](https://docs.ansible.com/projects/molecule/) can be used to test the playbooks created.
It is set to use podman with Ubuntu 26.04 images, the same as the UpCloud template, for testing the playbooks.
See test [inventory.yml](molecule/default/inventory.yml) for test containers
and [verify.yml](molecule/default/verify.yml) for test cases.

Useful commands (in repo root):

```sh
# Test the complete lifecycle
molecule test

# Run specific actions
molecule create
molecule converge
molecule verify
```

This lets you keep running ansible setup playbooks and tests all over again
without always destroying the containers in between.

## Requirements

You'll need podman and molecule on your dev env. In Fedora:

```sh
sudo dnf install podman
pip install --user molecule
```

