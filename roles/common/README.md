Common
======

This role is part of [mementomori](https://mementomori.social) ansible automation.
Sets up common server settings: user accounts, SSH public keys, SSH hardening,
passwordless sudo, and basic packages.

Requirements
------------

Public key files `pubkeys-rolle.pub` and `pubkeys-ikke.pub` in the playbook
`files/` directory.

Role Variables
--------------

None.

Dependencies
------------

Example Playbook
----------------

    - hosts: all
      roles:
         - { role: common }

License
-------

BSD

Author Information
------------------

ilkka.tengvall@iki.fi
