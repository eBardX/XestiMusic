PREFIX?=/usr/local

MDUMP_BUILD_DIR?=.build/release
MDUMP_INSTALL_DIR?=$(PREFIX)/bin

.PHONY: all build clean install lint reset test uninstall update

all: clean update build install

build:
	@ swift build -c release

clean:
	@ swift package clean

install: build
	@ install -d $(MDUMP_INSTALL_DIR)
	@ install -Cv $(MDUMP_BUILD_DIR)/mdump $(MDUMP_INSTALL_DIR)/mdump

lint:
	@ swiftlint lint --fix
	@ swiftlint lint

reset:
	@ swift package reset

test:
	@ swift test # --enable-code-coverage --show-code-coverage-path

uninstall:
	@ rm -fv $(MDUMP_INSTALL_DIR)/$(MDUMP_INSTALL_NAME)

update:
	@ swift package update
