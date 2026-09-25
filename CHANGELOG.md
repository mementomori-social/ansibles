### 1.2.0: 2026-09-20

* Monitor every host with Netdata, Ref: MEM-22
* Split playbooks per server, Ref: MEM-21
* Move common and wireguard into roles
* Move PostgreSQL variables into role defaults
* Tune Valkey for Mastodon, Ref: MEM-32
* Build the Mastodon host without starting services
* Give mastodon-0 a data volume and public interface, Ref: MEM-60
* Name VM internal addresses in one place
* Reach UpCloud hosts over the internal network
* Allow a per-host SSH listen address
* Update Cloudflare DNS from Ansible, Ref: MEM-59
* Stop Yarn install waiting for input
* Build assets after checkout, Ref: MEM-12
* Serve the Finnish users list through php-fpm, Ref: MEM-55
* Clone the Finnish users list to its Finnish path, Ref: MEM-55
* Restart Mastodon when the env file changes
* Let Molecule handle role dependencies
* Name the Mastodon instance in the README
* Fix status search scope back to classic, Ref: MEM-31
* Fix precompile never running on built hosts, Ref: MEM-12
* Add back invite-only signups and username blocking
* Fix stray quotes in the fork compare URL
* Install and schedule the Finnish users list, Ref: MEM-55
* Fix Elasticsearch check never detecting failure
* Keep the Elasticsearch password out of world-readable scripts
* Tune the kernel for Mastodon on new hosts
* Watch web, nginx and valkey with monit
* Install FediFetcher dependencies, Ref: MEM-55
* Ship journald to Better Stack with vector
* Start Mastodon services when the role is enabled
* Listen on IPv6 for HTTPS, Ref: MEM-66
* Use the http2 directive, not the listen parameter
* Pick the global IPv6 address for AAAA, Ref: MEM-66
* Let nginx serve assets from the mastodon home
* Run health checks every minute
* Fix sidekiq check working directory
* Check database disk space every minute
* Alert when database disk has under 20 GB free

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
