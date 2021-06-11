## stable-5963

Based on stable release 5963.

* 6f6fe77 prosody: enable limits
* db3d790 prosody: fix: restrict room creation to jicofo (#1059)
* 281db36 misc: working on latest

## stable-5870

Based on stable release 5870.

* d9b84cf jibri: set base URL for joining meetings
* a77a43e jibri: update default Chrome version to 90
* a90e4ce doc: drop confusing port number from PUBLIC_URL
* 8620caa doc: clarify env variable
* 6f52f71 web: add FLoC environment variable
* 014aa59 web: add default language variable
* ce25bf6 doc: update CHANGELOG
* 6bf1336 misc: working on latest

## stable-5765-1

Based on stable release 5765.

* 7a47202 jicofo: make sure client-proxy is properly configured
* 5c32833 web: add start environment variables START_WITH_AUDIO_MUTED; START_SILENT; START_WITH_VIDEO_MUTED
* 3d93f2b misc: working on latest

## stable-5765

Based on stable release 5765.

* 9bc262a prosody: fix building unstable images
* 0cbe0d9 web: add a env variable to enable/disable deep linking
* b22421b misc: publish nightly unstable images
* 78699fe web: allow to configure shard name using env variable
* a6853ef jvb: add octo configuration options
* d6fac8e jicofo: disable octo by default
* 1fa5048 doc: add link to Kubernetes setup
* e1cebcc web,jvb: add ability to disable web sockets for colibri
* 6c4dce1 jicofo: fix ENABLE_SCTP type
* 953a4d2 jicofo: use a client proxy connection
* d27336b web: always try to renew cert on container boot
* 73acbad web: remove deprecated config option
* cb4d941 web: removed duplicate host headers
* ec570ba k8s: fix PodSecurityPolicy
* c4fc3d3 web: make a custom interface config possible
* b45b505 web: always install acme.sh when container starts
* 94ca16d etherpad: remove quotes from all env vars
* c89ccc9 jicofo: reintroduce shibboleth auth
* a6486b4 examples: update traefik v2 example
* f4ec023 misc: working on latest

## stable-5390-3

Based on stable release 5390-3.

* a698da5 misc: add jicofo reservation env variables to compose
* 86c3022 web: brandingDataUrl -> dynamicBrandingUrl
* 88e950d jicofo: fix healthcheck
* 493cbdd misc: fix typo
* e12d7f2 web : Add DESKTOP_SHARING_FRAMERATE_MIN and MAX env vars
* fa98a31 examples: fix k8s example
* 88d1034 doc: add port to PUBLIC_URL
* c876b40 doc: update CHANGELOG
* 5cf14b0 misc: working on latest

## stable-5390-2

Based on stable release 5390-2.

* 3e04fb4 prosody: fix lobby when authentication is enabled
* 24781e3 misc: working on latest

## stable-5390-1

Based on stable release 5390-1.

* 3ac5397 misc: working on latest

## stable-5390

Based on stable release 5390.

* 0f541c8 jicofo: migrate to new config
* 12823cb prosody: fix jibri recording websocket error
* 7594ea2 jigasi: add ability to control SIP default room for incoming calls
* b0e653a jigasi: fix when using authentication
* 4564170 misc: working on latest

## stable-5142-4

Based on stable release 5142-4.

* 6f7b2b4 prosody: add internal domain name to default cross-domains list
* ada7b95 jvb: fix check for JVB_TCP_HARVESTER_DISABLED
* a7fb101 jibri: don't provide a non-existing finalizer path
* d013053 jibri: add missing dependency for `kill` command
* 0b25141 web: Add ENABLE_HSTS flag to disable strict-transport-security header
* f856037 web: add more config options
* eedac14 web: add ability to disable IPv6
* af6f3ac doc: update CHANGELOG
* e3bb5c1 misc: working on latest

## stable-5142-3

**Important:** This release should fix some update problems users found in -1 and -2 versions. The main problem observed is the introduction of XMPP WebSockets, which requires extra configuration for the /xmpp-wesocket route if a reverse proxy is used in front of this setup. Pure docker-compose installations don't need any changes.

Based on stable release 5142-3.

* c2c6460 prosody: fix cross-domain WS default value
* 8261f72 jicofo,jigase: add ability to extend the config file
* 6a4887d web: use env variables to set worker processes and connections
* 5679578 prosody: add env var to config cross domain settings
* effb30b prosody: always rebuild configs on start
* 905d431 jicofo,jigasi: always rebuild configs on start
* c52b64a misc: working on latest

## stable-5142-2

Based on stable release 5142-2.

* 700c04a web: properly handle acme.sh return codes
* 4cb181c web: install acme certs to persistent storage
* 1d2c68a web: fix running acme.sh on the right home directory
* 5c44a84 misc: stop using apt-key, it's deprecated
* 5f06c3a doc: update CHANGELOG
* 0f780b4 misc: working on latest

## stable-5142-1

**Important:** This release includes 2 major changes: migrating the base image to Debian Buster and replacing certbot with acme.sh for getting Letś Encrypt certificates. Please report any problems you find!

Based on stable release 5142-1.

* b0cb4a1 web: update TLS config to Mozilla security guidelines
* 0601212 web: replace certbot with acme.sh
* 43f678d build: refactor Makefile
* b00f92a web: use Python 3 only for certbot
* 880b9b0 core: update base image to Debian Buster
* ba01190 web: prevent s6 from restarting cron if it shouldn't be run
* 42a4346 etherpad: use official image and making skin full width
* c36c4d0 web: always rebuild nginx configs on start
* aea4411 Adds private server.
* 6b69576 web: add ability to configure tokenAuthUrl
* ff6d9bc Fix websocket
* e5746ae misc: add ENABLE_PREJOIN_PAGE to .env
* 465816b web,prosody: turn on XMPP WebSocket by default
* d747bfb web,prosody: add XMPP WebSocket / Stream Management support
* 130eb55 jvb: migrate to new config file
* 5290499 doc: updated link for running behind NAT
* 7cb470c misc: support/encourage usage of ShellCheck
* 04a210f misc: working on latest

## stable-5142

Based on stable release 5142.

* 7ab45bb web: add ability to configure prejoin page
* 0c95794 jvb: regenerate config on every boot
* 3ef2221 jvb: add ability to set the WS domain with an env var
* 79d2601 jvb: add ability to specify set the WS_SERVER_ID with an env var
* b277926 jvb: make colibri websocket endpoints dynamic for multiple jvbs
* 991f695 web: remove no longer needed settings
* 8b7cbc3 revert "jicofo: no auth URL in JWT auth mode"
* 33b386b jvb: add missing variable to docker-compose
* 087f024 web: configure brandingDataUrl with env variables
* a404653 web: configure startAudioOnly using environment variable
* e195cbf jvb: make jvb apis available from outside the container
* 409cade web: configure Matomo using environment variables
* b731c60 doc: update CHANGELOG
* 0fbf3b7 misc: working on latest

## stable-5076

**Important:** Starting with this release config.js is autogenerated with every container boot.
In addition, bridge channels now using WebSocket. Some setups may break on upgrade.

Based on stable release 5076.

* 5ceaf5f web: add IPv6 support
* aff3775 xmpp: allow recorders to bypass lobby
* ad5625b jvb: switch to WebSocket based bridge channels
* 8110336 web: add ability to configure the nginx resolver
* 2f47518 jicofo: no auth URL in JWT auth mode
* c149463 web: build config.js on each boot
* c792bbc base: update frep
* bec928c prosody: configure lobby on the guest domain is necessary
* bcbd977 jicofo: pass XMPP_MUC_DOMAIN through docker-compose.yml
* 8f9caa4 jicofo: set XMPP_MUC_COMPONENT_PREFIX
* 2a0120d web: set security headers also for non HTTPS
* e6586f2 jvb: set LOCAL_ADDRESS to the correct local IP (#630)
* 97f5e75 base: optimize size
* b78c89e misc: minor Dockerfile Improvements
* a754519 misc: working on latest

## stable-4857

Based on stable release 4857.

* a81ad73 prosody: add support for lobby
* baed605 web: fix removing closed captions button if transcription is enabled
* edecacd etherpad: add ability to use a external server
* a7563d4 jvb: use JVB_TCP_PORT for exposing the port
* b235ea1 prosody: disable s2s module
* 1d428a8 prosody: use a 2-stage build
* 613c26c misc: working on latest
* 4d72ee3 release: stable-4627-1
* 22b7063 examples: update Traefik v1 example
* 1381b08 prosody: fix installing dependdencies
* 2900c11 misc: add extra line to tag message
* c57a84b misc: working on latest

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
