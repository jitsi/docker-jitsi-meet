FORCE_REBUILD ?= 0
JITSI_RELEASE ?= "stable"

ifeq ($(FORCE_REBUILD), 1)
  BUILD_ARGS = "--no-cache"
endif

build-all:
	BUILD_ARGS=$(BUILD_ARGS) JITSI_RELEASE=$(JITSI_RELEASE) $(MAKE) -C base build
	BUILD_ARGS=$(BUILD_ARGS) $(MAKE) -C base-java build
	BUILD_ARGS=$(BUILD_ARGS) $(MAKE) -C web build
	BUILD_ARGS=$(BUILD_ARGS) $(MAKE) -C prosody build
	BUILD_ARGS=$(BUILD_ARGS) $(MAKE) -C jicofo build
	BUILD_ARGS=$(BUILD_ARGS) $(MAKE) -C jvb build
	BUILD_ARGS=$(BUILD_ARGS) $(MAKE) -C jigasi build

push-all:
	docker push jitsi/base
	docker push jitsi/base-java
	docker push jitsi/web
	docker push jitsi/prosody
	docker push jitsi/jicofo
	docker push jitsi/jvb
	docker push jitsi/jigasi

clean:
	docker-compose stop
	docker-compose rm
	docker network prune

.PHONY: build-all push-all clean
