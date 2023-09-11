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
	# install git and openssh to clone repo via git ssh
	# base-devel is for yay setup
	sudo pacman --needed --noconfirm -Sy git openssh base-devel
	# make sure that key permissions are correct
	chmod 600 ~/key/ssh/*
	# clone repo
	git clone --bare git@github.com:coffebar/dotfiles.git dotfiles
	# configure work tree path
	git --git-dir="$REPO" --work-tree="$HOME" config --local core.worktree "$HOME"
	# checkout files into $HOME
	git --git-dir="$REPO" --work-tree="$HOME" checkout -f
	# enable GPG sign for dotfiles repo (commit signature verification)
	~/.local/bin/github-enable-gpg
	# Copy custom git hooks to cloned repo.
	# Will sync neovim plugins in background on pull,
	# to avoid errors when missing some plugin.
	cp -f ~/hooks/* ~/dotfiles/hooks/
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
mkdir -p /tmp/yay
# repeat command until it succeeds
until yay -S --builddir /tmp/yay --needed --nocleanmenu --nodiffmenu --noeditmenu --noremovemake - < "$PKG_FILE"; do
	echo "Failed to install packages."
	confirm "Do you want to retry?" || exit
done

echo "Packages installed successfully."

# add firewall rule
sudo ufw default deny incoming
sudo ufw allow syncthing
sudo ufw enable
# enable services
sudo systemctl enable --now input-remapper docker tlp ufw bluetooth

echo "Installing ohmyzsh..."
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/tom-doerr/zsh_codex.git ~/.oh-my-zsh/custom/plugins/zsh_codex

echo "Decrypting AI credentials..."
gpg --decrypt --output ~/.config/github-copilot/hosts.json ~/.config/github-copilot/hosts.json.gpg
gpg --decrypt --output ~/.config/openaiapirc ~/.config/openaiapirc.gpg
echo "OCO_OPENAI_API_KEY=$(rg -N 'secret_key=' ~/.config/openaiapirc | sed 's/secret_key=//g')" > ~/.opencommit # opencommit from npm

# copy ksnip config
cp -f ~/.config/ksnip/ksnip.example.conf ~/.config/ksnip/ksnip.conf

# setup pacman hook to update pkglist file automatically
pacman-setup-hooks

# gtk theme options
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gtk.Settings.FileChooser startup-mode cwd
gsettings set org.gtk.gtk4.Settings.FileChooser startup-mode cwd
# gtk cursor and icon themes
gsettings set org.gnome.desktop.interface cursor-theme 'bloom'
gsettings set org.gnome.desktop.interface icon-theme 'bloom-classic'

echo "Setting up neovim..."
sh -c "$(wget -O- https://raw.githubusercontent.com/coffebar/dotfiles/master/fetch-nvim-conf.sh)"

echo "Done."
