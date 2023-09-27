#!/bin/bash
if grep Ubuntu /etc/os-release; then
	echo "Ubuntu is not supported for now." # maybe someday
	exit 1
else
	pacman --version || exit 1
	# packages from arch repo
	PKG=(autopep8 ansible-lint neovim go npm rust-analyzer lua-language-server fd ripgrep xclip rsync python-virtualenv wget)
	# chech all packages if installed
	# to avoid asking for sudo if nothing will be installed
	TO_INSTALL=()
	for pn in "${PKG[@]}"; do
		pacman -Q | grep "$pn " || TO_INSTALL+=("$pn")
	done
	# install all at once
	[ "${#TO_INSTALL[@]}" -eq 0 ] || sudo pacman -Sy --noconfirm --needed "${TO_INSTALL[@]}"
fi

mkdir -p ~/.config/nvim
mkdir -p ~/.node_modules/lib/node_modules

git clone --depth=1 https://github.com/coffebar/dotfiles.git /tmp/dotfiles_tmp_nvim
rsync -rv --delete /tmp/dotfiles_tmp_nvim/.config/nvim/ ~/.config/nvim/
rm -rf /tmp/dotfiles_tmp_nvim/

npm config set prefix ~/.node_modules
# install pnpm for better performance and disk space usage
npm install -g pnpm

# set pnpm home env variable
export PNPM_HOME=~/.local/share/pnpm

# if pnpm is not in PATH, add it
if ! command -v pnpm > /dev/null; then
	export PATH="$PATH:$HOME/.local/share/pnpm:$HOME/.node_modules/bin"
fi

_INSTALLED=$(pnpm list -g)
function install_nodejs_packages_if_needed() {
	# install packages if not installed
	for p in "$@"; do
		echo "$_INSTALLED" | grep -F "$p " > /dev/null || pnpm install -g "$p"
	done
}

install_nodejs_packages_if_needed pyright bash-language-server \
	@ansible/ansible-language-server \
	vscode-langservers-extracted \
	prettier prettier-plugin-ssh-config \
	prettier-plugin-sh \
	prettier-plugin-nginx @prettier/plugin-php \
	typescript typescript-language-server \
	stylefmt intelephense \
	tree-sitter-cli \
	eslint @johnnymorganz/stylua-bin \
	@shufo/prettier-plugin-blade \
	emmet-ls

go install golang.org/x/tools/gopls@latest

# download stubs for LSP, currently only for PHP
source ~/.config/nvim/download-stubs.sh

nvim --headless "+Lazy! sync" +qa > /dev/null 2>&1
