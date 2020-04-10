## stable-4384(-1)

**Important security note:** Previous releases included default passwords for
system accounts, and users who didn't change them are at risk of getting
the authentication system circumvented by an attacker using a system account
with the default password. Please update and use the provided script
(instructions on the README) to generate a strong password for each system
account.

Thanks joernchen for the security report.

<hr/>

Based on stable release 4384.

* 768b6c4 security: fail to start if using the old default password
* 1ffd472 security: add script to generate strong passwords
* a015710 security: don't provide default passwords
* aaec22d jigasi: fix typo in config
* ebfa142 docs: fix grammar and typos
* bab77e0 doc: update env.example
* 7652807 examples: traefik v2
* 10983b4 prosody: prevent item-not-found error in certain cases
* 3524a52 base: fail to start the container if the init script fails
* 7c0c795 jicofo: only configure Jigasi brewery if Jigasi is configured
* 40c2920 build: add prepare command
* 93ba770 prosody: fix installing prosody from the right repository
* 3c07d76 doc: improve wording of README
* ed410d9 doc: fix typo
* fabfb2a doc: fix typo
* 5e6face web: use PUBLIC_URL for etherpaad base and BOSH URLs
* 264df04 jvb: switch to using Jitsi's STUN server by default
* 655cf6b web,prosody,jvb: prepare for new stable release
* ebb4536 doc: update CHANGELOG
* 06c3a83 doc: fix references to running behind NAT in the README

## stable-4101-2

Based on stable release 4101.

* b15bb28 prosody: update to latest stable version
* 75cb31b doc: add build instructions to README
* 25dbde9 doc: fix typo
* badc2d4 doc: add examples/README
* f6f6ca6 Merge branch 'dev'
* 52a1449 doc: clarify DOCKER_HOST_ADDRESS
* f26c9e6 prosody: fix ldap config template
* cd4a071 web: check for certbot's success and exit in case of a failure
* dea8d6c doc: fix typo
* 573c6fa doc: update diagrams
* 29125fd examples: add minimal example to run jitsi behind traefik

## stable-4101-1

Based on stable release 4101.

* b0def9a prosody: use epoll backend
* 8fa9f94 web: update nginx config from upstream
* 2f17380 doc: clarify account registration command
* edfd8f2 ldap: actually fix anonymous binds (Fixes #234)
* f4ac7cc misc: remove bogus quotation marks
* 0a68be1 jibri: start once jicofo has started
* 76acc65 doc: add tip re. ports to open on firewall to README
* e92a00c ldap: fix anonymous binds
* df40447 ldap: add option for ldap starttls support
* 1ebc535 doc: make localhost link in README clickable
* 33abdf3 doc: add mkdir -p ~/.jitsi-meet-cfg/... to README
* 2c93dce doc: fix typo in README
* d7bb2e6 doc: clarify HTTP vs HTTPS in README
* a1df1e0 Revert "prosody: fix restart loop on rolling deployment"
* 986071b jigasi: add missing transcription volumes to dockerfile
* 01eca74 jigasi: generate google cloud credentials from env vars
* cc2c042 prosody: fix restart loop on rolling deployment
* 5423a8a examples: adding simple kubernetes example
* 6eebabd jicofo: set owner jicofo rights for /config directory
* 69ba9ff jigasi: Updates jigasi client default options.
* 2b9a13b jicofo: add support of reservation REST API
* 8bfe7fb jicofo: add support of reservation REST API
* 9b17c05 web: fix letsencrypt renewal
* 6234a18 web: fix letsencrypt renewal
