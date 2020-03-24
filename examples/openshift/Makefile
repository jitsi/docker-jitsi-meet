TEMPLATE_FILES = $(shell ls -R $(PWD)/**/*.yaml)

build:
	spiff merge template.yaml $(TEMPLATE_FILES) > jitsi.yaml
