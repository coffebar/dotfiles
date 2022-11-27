export XDG_SESSION_OPT="kindle"
export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=/usr/bin/nano
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/palemoon

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

PATH="$PATH:/bin:$HOME/.node_modules/bin:$HOME/go/bin"

# remove absolute path leaks in release binary (rust)
export RUSTFLAGS="--remap-path-prefix $HOME=~"

