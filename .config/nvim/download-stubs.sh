#!/usr/bin/sh
# Download stubs for PHP LSP

mkdir -p ~/.local/share/wordpress-stubs

# Download WordPress stubs
# up to 5MB in a single file
wget -O ~/.local/share/wordpress-stubs/wordpress-stubs.php https://raw.githubusercontent.com/php-stubs/wordpress-stubs/master/wordpress-stubs.php

# Download PHPStorm stubs
# many files, up to 30MB in total
if [ ! -d ~/.local/share/phpstorm-stubs ]; then
	git clone https://github.com/JetBrains/phpstorm-stubs.git ~/.local/share/phpstorm-stubs
else
	/usr/bin/sh -c "cd ~/.local/share/phpstorm-stubs && git pull"
fi
