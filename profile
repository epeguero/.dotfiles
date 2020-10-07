# PATH extensions
export PATH=~/.local/bin:$PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/epeguero/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/epeguero/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/epeguero/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/epeguero/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Xming variable for Windows X11 Support
# (I wanted to use python's matplotlib in WSL)
export DISPLAY=localhost:0.0

export RAN_MY_PROFILE=YEP


# aliases
alias tmux="tmux -2"
alias tmux_default="tmux new-session -A s default_session"
