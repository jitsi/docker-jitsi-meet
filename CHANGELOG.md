## stable-4627-1

Based on stable release 4627-1.

* 1381b08 prosody: fix installing dependdencies
* 2900c11 misc: add extra line to tag message
* c57a84b misc: working on latest

## stable-4627

Based on stable release 4627.

* fdf5030 prosody: update configuration
* afafe23 prosody: shrink container size
* 8e7ea34 base: fix setting timezone
* 58441ae doc: update README
* 3c12526 etherpad: update to version 1.8.4
* 0038e71 jibri: install extra dependency
* 0615ed6 doc: add missing volumes to quick start
* 2781865 doc: clarify usage of gen-passwords.sh
* a8d0b6c build: add PHONY target for "release"
* d4a35a6 misc: working on latest

## stable-4548-1

Based on stable release 4548-1.

* abf2f73 jicofo: fix setting incorrect auth URL scheme for JWT
* 3472ab0 jicofo: add ability to configure health checks
* ec3622b jibri: install jitsi-upload-integrations by default
* 0e7bc91 etherpad: pin image version
* 4fa50b9 jwt: do not load token_verification module with disabled authentication
* b0d76a2 jibri: add jq dep for upload integrations
* 53b58fd jvb: add jq, curl deps for graceful_shutdown.sh
* 2d063ad doc: update installation instructions
* e73df5f misc: working on latest

## stable-4548

Based on stable release 4548.

* a79fc0c misc: add release script
* 0f0adc8 compose: add image tag to compose files
* 0177765 misc: fix config volumes to work with SELinux
* eae3f5c jibri: chrome/driver 78 as a stopgap
* 78df6a4 doc: delete unnecessary dot
* 4426ed8 jibri: fix case when /dev/snd is not bound (https://github.com/jitsi/docker-jitsi-meet/issues/240#issuecomment-610422404)
* 125775a web: fix WASM MIME type
* e70975e web: enable GZIP compression for more file types
* 774aba5 misc: set ddefault timezone to UTC
* 3c3fc19 prosody: enable speaker stats and conferene duration modules
* f911df2 jvb: set JVB_TCP_MAPPED_PORT default value
* 1205170 jvb: allow `TCP_HARVESTER_MAPPED_PORT` to be configured
* f7796a1 prosody: add volume  /prosody-plugins-custom to docker-compose
* d44230e prosody: use hashed xmpp auth

## stable-4416

Based on stable release 4416.

* b039b29 web: use certbot-auto
* b95c95d web: improve nginx configuration
* 2dd6b99 k8s: specify namespace for secret
* 7aa2d81 ldap: avoid unnecessary copy
* e1b47db exampless: update Traefik v2 example with UDP
* 0940605 doc: fix typos and minor grammar issues in README
* 1c4b11c doc: correct minor mistake
* c06867b doc: added steps for updating kernel manually in AWS installation
* dc46215 web: remove DHE suites support
* 367621f prosody: remove no longer needed patch
* 34e6601 doc: clarify acronym
* 2c95ab7 web: revert using PUBLIC_URL for BOSH URL
* 7fd7e2b Add docker-compose.override.yml to .gitignore (#438)
* 67a941b misc: update gen-passwords.sh shell code
* 4e2cec6 misc: add configurable service restart policy
* 729f9d2 doc: fix typo in env.example

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
