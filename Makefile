# detect OS type and set target
CHECK_OS := false
INSTALL_TARGET :=
UNAME=$(shell uname -s | tr A-Z a-z)
DIST_ID=$(shell lsb_release -si)

# MacOS
ifeq ($(UNAME), darwin)
	CHECK_OS := true
	INSTALL_TARGET += macos
endif

# Linux
ifeq ($(UNAME), linux)
	# Ubuntu
	ifeq ($(DIST_ID), Ubuntu)
		CHECK_OS := true
		INSTALL_TARGET += debian
	endif
	# EndeavourOS
	ifeq ($(DIST_ID), EndeavourOS)
		CHECK_OS := true
		INSTALL_TARGET += arch
	endif
endif

install: prepare $(INSTALL_TARGET) setup
prepare: check-os keep-sudo
setup: dotfiles setup-tools change-shell

check-os:
	@if [ $(CHECK_OS) = false ]; then\
		echo "Operating System is not supported";\
		false;\
	fi

keep-sudo:
	@if [ -z $(GITHUB_ACTION) ]; then\
		sudo -v;\
	fi

dotfiles:
	@echo '----- Install dotfiles -----'
	@./etc/symlink.sh
	@./etc/make-xdg-basedir.sh
	@echo

setup-tools:
	@echo '----- Setup Tools ------'
	@./etc/zinit.sh
	@./etc/aqua.sh
	@./etc/vim-plug.sh
	@echo

change-shell: keep-sudo
	@echo '----- Change default shell -----'
	@./etc/chsh.sh
	@echo

# macOS
macos: keep-sudo install-homebrew brew

install-homebrew:
	@echo '----- Install Homebrew ------'
	@./etc/macos/homebrew.sh
	@brew update
	@echo

brew:
	@echo '----- Install Pakcages via Homebrew ------'
	@brew bundle --file=./etc/macos/Brewfile
	@echo

brew-cask: keep-sudo
	@echo '----- Install Packages via Homebrew cask -----'
	@brew bundle --file=./etc/macos/Brewfile.cask
	@echo

brew-private: keep-sudo
	@echo '----- Install Packages for private machine via Homebrew -----'
	@brew bundle --file=./etc/macos/Brewfile.private
	@echo

macos-preferences: keep-sudo
	@echo '----- Set preferences for macOS -----'
	@./etc/macos/preferences.sh
	@./etc/macos/docker-completion.sh
	@./etc/macos/install-font-for-powerlevel10k.sh
	@echo

# debian
debian: apt debian-preferences

apt: keep-sudo
	@echo '----- Install Packages via apt ------'
	@./etc/debian/apt.sh
	@echo

debian-preferences: keep-sudo
	@echo '----- Set preferences for Debian -----'
	@./etc/debian/locale.sh
	@echo

# arch
arch: pacman yay

pacman: keep-sudo
	@echo '----- Install Package via pacman ------'
	@./etc/arch/pacman.sh
	@echo

yay: keep-sudo
	@echo '----- Install Package via yay ------'
	@./etc/arch/yay.sh
	@echo