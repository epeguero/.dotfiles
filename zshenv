# From https://wiki.archlinux.org/index.php/Zsh :
# "If option GLOBAL_RCS is unser in any of the files, no global configurations files (/etc/zsh/*) wll be read after that file."
unsetopt GLOBAL_RCS

# Run .profile
source $HOME/.profile
