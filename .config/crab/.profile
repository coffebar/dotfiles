# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# remove absolute path leaks in release binary (rust)
export RUSTFLAGS="--remap-path-prefix $HOME=~"

NPM_PACKAGES="${HOME}/.npm-packages"
PATH="$HOME/.node/bin:$PATH:$NPM_PACKAGES/bin:$HOME/.node_modules/bin:$HOME/go/bin"
NODE_PATH="$HOME/.node/lib/node_modules:$NODE_PATH"
MANPATH="$HOME/.node/share/man:$NPM_PACKAGES/share/man:$MANPATH"
