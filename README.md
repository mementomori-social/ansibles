# Mementomori automation playbooks

This repo contains ansible automation to setup and maintain
[mementomori mastodon instance](https://mementomori.social) infra.

In addition to this repo you will need set of variables defined in
secrets/vault.yml file. All such variables are named with prefix `vault_` so
you know to create your own vault if you want to try this automation yourself.

# Prerequisites

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

# Playbooks

Here are some use cases for the playbooks:

## Quick health check of the machines

This will check the hosts are reachable, and posts a summary of some details to
matrix channel if `-e send_to=matrix` is added.


```sh
ansible-playbook -i inventory-hetzner.yml -e @secrets/vault.yml ping.yml
```


## Update hosts

Updates the hosts software packages and reboots the host if seem necessary.
Also warns if you should reboot anyway due deleted files in use.

```sh
ansible-playbook -i inventory-hetzner.yml -e @secrets/vault.yml update-host.yml
```

# Roles

We provision services based on roles. Aim is so we can scale and move services
between the hosts if later needed.

* **dev-vm** - Create server for developing mementomori features & BirdUI
* **elasticsearch** - Install and configure elastic search for mastodon search
* **mastodon** - Install and configure mastodon services
* **nginx** - Install and configre web server with reverse proxy and cert automation
* **postgresql** - Install and configure database for mastodon
* **valkey** - Install and configure key-val store for mastodon

# Testing

[Molecule](https://docs.ansible.com/projects/molecule/) can be used to test the playbooks created.
It is set to use podman with debian stable images for testing the playbooks.
See test [inventory.yml](molecule/debian/inventory.yml) for test containers
and [verify.yml](molecule/debian/verify.yml) for test cases.

Useful commands (in repo root):

```sh
# Test the complete lifecycle
molecule
 test --scenario-name debian

# Run specific actions
molecule create --scenario-name debian
molecule converge --scenario-name debian
molecule verify --scenario-name debian
```

## Requirements

You'll need podman and molecule on your dev env. In Fedora:

```sh
sudo dnf install podman
pip install --user molecule
```

