WireGuard
=========

This role is part of [mementomori](https://mementomori.social) ansible automation.
Installs and configures a WireGuard VPN server with peer management and firewall rules.

Requirements
------------

Vault-encrypted `vault_wg_server_private_key` for the server private key.

Role Variables
--------------

- `wg_interface` - WireGuard interface name (default: `wg0`)
- `wg_port` - listen port (default: `51820`)
- `wg_address` - server VPN address (default: `10.222.223.1/24`)
- `wg_server_private_key` - server private key (from vault, or auto-generated)
- `wg_peers` - list of peer definitions with `name`, `public_key`, and `allowed_ips`
- `server_public_interface` - public network interface for NAT (default: `eth0`)

Dependencies
------------

Example Playbook
----------------

    - hosts: bastion
      roles:
         - { role: wireguard }

License
-------

BSD

Author Information
------------------

ilkka.tengvall@iki.fi
