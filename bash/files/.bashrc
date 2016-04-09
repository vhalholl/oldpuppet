# ~/.bashrc: executed by bash(0) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return 0;

export PATH=/sbin:/usr/sbin:$PATH 

# Retourne les valeur de retours si non nul
#export PROMPT_COMMAND='( x=$? ; let x!=0 && echo "return : $x" )'

[ -x /usr/bin/vim ] && export EDITOR=vim
[ -x /usr/bin/most ] && export PAGER=most

CYAN=$(echo -e '\e[0;36m')
NORMAL=$(echo -e '\e[0m')

## Gestion de l'historique
export HISTCONTROL=ignoreboth #ignoredups:ignorespace
export HISTTIMEFORMAT="${CYAN}[ %d/%m/%Y %H:%M:%S ]${NORMAL} "

export HISTFILESIZE=5000 
export HISTSIZE=5000

# Dont overwrite history
shopt -s histappend

# Safe History
# Save each command right after it has been executed, not at the end of the session.
# history -a will append your current session history to the content of the history file.
# history -w will replace the content of the history file with your current session history.
#export PROMPT_COMMAND="history -a; history -n"

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# cd $myVar
shopt -s cdable_vars;

# Correction sur les noms des répertoires avec cd
shopt -s cdspell; 

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support of ls
if [ "$TERM" != "dumb" ]; then
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias dir='dir --color=auto'
        alias vdir='vdir --color=auto'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi
fi

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot);
fi

# Set prompt color 
if [ "`id -u`" -eq 0 ];then prompt_color='\[\033[01;31m\]';else prompt_color='\[\033[01;32m\]';fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]'$prompt_color'\u\[\033[00;32m\]@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#	xterm-color)
#	    PS1='${debian_chroot:+($debian_chroot)}\[\033[00;32m\]\$|'$prompt_color'\u\[\033[00;32m\]@\[\033[01;32m\]\h\[\033[00;32m\]:\[\033[01;32m\]\t\[\033[00;32m\]>>\[\033[00m\] ';
#	;;
#	*)
#	    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ ';
#	;;
#esac
#
## Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[00;32m\]\$|'$prompt_color'\u\[\033[00;32m\]@\[\033[01;32m\]\h\[\033[00;32m\]:\[\033[01;32m\]\t\[\033[00;32m\]>>\[\033[00m\] ';
#
## If this is an xterm set the title to user@host:dir
#case "$TERM" in
#	xterm*|rxvt*)
#		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
#	;;
#	*)
#		#Do nothing;
#	;;
#esac

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases;
fi

# Function definitions.
if [ -f ~/.bash_functions ]; then
	. ~/.bash_functions;
fi

# Enable programmable completion features 
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion;
fi

# Get scripts in PATH
if [ -d ~/scripts ] ; then
    PATH=~/scripts:"${PATH}"
fi

# Todolist in current dir ?
[[ -x /usr/bin/tdl && -s .tdldb ]] && { echo -e "TodoList: (see man tdl)"; tdl list; }
