### 1.2.0: 2026-09-20

* Netdata role, Ref: [MEM-22](https://linear.app/mementomori-ry/issue/MEM-22)
* Site structure with per-server playbooks, Ref: [MEM-21](https://linear.app/mementomori-ry/issue/MEM-21)
* Common and wireguard playbooks moved into roles
* PostgreSQL variables moved to role defaults
* Valkey tunables, Ref: [MEM-32](https://linear.app/mementomori-ry/issue/MEM-32)
* Mastodon host builds with services disabled
* Data volume and public interface for mastodon-0, Ref: [MEM-60](https://linear.app/mementomori-ry/issue/MEM-60)
* Global vars for VM internal addresses
* UpCloud inventory uses the internal network
* SSH listen address is overridable per host
* Cloudflare DNS record update, Ref: [MEM-59](https://linear.app/mementomori-ry/issue/MEM-59)
* Yarn install no longer waits for input
* Assets precompile after checkout, Ref: [MEM-12](https://linear.app/mementomori-ry/issue/MEM-12)
* php-fpm pool for the Finnish users list, Ref: [MEM-55](https://linear.app/mementomori-ry/issue/MEM-55)
* Finnish users list cloned to its Finnish path, Ref: [MEM-55](https://linear.app/mementomori-ry/issue/MEM-55)
* Mastodon services restart when the env changes
* Molecule copes with role dependencies
* README names the Mastodon instance

### 1.1.1: 2026-09-15

* Mastodon role points at the 2026-09-15 fork branch

### 1.1.0: 2026-09-13

* Lint config and CI workflow, Ref: [MEM-50](https://linear.app/mementomori-ry/issue/MEM-50)
* Search index cron logs and stops on error, Ref: [MEM-31](https://linear.app/mementomori-ry/issue/MEM-31)
* Search index cron uses rbenv Ruby, Ref: [MEM-31](https://linear.app/mementomori-ry/issue/MEM-31)
* Mastodon role points at the live fork branch, Ref: [MEM-33](https://linear.app/mementomori-ry/issue/MEM-33)
* Build badge in README, Ref: [MEM-50](https://linear.app/mementomori-ry/issue/MEM-50)
* Search index script uses the correct live path, Ref: [MEM-12](https://linear.app/mementomori-ry/issue/MEM-12)

### 1.0.0: 2026-09-06

* Server domain in create playbooks is mementomori.social, Ref: [MEM-5](https://linear.app/mementomori-ry/issue/MEM-5)
* Elasticsearch role, Ref: [MEM-13](https://linear.app/mementomori-ry/issue/MEM-13)
* Tune task no longer rewrites keys that share a prefix, Ref: [MEM-14](https://linear.app/mementomori-ry/issue/MEM-14)
* Elastic create uses STARTER-4xCPU-16GB and blank data disks, Ref: [MEM-31](https://linear.app/mementomori-ry/issue/MEM-31)
* Roles create a filesystem on data disks before mounting, Ref: [MEM-13](https://linear.app/mementomori-ry/issue/MEM-13)
* Data disks are created separately and attached by UUID, Ref: [MEM-31](https://linear.app/mementomori-ry/issue/MEM-31)
