# detect OS type and set target
CHECK_OS := false
PREPARE_TARGET :=
INSTALL_TARGET :=
OS_NAME=$(shell uname -s | tr A-Z a-z)
ifeq ($(OS_NAME), darwin)
	CHECK_OS := true
	PREPARE_TARGET += prepare-homebrew
	INSTALL_TARGET += install-homebrew
endif
PREPARE_TARGET += prepare-plugin-manager
INSTALL_TARGET += install-dotfiles change-shell

check-os:
	@if [ $(CHECK_OS) = false ]; then\
		echo "Operating System is not supported";\
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
	@echo '----- Install dotfiles -----'
	@./scripts/symlink.sh
	@echo

change-shell:
	@echo '----- Change default shell -----'
	@./scripts/chsh.sh
	@echo
