FORCE_REBUILD ?= 0
JITSI_RELEASE ?= stable
JITSI_BUILD ?= latest
JITSI_REPO ?= jitsi
JITSI_SERVICES ?= base base-java web prosody jicofo jvb jigasi etherpad jibri

BUILD_ARGS := --build-arg JITSI_REPO=$(JITSI_REPO) --build-arg JITSI_BUILD=$(JITSI_BUILD)
ifeq ($(FORCE_REBUILD), 1)
  BUILD_ARGS := $(BUILD_ARGS) --no-cache
endif


all:	build-all

release: push-all

build:
	$(MAKE) BUILD_ARGS="$(BUILD_ARGS)" JITSI_REPO="$(JITSI_REPO)" JITSI_RELEASE="$(JITSI_RELEASE)" JITSI_BUILD="$(JITSI_BUILD)" -C $(JITSI_SERVICE) build

push:
	docker push $(JITSI_REPO)/$(JITSI_SERVICE):$(JITSI_BUILD)

%-all:
	@$(foreach SERVICE, $(JITSI_SERVICES), $(MAKE) --no-print-directory JITSI_SERVICE=$(SERVICE) $(subst -all,;,$@))

clean:
	docker-compose stop
	docker-compose rm
	docker network prune

prepare:
	docker pull debian:stretch-slim
	FORCE_REBUILD=1 $(MAKE)

.PHONY: all build push clean prepare release
