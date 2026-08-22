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
ansible-playbook -i inventory.yml -e @secrets/vault.yml ping.yml
```


## Update hosts

Updates the hosts software packages and reboots the host if seem necessary.
Also warns if you should reboot anyway due deleted files in use.

```sh
ansible-playbook -i inventory.yml -e @secrets/vault.yml update-host.yml
```


