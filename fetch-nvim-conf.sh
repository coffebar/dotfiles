#!/bin/bash
if cat /etc/os-release | grep Ubuntu ; then
	echo "Ubuntu is not supported for now. Reason: snap version has broken tree-sitter, apt version is too old for tree-sitter"
	exit -1
	sudo apt install -y git rsync npm ripgrep neovim
	sudo snap install go --classic
	git clone --depth 1 https://github.com/wbthomason/packer.nvim \
		~/.local/share/nvim/site/pack/packer/start/packer.nvim
else
	yay --version || exit -1
	echo "Using yay to install required packages"
	yay -Sy --needed neovim go npm ltex-ls-bin rust-analyzer phpactor \
		lua-language-server nvim-packer-git fd ripgrep
fi

mkdir -p ~/.config/nvim

git clone --depth=1 https://github.com/coffebar/dotfiles.git /tmp/dotfiles_tmp_nvim
rsync -rv --delete /tmp/dotfiles_tmp_nvim/.config/nvim/ ~/.config/nvim/
rm -rf /tmp/dotfiles_tmp_nvim/

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
	eslint @johnnymorganz/stylua-bin

go version && go install golang.org/x/tools/gopls@latest

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim -c 'TSInstall! css python php rust javascript sql toml typescript go yaml dockerfile scss html bash json lua c kotlin markdown diff'
