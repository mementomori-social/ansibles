nginx_mementomori
=================

Applies the nginx configuration changes that the mementomori.social server
administrator needs on top of the stock Ubuntu nginx install. The values were
derived by diffing a pristine nginx package configuration directory against
the live `/etc/nginx` on the old server.

The role assumes nginx is installed and deliberately leaves every byte-identical
file (`fastcgi.conf`, `fastcgi_params`, `koi-utf`, `koi-win`, `mime.types`,
`proxy_params`, `scgi_params`, `uwsgi_params`, `win-utf`, snippets, and the
`modules-enabled` symlinks) as shipped by the package. Only the actually touched
lines in `nginx.conf` are edited, and the few new files added by the admin are
installed.

Changes implemented
-------------------

`/etc/nginx/nginx.conf` (edited by a single `lineinfile` task looping over the
`nginx_mementomori_tunables` list).


New files installed:

- `/etc/nginx/conf.d/diagnostic-log.conf` — JSONL access log recording
  `$upstream_cache_status` and timings for non-cache-hit requests.
- `/etc/nginx/conf.d/static-asset-ratelimit.conf` — `staticassets` limit_req
  zone used to opt static asset locations out of the `flood` rate limit.
- `/etc/nginx/snippets/stub-status.conf` — `/stub_status` location for
  monitoring.
- `/etc/nginx/sites-available/mastodon` and `sites-available/rolle` — the
  deployed virtual hosts, copied byte-identical from the live server
  (`files/sites-available/`), with `sites-enabled` symlinks to each.

Systemd timers replacing the old server crontab (`nginx_mementomori_timers`):

- `mementomori-certbot-renew` — Let's Encrypt renew, every 12h,
  `*-*-* 00,12:00:00`

Each timer installs a `<name>.service` (oneshot) plus a `<name>.timer`.
`output: discard` reproduces the old `>/dev/null 2>&1`; `output: journal`
reproduces `2>&1`. Set `enabled: false` on any entry to skip it.

nginx-ultimate-bad-bot-blocker
------------------------------

`tasks/install-bot-blocker.yml` (run only when
`nginx_mementomori_bot_blocker_enabled`, default `true`) installs the blocker:

- the `install-ngxblocker`, `setup-ngxblocker` and `update-ngxblocker` scripts
  into `/usr/local/sbin/`
- `conf.d/globalblacklist.conf` and `conf.d/botblocker-nginx-settings.conf`
- the eight `bots.d/*.conf` rule files

It downloads the same files the upstream installer fetches and deliberately
does **not** touch the vhosts: the Mastodon and rolle sites include the
blocker from inside their `server` blocks (see `roles/nginx`), so adding the
includes here would duplicate the shared `limit_req`/`limit_conn` zones.

Let's Encrypt (Cloudflare DNS-01)
---------------------------------

`tasks/letsencrypt.yml` (run only when
`nginx_mementomori_letsencrypt_enabled`, default `true`) is invoked **before**
the nginx service is started, so the vhosts (see `roles/nginx`) always find
valid certs at `/etc/letsencrypt/live/<name>/`. Cloudflare DNS-01 is used
because, unlike webroot, it does not need a running web server.

- installs `certbot` and `python3-certbot-dns-cloudflare`
- writes the API token to `/etc/letsencrypt/cloudflare.ini` (mode `0600`)
- writes `/etc/letsencrypt/cli.ini` matching the live server
- issues the certificates in `nginx_mementomori_letsencrypt_certs` only when
  `/etc/letsencrypt/live/<name>/fullchain.pem` does not exist yet; existing
  certs are left for the `mementomori-certbot-renew` timer.

Credentials come from the vault (add them to `secrets/vault.yml`):

    vault_nginx_letsencrypt_email: admin@example.com
    vault_nginx_cloudflare_api_token: abc123

The token needs Cloudflare permission `Zone:DNS:Edit`. Set
`nginx_mementomori_letsencrypt_enabled: false` to skip entirely — do this in
tests/containers so the live production certificates are never touched. When
letsencrypt is skipped together with `skip_in_tests`, the role generates
self-signed placeholder certificates at the same `/etc/letsencrypt/live/<name>/`
paths so `nginx -t` can still validate the virtual hosts.

Virtual hosts
-------------

`/etc/nginx/sites-available/mastodon` (the main Mastodon server, including the
www and media redirect servers) and `sites-available/rolle` are deployed as
static files from `files/sites-available/`, byte-identical to the live server,
and symlinked into `sites-enabled`. The `mastodon` vhost receives the bot
blocker includes (`bots.d/ddos.conf`, `bots.d/blockbots.conf`) and the
`staticassets` rate-limit zone defined in
`conf.d/static-asset-ratelimit.conf`, both installed by this role.

Deliberately out of scope
-------------------------

- `bots.d/*`, `conf.d/botblocker-nginx-settings.conf` and
  `conf.d/globalblacklist.conf` come from nginx-ultimate-bad-bot-blocker and
  are managed by the `mementomori-update-ngxblocker` timer; this role only
  performs the initial install.
- The whitespace-only additions in `sites-available/default` are not
  functional and are not replicated.

Requirements
------------

The brotli compression modules are installed from the distribution packages
`libnginx-mod-http-brotli-filter` and `libnginx-mod-http-brotli-static`
(available on Ubuntu 24.04+ and Debian; not on Ubuntu 22.04 jammy). The
packages load the modules through `/etc/nginx/modules-enabled/`, so the role
deletes any hardcoded `load_module ...ngx_http_brotli...;` lines left over
from an older self-compiled install.

This is still from ubununtu package repo, we might need to change it to
self compiled one due Rolle has experienced bugs in canonical made ones.

Testing
-------

Use a systemd-enabled container image to exercise the timers and the nginx
service (the unprivileged Debian image in the repo's molecule scenario cannot
run systemd):

    podman run -d --name ngx-test --network pasta \
        docker.io/jomrr/molecule-ubuntu:26.04 /sbin/init

Then point an ad-hoc inventory at it with
`ansible_connection=containers.podman.podman` and run the role. The brotli
modules install from the distro packages, so `nginx -t` validates cleanly in
the container — no `-e` brotli overrides are needed. Note the 26.04 stock
config uses `server_tokens build; # comment` instead of the commented-out
`# server_tokens off;` found on 22.04 — the role handles both.

Role Variables
--------------

See `defaults/main.yml`. All tuned values can be overridden; the defaults
mirror what the server admin configured.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: nginx
      roles:
         - { role: nginx_mementomori }

License
-------

BSD

Author Information
------------------

ilkka.tengvall@iki.fi
