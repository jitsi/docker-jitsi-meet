FORCE_REBUILD ?= 0
JITSI_RELEASE ?= stable
JITSI_BUILD ?= latest
JITSI_REPO ?= jitsi
JITSI_SERVICES ?= base base-java web prosody jicofo jvb jigasi etherpad jibri

BUILD_ARGS := --build-arg JITSI_REPO=$(JITSI_REPO)
ifeq ($(FORCE_REBUILD), 1)
  BUILD_ARGS := $(BUILD_ARGS) --no-cache
endif


all:	build-all

release: tag-all push-all

build:
	$(MAKE) BUILD_ARGS="$(BUILD_ARGS)" JITSI_REPO="$(JITSI_REPO)" JITSI_RELEASE="$(JITSI_RELEASE)" -C $(JITSI_SERVICE) build

tag:
	docker tag $(JITSI_REPO)/$(JITSI_SERVICE):latest $(JITSI_REPO)/$(JITSI_SERVICE):$(JITSI_BUILD)

push:
	docker push $(JITSI_REPO)/$(JITSI_SERVICE):latest
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

.PHONY: all build tag push clean prepare release
