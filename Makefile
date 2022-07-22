# detect OS type and set target
CHECK_OS := false
INSTALL_TARGET :=
UNAME=$(shell uname -s | tr A-Z a-z)
UNAME_OS=$(shell lsb_release -si)

ifeq ($(UNAME), darwin)
	CHECK_OS := true
	INSTALL_TARGET += homebrew
endif

ifeq ($(UNAME), linux)
	# Ubuntu
	ifeq ($(UNAME_OS), Ubuntu)
		CHECK_OS := true
		INSTALL_TARGET += apt
	endif
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
	@./etc/symlink.sh
	@echo

plugin-manager:
	@echo '----- Prepare plugin manager ------'
	@./etc/make-xdg-basedir.sh
	@./etc/zinit.sh
	@./etc/aqua.sh
	@./etc/vim-plug.sh
	@echo

change-shell:
	@echo '----- Change default shell -----'
	@./etc/chsh.sh
	@echo

# macOS
homebrew:
	@echo '----- Install Pakcages via Homebrew ------'
	@./etc/macos/homebrew.sh
	@brew update
	@brew bundle --file=./etc/macos/Brewfile
	@echo

homebrew-cask: keep-sudo
	@echo '----- Install Packages via Homebrew cask -----'
	@brew bundle --file=./etc/macos/Brewfile.cask
	@./etc/macos/docker-completion.sh
	@echo

homebrew-home: keep-sudo
	@echo '----- Install Packages for private machine via Homebrew -----'
	@brew bundle --file=./etc/macos/Brewfile.home
	@echo

macos-preference: keep-sudo
	@echo '----- Set preferences for macOS -----'
	@./etc/macos/preferences.sh
	@echo

# debian
apt:
	@echo '----- Install Package ------'
	@./etc/debian/apt.sh
	@echo
