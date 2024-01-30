#!/bin/sh
# Warning: This will work for coffebar only!
# Run as regular user, not root!
# Before proceeding you need to restore SSH and GPG keys.
# SSH config must point to the GitHub's private key.

# Function to ask for user confirmation
confirm() {
	PROMPT="$1"
	while true; do
		echo "$PROMPT [y/n]"
		read -r response
		case $response in
			[Yy]*) return 0 ;;
			[Nn]*) return 1 ;;
			*) echo "$PROMPT [y/n]" ;;
		esac
	done
}

REPO="$HOME/dotfiles"

if [ -d "$REPO" ]; then
	echo "Dotfiles repo already exists."
	confirm "Do you want to proceed?" || exit
else
	# enable colors for pacman
	sudo sed -i 's/#Color/Color/' /etc/pacman.conf
	# install git and openssh to clone repo via git ssh
	# base-devel is for yay setup
	sudo pacman --needed --noconfirm -Sy git openssh base-devel
	# make sure that key permissions are correct
	chmod 600 ~/key/ssh/*
	# clone repo
	git clone --bare git@github.com:coffebar/dotfiles.git dotfiles || exit 1
	# configure work tree path
	git --git-dir="$REPO" --work-tree="$HOME" config --local core.worktree "$HOME"
	# checkout files into $HOME
	git --git-dir="$REPO" --work-tree="$HOME" checkout -f
	# enable GPG sign for dotfiles repo (commit signature verification)
	~/.local/bin/github-enable-gpg
	# set custom gitingore path
	git --git-dir="$REPO" --work-tree="$HOME" config --local core.excludesFile "$HOME/dotfiles.gitignore"
fi

# install yay if not installed
if ! command -v yay; then
	# install yay
	git clone https://aur.archlinux.org/yay.git
	cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
	yay -Y --gendb
fi

# select package list depending on GPU driver installed
if pacman -Qs nvidia | grep nvidia > /dev/null; then
	PKG_FILE="$HOME/pkglist-nvidia.txt"
else
	PKG_FILE="$HOME/pkglist-intel.txt"
fi

confirm "Do you want to install packages from $PKG_FILE?" || exit

# install packages
# Note: --noconfirm can't be used, because you need to resolve conflicts
# use /tmp/yay as build directory
mkdir -p /tmp/yay
# repeat command until it succeeds
until yay -S --builddir /tmp/yay --needed --cleanmenu=false --diffmenu=false --editmenu=false --removemake=false - < "$PKG_FILE"; do
	echo "Failed to install packages."
	confirm "Do you want to retry?" || exit
	yay -Syu
done

echo "Packages installed successfully."

# copy input device configs for xorg
if [ -d /etc/X11/xorg.conf.d ]; then
	sudo cp ~/00-keyboard.conf /etc/X11/xorg.conf.d/
	sudo cp ~/30-touchpad.conf /etc/X11/xorg.conf.d/
fi

# add firewall rule
sudo ufw default deny incoming
sudo ufw allow syncthing
sudo ufw enable
# enable services
sudo systemctl enable --now cronie bluetooth docker tlp ufw systemd-timesyncd.service

echo "Installing ohmyzsh..."
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/main/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/tom-doerr/zsh_codex.git ~/.oh-my-zsh/custom/plugins/zsh_codex

echo "Decrypting AI credentials..."
gpg --decrypt --output ~/.config/github-copilot/hosts.json ~/.config/github-copilot/hosts.json.gpg
gpg --decrypt --output ~/.config/openaiapirc ~/.config/openaiapirc.gpg

# copy ksnip config
cp -f ~/.config/ksnip/ksnip.example.conf ~/.config/ksnip/ksnip.conf

# setup pacman hook to update pkglist file automatically
pacman-setup-hooks

# setup keepassxc password
echo "Configuring secret-tool for KeePassXC"
echo "Please enter KeePassXC database.kdbx password:"
secret-tool store --label='KeePassXC' 'keepass' 'default'

# gtk theme options
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gtk.Settings.FileChooser startup-mode cwd
gsettings set org.gtk.gtk4.Settings.FileChooser startup-mode cwd
# gtk cursor and icon themes
gsettings set org.gnome.desktop.interface cursor-theme 'bloom'
gsettings set org.gnome.desktop.interface icon-theme 'bloom-classic'

echo "Setting up neovim..."
# add node_modules to path
export PATH="$PATH:$HOME/.local/share/pnpm:$HOME/.node_modules/bin"
sh -c "$(wget -O- https://raw.githubusercontent.com/coffebar/dotfiles/main/fetch-nvim-conf.sh)"

# install global packages via pnpm
PNPM_HOME=~/.local/share/pnpm pnpm install -g uglify-js

# setup cronjob
crontab -l | { cat; echo "*/5 * * * * .local/bin/batterynotify"; } | crontab -

# restore license for intelephense
test -f ~/dev/Scripts/intelephense-licence.sh && sh ~/dev/Scripts/intelephense-licence.sh

# set charge threshold to 80% to prolong battery life
echo "Setting charge threshold..."
sudo tlp setcharge 60 80 BAT0

# upgrade firmware
echo "Firmware upgrade..."
sudo fwupdmgr refresh
sudo fwupdmgr update

echo "Done. Consider re-login or reboot to apply all changes."
