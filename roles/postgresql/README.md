postgresql
=========

This role is part of [mementomori](https://mementomori.social) ansible automation.
Postgresql is used as database for mastodon.

Requirements
------------

- Ubuntu 26.04 LTS
- Device /dev/sdb for database storage
- Target host must have internet access for package installation

Role Variables
--------------

### Mount and Storage

```yaml
postgresql_datadir: /database              # Mount point for database storage
postgresql_mount_device: /dev/sdb          # Device to mount
postgresql_mount_fs_type: ext4             # Filesystem type for the device
postgresql_mount_opts: defaults            # Mount options
```
postgresql_tunables: []                    # Postresql.conf settings

### PostgreSQL

```yaml
postgresql_packages:                       # Packages to install
  - postgresql
  - postgresql-contrib
  - postgresql-client
postgresql_version: "17"                   # PostgreSQL version
postgresql_service: postgresql             # Service name
postgresql_host: localhost                 # PostgreSQL host
postgresql_port: 5432                      # PostgreSQL port
```

### Disk Space Heartbeat

```yaml
postgresql_disk_space_limit_gb: 5          # Minimum GB to keep free
postgresql_betterstack_heartbeat: ""       # Better Stack heartbeat token for DB space
```

### Local Backup

```yaml
postgresql_backupdir: /mnt/backup # Mount point for local backups
postgresql_backup_betterstack_heartbeat: ""  # Better Stack heartbeat token for backups
```


Dependencies
------------

None.

Example Playbook
----------------

```yaml
- hosts: postgresql
  roles:
    - role: postgresql
      vars:
        postgresql_datadir: /database
        postgresql_mount_device: /dev/sdb
        postgresql_backup_betterstack_heartbeat:
          "{{ vault_postgresql_backup_betterstack_heartbeat }}"
        postgresql_betterstack_heartbeat:
          "{{ vault_postgresql_betterstack_heartbeat }}"
```

The role will:
1. Create the `/database` mount point directory
2. Add `/dev/sdb` to `/etc/fstab` and mount it at `/database`
3. Install PostgreSQL packages
4. Stop PostgreSQL, move default data directory to `/database`, and symlink it back
5. Start and enable PostgreSQL
6. Deploy maintenance scripts:
   - `diskspace-db.sh` - Checks disk space and sends heartbeat to Better Stack (daily)
   - `backup-db.sh` - Creates PostgreSQL directory format backup (daily)

Systemd Timers
--------------

| Timer | Schedule | Description |
|-------|----------|-------------|
| `postgresql-diskspace.timer` | Daily | Checks /database disk space and alerts if low |
| `postgresql-backup.timer` | Daily | Creates pg_dump to local backup mount |


Testing
-------

While testing in molecule, you need to skip the mount by setting

License
-------

BSD-3-Clause

Author Information
------------------

ilkka.tengvall@iki.fi
