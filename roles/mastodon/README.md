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

See `defaults/main.yml` for all variables. There is also in addition all
mastodon config file variables. Everything prefixed with `vault_` is coming
from ansible vault. Those are described in
[mastodon config docs](https://docs.joinmastodon.org/admin/config/).

Tasks
-----

### main.yml

Installs and configures Mementomori Mastodon instance:

1. **Repository setup** - Installs NodeSource Node.js 24 repo
2. **System packages** - Installs all required dependencies (build tools, imagemagick, ffmpeg, libvips, etc.)
3. **Data mount** - Mounts separate data partition at `mastodon_data_mountpoint`
4. **User setup** - Creates mastodon user (uid 1100) with home at `mastodon_home`
5. **Mastodon code** - Clones mastodon repo to `{{ mastodon_home }}/live` at `mastodon_version_metadata`
6. **Config** - Deploys `.env.production` from template
7. **Ruby** - Installs rbenv and builds required Ruby version
8. **Bundle** - Runs `bundle config` and `bundle install`
9. **Yarn** - Enables corepack and runs `yarn install`
10. **Bin scripts** - Deploys helper scripts (flush-dead-jobs, mastodon-prune, refetch-preview-cards, etc.)
11. **FediFetcher** - Installs and configures FediFetcher
12. **Systemd** - Deploys and enables all mastodon service files and timers

### upgrade.yml

** WIP **

Upgrades Mastodon to the version specified by `mastodon_version_metadata`:

1. **Safety checks** - Aborts any incomplete git merge, stashes uncommitted changes
2. **Git update** - Fetches and checks out the branch specified by `mastodon_version_metadata`
3. **Ruby setup** - Installs required Ruby version via rbenv if missing, updates ruby-build
4. **Stop services** - Halts sidekiq services before migration (prevents deadlocks)
5. **Clean rebuild** - Removes node_modules, clears yarn cache, runs `bundle install` and `yarn install`
6. **Asset precompile** - Runs `rails assets:precompile` for production
7. **Migrations** - Runs pending DB migrations (conditional on status check)
8. **Restart services** - Restarts sidekiq, then all mastodon services
9. **Cache clear** - Clears Rails cache via tootctl

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
