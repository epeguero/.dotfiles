# Plugins.
fpath=(~/.rsrc/zsh/zsh-completions/src $fpath)
source ~/.rsrc/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.rsrc/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# Two-line prompt:
# PROMPT="%{$fg[green]%}%T %{$fg[green]%}%m %{$fg[green]%}%~
# %{$fg[green]%}▸ %{$reset_color%}"
# One-line prompt:
autoload -U colors && colors
RPROMPT="%{$fg[green]%}%D{%L:%M:%S%p} %m:%~%{$reset_color%}"
PROMPT="%(!|%{$fg[red]%}#|%{$fg[green]%}$) %{$reset_color%}"

# Backward search, like bash.
bindkey '^R' history-incremental-search-backward

# vi mode.
bindkey -v
# Like modern vim, delete stuff even when I didn't just insert it.
bindkey -M viins '^?' backward-delete-char

# Just a few emacs bindings even though I'm using vi.
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Failed wildcard matches should get passed through.
unsetopt nomatch

# Persistent command history.
export HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt inc_append_history
# Do not display in-order duplicates when searching backward in time.
# https://github.com/zsh-users/zsh-history-substring-search/issues/19
setopt hist_ignore_dups
# Currently broken:
# https://github.com/zsh-users/zsh-history-substring-search/issues/46
# setopt hist_find_no_dups
# Do *not* immediately pick up new commands from other concurrent shells,
# which can be super annoying.
unsetopt share_history
# Record the time of each command, which can be useful during forensics.
setopt extended_history

# Look on the FS every time for commands (avoid rehash).
unsetopt hash_cmds
unsetopt hash_dirs

# On Ubuntu, use command installation suggestions.
if [ -e /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

# zmv
autoload -U zmv

# Keyboard bindings for zsh-history-substring-search.
zmodload zsh/terminfo
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Initialize completion, updating only once per day.
# https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2308206
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# Nicer completion interface.
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select
setopt complete_in_word
setopt always_to_end
unsetopt list_ambiguous  # Show menu immediately when ambiguous.
# Case-insensitive partial word and substring completion.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' completer _expand _complete _approximate _ignored
# LaTeX junk files that nobody ever needs to see:
zstyle ':completion:*:*:*:*:*files' ignored-patterns \
    '*.aux' '*.bbl' '*.blg' '*.synctex.gz' '*.toc'
# Exclude Python bytecode cruft.
zstyle ':completion:*:*:*:*:*files' ignored-patterns \
    '*.pyc' '*.pyo' '__pycache__'
# Also exclude .pdf and .log files as well as revision.tex (generated by
# pdflatex-makefile) when attempting to edit text files:
zstyle ':completion:*:*:(mvim|vim|gvim):*:*files' ignored-patterns \
    '*.aux' '*.bbl' '*.blg' '*.synctex.gz' '*.toc' \
    '*.pyc' '*.pyo' '__pycache__' \
    '*.log' '*.pdf' '*.out' 'revision.tex' '*.thm' \
    '*.nav' '*.snm' '*.vrb' '*.fls' '*.xdv' '*.fdb_latexmk'
# `kill` completion.
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# Do not correct mv and cp arguments (since I often create files close to
# existing filenames).
alias mv='nocorrect mv'
alias cp='nocorrect cp'

# Color `ls` output.
if ls --color -d . &>/dev/null 2>&1 ; then
    # GNU
    alias ls='ls --color=tty'
else
    # BSD
    alias ls='ls -G'
fi

# Terminal.app cwd restore.
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    terminal_update() {
        printf '\e]7;%s\a' "file://$HOST${PWD// /%20}"
    }
    autoload add-zsh-hook
    add-zsh-hook precmd terminal_update
    terminal_update
fi

# Directory navigation.
setopt auto_pushd
setopt pushd_ignore_dups
setopt auto_cd

# Report long-running commands.
export REPORTTIME=5

# Typos.
alias sl=ls

# Disable that godforsaken bell when tab-completing.
unsetopt BEEP
setopt no_list_beep

# Auto-complete SSH hosts from ~/.config/hosts.
# https://www.zsh.org/mla/users/2015/msg00467.html
zstyle -e ':completion:*:*:ssh:*:my-accounts' users-hosts \
	'[[ -f ~/.ssh/config && $key = hosts ]] && key=my_hosts reply=()'

