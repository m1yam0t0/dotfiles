# detect OS type and set target
CHECK_OS := false
INSTALL_TARGET :=
OS_NAME=$(shell uname -s | tr A-Z a-z)
ifeq ($(OS_NAME), darwin)
	CHECK_OS := true
	INSTALL_TARGET += homebrew
endif
INSTALL_TARGET += dotfiles plugin-manager change-shell

prepare: check-os keep-sudo

check-os:
	@if [ $(CHECK_OS) = false ]; then\
		echo "Operating System is not supported";\
		false;\
	fi

keep-sudo:
	@if [ -z $(GITHUB_ACTION) ]; then\
		sudo -v;\
	fi

install: prepare $(INSTALL_TARGET)

dotfiles:
	@echo '----- Install dotfiles -----'
	@./etc/01_symlink.sh
	@echo

plugin-manager:
	@echo '----- Prepare plugin manager ------'
	@./etc/02_anyenv.sh
	@./etc/03_zinit.sh
	@./etc/04_vim-plug.sh
	@echo

change-shell:
	@echo '----- Change default shell -----'
	@./etc/10_chsh.sh
	@exec $(SHELL) -l
	@echo

homebrew:
	@echo '----- Install Homebrew ------'
	@./etc/macos/homebrew.sh
	@brew bundle --file=./etc/macos/Brewfile
	@echo

# option

homebrew-all: keep-sudo
	@echo '----- Install Homebrew -----'
	@brew bundle --file=./etc/macos/Brewfile.all
	@./etc/macos/ricty.sh
	@./etc/macos/docker-completion.sh
	@echo

macos-preference: keep-sudo
	@echo '----- Set preferences for macOS -----'
	@./etc/macos/preferences.sh
	@echo

