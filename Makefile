build-all:
	$(MAKE) -C base build
	$(MAKE) -C base-java build
	$(MAKE) -C web build
	$(MAKE) -C prosody build
	$(MAKE) -C jicofo build
	$(MAKE) -C jvb build

.PHONY: build-all
