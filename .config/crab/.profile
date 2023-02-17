# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d "$HOME/go/bin" ] ; then
    PATH="$HOME/go/bin:$PATH"
fi
if [ -d "$HOME/.node_modules/bin" ] ; then
    PATH="$HOME/.node_modules/bin:$PATH"
fi

# remove absolute path leaks in release binary (rust)
export RUSTFLAGS="--remap-path-prefix $HOME=~"

