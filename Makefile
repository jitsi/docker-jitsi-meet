FORCE_REBUILD ?= 0
JITSI_RELEASE ?= stable
JITSI_BUILD ?= unstable
JITSI_REPO ?= jitsi
NATIVE_ARCH ?= $(shell uname -m)

JITSI_MULTIARCH_SERVICES := base base-java web prosody jicofo jvb
JITSI_AMD64ONLY_SERVICES := jigasi jibri

ifeq ($(NATIVE_ARCH),x86_64)
	TARGETPLATFORM := linux/amd64
	JITSI_SERVICES := base base-java web prosody jicofo jvb jigasi jibri
else ifeq ($(NATIVE_ARCH),aarch64)
	TARGETPLATFORM := linux/arm64
	JITSI_SERVICES := base base-java web prosody jicofo jvb
else
	TARGETPLATFORM := unsupported
	JITSI_SERVICES := dummy
endif

BUILD_ARGS := \
	--build-arg JITSI_REPO=$(JITSI_REPO) \
	--build-arg JITSI_RELEASE=$(JITSI_RELEASE) \
	--build-arg TARGETPLATFORM=$(TARGETPLATFORM)

ifeq ($(FORCE_REBUILD), 1)
  BUILD_ARGS := $(BUILD_ARGS) --no-cache
endif


all: build-all

release:
	@$(foreach SERVICE, $(JITSI_MULTIARCH_SERVICES), $(MAKE) --no-print-directory JITSI_SERVICE=$(SERVICE) _buildx_multiarch;)
	@$(foreach SERVICE, $(JITSI_AMD64ONLY_SERVICES), $(MAKE) --no-print-directory JITSI_SERVICE=$(SERVICE) _buildx_amd64;)

_buildx_multiarch:
	docker buildx build \
	--platform linux/amd64,linux/arm64 \
	--progress=plain \
	$(BUILD_ARGS) --build-arg BASE_TAG=$(JITSI_BUILD) \
	--pull --push \
	--tag $(JITSI_REPO)/$(JITSI_SERVICE):$(JITSI_BUILD) \
	$(JITSI_SERVICE)

_buildx_amd64:
	docker buildx build \
	--platform linux/amd64 \
	--progress=plain \
	$(BUILD_ARGS) --build-arg BASE_TAG=$(JITSI_BUILD) \
	--pull --push \
	--tag $(JITSI_REPO)/$(JITSI_SERVICE):$(JITSI_BUILD) \
	$(JITSI_SERVICE)

ifeq ($(TARGETPLATFORM), unsupported)
build:
	@echo "Unsupported native architecture"
	@exit 1
else
build:
	@echo "Building for $(TARGETPLATFORM)"
	docker build $(BUILD_ARGS) --progress plain --tag $(JITSI_REPO)/$(JITSI_SERVICE) $(JITSI_SERVICE)/
endif

$(addprefix build_,$(JITSI_SERVICES)):
	$(MAKE) --no-print-directory JITSI_SERVICE=$(patsubst build_%,%,$@) build

tag:
	docker tag $(JITSI_REPO)/$(JITSI_SERVICE) $(JITSI_REPO)/$(JITSI_SERVICE):$(JITSI_BUILD)

push:
	docker push $(JITSI_REPO)/$(JITSI_SERVICE):$(JITSI_BUILD)

%-all:
	@$(foreach SERVICE, $(JITSI_SERVICES), $(MAKE) --no-print-directory JITSI_SERVICE=$(SERVICE) $(subst -all,;,$@))

clean:
	docker-compose stop
	docker-compose rm
	docker network prune

prepare:
	docker pull debian:bullseye-slim
	FORCE_REBUILD=1 $(MAKE)

.PHONY: all build tag push clean prepare release $(addprefix build_,$(JITSI_SERVICES))
