# detect OS type and set target
CHECK_OS := true
PREPARE_TARGET :=
INSTALL_TARGET :=
OS_NAME=$(shell uname -s | tr A-Z a-z)
ifeq ($(OS_NAME), darwin)
	PREPARE_TARGET += prepare-homebrew
	INSTALL_TARGET += install-homebrew
else
	# if your OS is not supported, abort make in 'check-os'
	CHECK_OS := false
endif
PREPARE_TARGET += prepare-plugin-manager
INSTALL_TARGET += install-dotfiles

.PHONY: prepare
check-os:
	@if [ $(CHECK_OS) = false ]; then\
		echo "This operating system is not supported";\
		false;\
	fi

prepare: check-os $(PREPARE_TARGET)

prepare-homebrew:
	@echo '----- Prepare Homebrew ------'
	@./scripts/macOS/homebrew.sh
	@echo

prepare-plugin-manager:
	@echo '----- Prepare plugin manager ------'
	@./scripts/zplugin.sh
	@echo

install: prepare $(INSTALL_TARGET)

install-homebrew:
	@echo '----- Install Homebrew -----'
	@brew bundle install
	@./scripts/macOS/ricty.sh
	@./scripts/macOS/docker-completion.sh
	@echo

install-dotfiles:
	@echo '----- Install Dotfiles -----'
	@./scripts/symlink.sh
	@echo
