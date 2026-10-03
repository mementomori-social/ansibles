### 1.3.0: 2026-10-03

* Fix Elasticsearch health check and hide its password
* Tune the kernel for Mastodon hosts
* Add monit for web, nginx and Valkey
* Add FediFetcher dependencies, Ref: MEM-55
* Add log shipping to Better Stack
* Fix Mastodon services not starting when enabled
* Add IPv6 for HTTPS, Ref: MEM-66
* Fix nginx not serving assets from the Mastodon home
* Fix health checks and run them every minute
* Add database disk space alert
* Add Molecule tests to GitHub CI, Ref: MEM-51
* Add Elasticsearch disk space alert, Ref: MEM-69
* Tune PostgreSQL for speed, Ref: MEM-71
* Add faster Ruby build, Ref: MEM-70
* Add the Mastodon list page
* Change upgrade scripts to 1.6.1
* Fix missing preview card images
* Change search reindex to weekly
* Fix dead job flush timer
* Remove duplicate media cleanup timers
* Fix package installs failing on stale package lists
* Fix private network route winning over the public one
* Fix monit restarting web every few hours
* Fix preview card refetch stopping on upload timeouts

### 1.2.0: 2026-09-20

* Add Netdata monitoring on every host, Ref: MEM-22
* Change playbooks to one per server, Ref: MEM-21
* Change common and WireGuard into roles
* Change PostgreSQL settings into role defaults
* Tune Valkey for Mastodon, Ref: MEM-32
* Change Mastodon host build to not start services
* Add data volume and public interface to mastodon-0, Ref: MEM-60
* Change internal addresses into one place
* Fix reaching UpCloud hosts over the internal network
* Add per-host SSH listen address
* Add Cloudflare DNS updates, Ref: MEM-59
* Fix Yarn install waiting for input
* Fix assets not building on new hosts, Ref: MEM-12
* Add the Finnish users list, Ref: MEM-55
* Add Mastodon restart when its settings change
* Fix Molecule role dependencies
* Change README to name the Mastodon instance
* Fix search scope, Ref: MEM-31
* Add back invite-only signups and username blocking
* Fix fork compare URL

### 1.1.1: 2026-09-15

* Mastodon role points at the 2026-09-15 fork branch

### 1.1.0: 2026-09-13

* Lint config and CI workflow, Ref: MEM-50
* Search index cron logs and stops on error, Ref: MEM-31
* Search index cron uses rbenv Ruby, Ref: MEM-31
* Mastodon role points at the live fork branch, Ref: MEM-33
* Build badge in README, Ref: MEM-50
* Search index script uses the correct live path, Ref: MEM-12

### 1.0.0: 2026-09-06

* Server domain in create playbooks is mementomori.social, Ref: MEM-5
* Elasticsearch role, Ref: MEM-13
* Tune task no longer rewrites keys that share a prefix, Ref: MEM-14
* Elastic create uses STARTER-4xCPU-16GB and blank data disks, Ref: MEM-31
* Roles create a filesystem on data disks before mounting, Ref: MEM-13
* Data disks are created separately and attached by UUID, Ref: MEM-31
