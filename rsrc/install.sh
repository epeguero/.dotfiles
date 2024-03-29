#!/usr/bin/env bash
dotfiles=$HOME/.dotfiles
for fn in $( ls $dotfiles ) ; do
    if [ "${fn:0:1}" != "." ] && [ "${fn##*.}" != "orig" ] ; then
        src=$dotfiles/$fn
        dest=$HOME/.`echo "$fn" | sed 's/__/\//g'`

        # continue if symbolic link already exists
        # #NOTE: if link is broken, it must be removed and this script rerun
        [ -L $dest ] && continue

        if [ -e $dest ] ; then
        echo moving aside $dest
        mv $dest $dest.off
        fi

        echo linking $dest
        mkdir -p `dirname $dest`
        ln -s $src $dest
    fi
done

# Poor man's subrepos.
mkdir -p ~/.rsrc/zsh
cd ~/.rsrc/zsh
[ -d zsh-history-substring-search ] || git clone https://github.com/zsh-users/zsh-history-substring-search.git
[ -d zsh-syntax-highlighting ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
[ -d zsh-completions ] || git clone https://github.com/zsh-users/zsh-completions.git
cd ../..

echo 'remember:'
echo 'chsh -s $(which zsh)'
echo '$ pip3 install flake8'
echo '$ vim +PlugInstall +qall'
