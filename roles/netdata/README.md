Netdata
=======

This role is part of [mementomori](https://mementomori.social) ansible automation.
Installs Netdata monitoring agent from the official apt repository and connects it to Netdata Cloud.

Requirements
------------

Ubuntu 26.04 (Resolute). Vault-encrypted `vault_netdata_token` and `vault_netdata_rooms` for Cloud claiming.

Role Variables
--------------

- `netdata_apt_suite` - repo codename (default: `resolute/`)
- `netdata_dbengine_multihost_disk_space` - disk space for metrics in MiB (default: `256`)
- `netdata_web_mode` - local dashboard mode (default: `none`)
- `netdata_cloud_claim_token` - Cloud claim token (from vault)
- `netdata_cloud_claim_rooms` - Cloud room ID (from vault)

Dependencies
------------

Example Playbook
----------------

    - hosts: all
      roles:
         - { role: netdata }

License
-------

BSD

Author Information
------------------

ilkka.tengvall@iki.fi
