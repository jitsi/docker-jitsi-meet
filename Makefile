FORCE_REBUILD ?= 0
JITSI_RELEASE ?= stable
JITSI_BUILD ?= latest
JITSI_REPO ?= jitsi
JITSI_SERVICES ?= base base-java web prosody jicofo jvb jigasi jibri

BUILD_ARGS := --build-arg JITSI_REPO=$(JITSI_REPO) --build-arg JITSI_RELEASE=$(JITSI_RELEASE)
ifeq ($(FORCE_REBUILD), 1)
  BUILD_ARGS := $(BUILD_ARGS) --no-cache
endif


all:	build-all

release: tag-all push-all

build:
	docker build $(BUILD_ARGS) --progress plain --tag $(JITSI_REPO)/$(JITSI_SERVICE) $(JITSI_SERVICE)/

$(addprefix build_,$(JITSI_SERVICES)):
	$(MAKE) --no-print-directory JITSI_SERVICE=$(patsubst build_%,%,$@) build

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
	docker pull debian:buster-slim
	FORCE_REBUILD=1 $(MAKE)

.PHONY: all build tag push clean prepare release $(addprefix build_,$(JITSI_SERVICES))
