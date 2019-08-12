# detect OS type and set target
PREPARE_TARGET :=
INSTALL_TARGET :=
OS_NAME=$(shell uname -s | tr A-Z a-z)
ifeq ($(OS_NAME), darwin)
	PREPARE_TARGET += prepare-homebrew
	INSTALL_TARGET += install-homebrew
else
	@echo 'OS_NAME is not darwin.'
	@exit 1
endif
PREPARE_TARGET += prepare-plugin-manager
INSTALL_TARGET += install-dotfiles

.PHONY: prepare

all: prepare

prepare: $(PREPARE_TARGET)

prepare-homebrew:
	@echo '----- Prepare Homebrew ------'
	@./scripts/macOS/homebrew.sh
	@echo

prepare-plugin-manager:
	@echo '----- Prepare plugin manager ------'
	@echo 'TBD'
	@echo

install: prepare $(INSTALL_TARGET)

install-homebrew:
	@echo '----- Install Homebrew -----'
	@brew bundle install
	@./scripts/macOS/ricty.sh
	@echo

install-dotfiles:
	@echo '----- Install Dotfiles -----'
	@./scripts/symlink.sh
	@echo
