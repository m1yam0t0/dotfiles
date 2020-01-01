# detect OS type and set target
CHECK_OS := false
PREPARE_TARGET :=
INSTALL_TARGET :=
OS_NAME=$(shell uname -s | tr A-Z a-z)
ifeq ($(OS_NAME), darwin)
	CHECK_OS := true
	PREPARE_TARGET += prepare-homebrew
	INSTALL_TARGET += install-homebrew set-macos-preference
endif
PREPARE_TARGET += prepare-plugin-manager
INSTALL_TARGET += install-dotfiles install-anyenv change-shell

check-os:
	@if [ $(CHECK_OS) = false ]; then\
		echo "Operating System is not supported";\
		false;\
	fi

keep-sudo:
	@if [ -z $(GITHUB_ACTION) ]; then\
		sudo -v;\
	fi

prepare: check-os keep-sudo $(PREPARE_TARGET)

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
	@-brew bundle install
	@./scripts/macOS/ricty.sh
	@./scripts/macOS/docker-completion.sh
	@echo

install-dotfiles:
	@echo '----- Install dotfiles -----'
	@./scripts/symlink.sh
	@echo

install-anyenv:
	@echo '----- Install anyenv -----'
	@./scripts/anyenv.sh
	@echo

set-macos-preference:
	@echo '----- Set preferences for macOS -----'
	@./scripts/macOS/preferences.sh
	@echo

change-shell:
	@echo '----- Change default shell -----'
	@./scripts/chsh.sh
	@echo
