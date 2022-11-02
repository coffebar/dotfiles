#!/bin/bash
mkdir -p ~/.config/nvim

git clone --depth=1 git@github.com:coffebar/dotfiles.git /tmp/dotfiles_tmp_nvim
rsync -rv --delete /tmp/dotfiles_tmp_nvim/.config/nvim/ ~/.config/nvim/
rm -rf /tmp/dotfiles_tmp_nvim/

yay -Sy --needed neovim go npm ltex-ls-bin rust-analyzer phpactor lua-language-server nvim-packer-git
# todo: build a list of packages for ubuntu repo

npm config set prefix ~/.node_modules

function install_packages_if_needed() {
	for p in "$@"
	do
		npm list -g "$p" | grep '@' || npm install -g "$p"
	done
}

install_packages_if_needed pyright bash-language-server \
	vscode-langservers-extracted \
	typescript typescript-language-server \
	@tailwindcss/language-server \
	eslint

go version && go install golang.org/x/tools/gopls@latest

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim -c 'TSInstall! css python php rust javascript sql toml typescript go yaml dockerfile scss html bash json lua c kotlin markdown diff'
