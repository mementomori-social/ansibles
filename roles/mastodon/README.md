mastodon
========

This role is part of [mementomori](https://mementomori.social) ansible automation.
Mastodon role installs mastodon services.

Requirements
------------

You'll need:
- web server in front of mastodon (nginx role)
- database behind it (postgresql role)
- Key val store (valkey role)
- Elasticsearch for search indexing (elasticsearch role)

Role Variables
--------------

| Variable | Default | Description |
|----------|---------|-------------|
| `mastodon_data_device` | `/dev/sdb` | Block device for Mastodon data partition |
| `mastodon_data_mountpoint` | `/data` | Mount point for Mastodon data volume |
| `mastodon_mount_fs_type` | `ext4` | Filesystem type for data partition |
| `mastodon_mount_opts` | `defaults` | Mount options for data partition |
| `mastodon_home` | `{{ mastodon_data_mountpoint }}/mastodon` | Mastodon application home directory |
| `mastodon_packages` | `[autoconf, bison, ...]` | List of system packages required by Mastodon |
| `mastodon_systemd_files` | `[mastodon-sidekiq-*.service, mastodon-streaming*.service, ...]` | Systemd service/timer files |
| `mastodon_services` | `[mastodon-sidekiq-1-default@35.service, ...]` | Systemd services actually enabled on this host |
| `mastodon_fedifetch_access_token` | `{{ vault_mastodon_fedifetch_access_token }}` | Secret token for Fedifetcher (from vault) |
| `mastodon_fedifetch_server` | `mementomori.social` | Server hostname for Fedifetcher |
| `mastodon_betterstack_sidekick` | `{{ vault_mastodon_betterstack_sidekick }}` | Betterstack Sidekick token for log shipping (from vault) |

Dependencies
------------

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: mastodon
      roles:
         - { role: mastodon }

License
-------

BSD

Author Information
------------------

ilkka.tengvall@iki.fi
