READNULLCMD=${PAGER:-/usr/bin/pager}

## set variables

XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"


if [[ "$TERM" != emacs ]]; then
	[[ -z "$terminfo[kdch1]" ]]        || bindkey -M emacs "$terminfo[kdch1]"       delete-char
	[[ -z "$terminfo[khome]" ]]        || bindkey -M emacs "$terminfo[khome]"       beginning-of-line
	[[ -z "$terminfo[kend]"  ]]        || bindkey -M emacs "$terminfo[kend]"        end-of-line
	[[ -z "$terminfo[kich1]" ]]        || bindkey -M emacs "$terminfo[kich1]"       overwrite-mode
	[[ -z "$terminfo[kdch1]" ]]        || bindkey -M vicmd "$terminfo[kdch1]"       vi-delete-char
	[[ -z "$terminfo[khome]" ]]        || bindkey -M vicmd "$terminfo[khome]"       vi-beginning-of-line
	[[ -z "$terminfo[kend]"  ]]        || bindkey -M vicmd "$terminfo[kend]"        vi-end-of-line
	[[ -z "$terminfo[kich1]" ]]        || bindkey -M vicmd "$terminfo[kich1]"       overwrite-mode

	[[ -z "$terminfo[cuu1]"  ]]        || bindkey -M viins "$terminfo[cuu1]"        vi-up-line-or-history
	[[ -z "$terminfo[cuf1]"  ]]        || bindkey -M viins "$terminfo[cuf1]"        vi-forward-char
	[[ -z "$terminfo[kcuu1]" ]]        || bindkey -M viins "$terminfo[kcuu1]"       vi-up-line-or-history
	[[ -z "$terminfo[kcud1]" ]]        || bindkey -M viins "$terminfo[kcud1]"       vi-down-line-or-history
	[[ -z "$terminfo[kcuf1]" ]]        || bindkey -M viins "$terminfo[kcuf1]"       vi-forward-char
	[[ -z "$terminfo[kcub1]" ]]        || bindkey -M viins "$terminfo[kcub1]"       vi-backward-char

	# ncurses stuff
	[[ "$terminfo[kcuu1]" == "O"* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" up-line-or-history
	[[ "$terminfo[kcud1]" == "O"* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" down-line-or-history
	[[ "$terminfo[kcuf1]" == "O"* ]] && bindkey -M viins "${terminfo[kcuf1]/O/[}" vi-forward-char
	[[ "$terminfo[kcub1]" == "O"* ]] && bindkey -M viins "${terminfo[kcub1]/O/[}" vi-backward-char
	[[ "$terminfo[khome]" == "O"* ]] && bindkey -M viins "${terminfo[khome]/O/[}" beginning-of-line
	[[ "$terminfo[kend]"  == "O"* ]] && bindkey -M viins "${terminfo[kend]/O/[}"  end-of-line
	[[ "$terminfo[khome]" == "O"* ]] && bindkey -M emacs "${terminfo[khome]/O/[}" beginning-of-line
	[[ "$terminfo[kend]"  == "O"* ]] && bindkey -M emacs "${terminfo[kend]/O/[}"  end-of-line
fi

case "$TERM" in
	linux)	# Linux console
		bindkey '\e[1~'   beginning-of-line      # Home 
		bindkey '\e[4~'   end-of-line            # End  
		bindkey '\e[3~'   delete-char            # Del
		bindkey '\e[2~'   overwrite-mode         # Insert  
	;;
	screen)
		bindkey '\e[1~'   beginning-of-line      # Home
		bindkey '\e[4~'   end-of-line            # End
		bindkey '\e[3~'   delete-char            # Del
		bindkey '\e[2~'   overwrite-mode         # Insert
		bindkey '\e[7~'   beginning-of-line      # Home
		bindkey '\e[8~'   end-of-line            # End
		bindkey '\eOc'    forward-word           # ctrl cursor right
		bindkey '\eOd'    backward-word          # ctrl cursor left
		bindkey '\e[3~'   backward-delete-char   # This should not be necessary!
	;;
	rxvt)
		bindkey '\e[7~'   beginning-of-line      # Home
		bindkey '\e[8~'   end-of-line            # End
		bindkey '\eOc'    forward-word           # ctrl cursor right
		bindkey '\eOd'    backward-word          # ctrl cursor left
		bindkey '\e[3~'   backward-delete-char   # This should not be necessary!
		bindkey '\e[2~'   overwrite-mode         # Insert
	;;
	xterm*)
		bindkey '\e[H'    beginning-of-line      # Home
		bindkey '\e[F'    end-of-line            # End
		bindkey '\e[3~'   delete-char            # Del
		bindkey '\e[2~'   overwrite-mode         # Insert
		bindkey "^[[5C"   forward-word           # ctrl cursor right
		bindkey "^[[5D"   backward-word          # ctrl cursor left
		bindkey "^[[1;5C" forward-word           # ctrl cursor right
		bindkey "^[[1;5D" backward-word          # ctrl cursor left
	;;
	sun)
		bindkey '\e[214z' beginning-of-line      # Home
		bindkey '\e[220z' end-of-line            # End
		bindkey '^J'      delete-char            # Del
		bindkey '^H'      backward-delete-char   # Backspace
		bindkey '\e[247z' overwrite-mode         # Insert
	;;
esac

# bindkey -e; bindkey ' ' magic-space # do i want to use this, again?

# look at http://www.michael-prokop.at/computer/config/.zsh/zsh_keybindings for a partial list of keys
bindkey '^R'    history-incremental-search-backward   # ctrl-r
bindkey '^t'    expand-or-complete-prefix
bindkey "^[[5~" history-beginning-search-backward     # PgUp for history search
bindkey '^[[6~' history-beginning-search-forward      # PgDown for history search
bindkey '^[[3~' delete-char                           # Backsapce
bindkey '^[[H'  beginning-of-line
bindkey '^[[F'  end-of-line

bindkey '^[#'   pound-insert                          # toggle a hash pound in front of the edit buffer and accept-line
bindkey '^q'    push-line                             # push command, pop automagically after next <CR>
#bindkey '^Z'    undo                                  # undo changes on zle
bindkey -s '^B' " &\n"                                # run in background
bindkey -s '^Z' "fg\n"                                # fetch background job into foreground

# insert Unicode character
autoload      insert-unicode-char
zle -N        insert-unicode-char
bindkey '^Xi' insert-unicode-char

# "ctrl-e D" to insert the actual datetime YYYY/MM
              __insert-datetime-directory() { BUFFER="$BUFFER$(date '+%Y/%m')"; CURSOR=$#BUFFER; }
zle -N        __insert-datetime-directory
bindkey '^ED' __insert-datetime-directory

# "ctrl-e d" to insert the actual datetime YYYY-MM-DD--hh-mm-ss-TZ
              __insert-datetime-default() { BUFFER="$BUFFER$(date '+%F--%H-%M-%S-%Z')"; CURSOR=$#BUFFER; }
zle -N        __insert-datetime-default
bindkey '^Ed' __insert-datetime-default

# "ctrl-e w" to delete to prior whitespace
autoload -U   delete-whole-word-match
zle -N        delete-whole-word-match
bindkey "^Ew" delete-whole-word-match

# "ctrl-e ." to insert last typed word again
              __insert-last-typed-word() { zle insert-last-word -- 0 -1 };
zle -N        __insert-last-typed-word;
bindkey "^E." __insert-last-typed-word

# "ctrl-q q" to quote line
__quote_line () {
	zle beginning-of-line
	zle forward-word
	RBUFFER=${(q)RBUFFER}
	zle end-of-line
}
zle -N        __quote_line
bindkey '^Eq' __quote_line

# "ctrl-e 1" to jump behind the first word on the cmdline
function __jump_behind_first_word() {
	local words
	words=(${(z)BUFFER})

	if (( ${#words} <= 1 )) ; then
		CURSOR=${#BUFFER}
	else
		CURSOR=${#${words[1]}}
	fi
}
zle -N        __jump_behind_first_word
bindkey '^E1' __jump_behind_first_word

# weird completion style
## press "ctrl-x f" to complete file, no matter what the completion system would do
#zle -C complete-file complete-word _generic
#zstyle ':completion:user-expand:*' completer _user_expand
#zstyle ':completion:complete-file:*' completer _path_files
#bindkey '^xf' complete-file

# grep for running process, like: 'any vim'
any() {
	if [[ -z "$1" ]] ; then
		echo "any - grep for process(es) by keyword" >&2
		echo "Usage: any <keyword>" >&2 ; return 1
	else
		local STRING=$1
		local LENGTH=$(expr length $STRING)
		local FIRSCHAR=$(echo $(expr substr $STRING 1 1))
		local REST=$(echo $(expr substr $STRING 2 $LENGTH))
		ps xauwww| grep "[$FIRSCHAR]$REST"
	fi
}


# :completion:function:completer:command:argument:tag

zstyle    ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                                  /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# this will include newly installed programs into tab completion
_force_rehash() { (( CURRENT == 1 )) && rehash return 1 }
zstyle    ':completion:*' completers _force_rehash

LISTMAX=0       # only ask if completion should be shown if it is larger than our screen
# this will not complete dotfiles in ~, unless you provide at least .<tab>
zstyle -e ':completion:*' ignored-patterns 'if [[ $PWD = ~ ]] && [[ ! $words[-1] == .* ]]; then reply=(.*); fi'
# Don't complete backup files (e.g. 'bin/foo~') as executables
zstyle    ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
# color completion
zstyle    ':completion:*' list-colors ''
# cache completions (think apt completion)
zstyle    ':completion:*' use-cache on
zstyle    ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"

# correctly color the ls completion
LS_COLORS=$(dircolors)
zstyle    ':completion:*' list-colors ${(s.:.)LS_COLORS}

# pretty kill completion. colored, cpu load & process tree
zstyle    ':completion:*:kill:*' command 'ps xf -u $USER -o pid,%cpu,cmd'
zstyle    ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# ignore aux|dvi|log|idx|pdf|rel|out if there is any other file to complete on, first
zstyle     ':completion::*:(vi|vim):*' file-patterns '*~*.(aux|dvi|log|idx|pdf|rel|out)' '*'



# SSH host completion
#if [ -r .ssh/known_hosts ]; then
#	local knownhosts
#	knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} ) 
#	zstyle    ':completion:*:(ssh|scp|sftp):*' hosts $knownhosts
#fi

# ZLE highlighting. Will not work on 4.3.6 or before, but it will not hurt, either 
zle_highlight=(isearch:underline)

autoload colors
colors

# make sure our function directories exist
foreach function_directory (~/.zsh/functions ~/.zsh/functions/hooks); do;
[[ -d $function_directory ]] || print -P "$fg_bold[red]WARNING:$fg_no_bold[default] $function_directory does not exist. Shell functionality will be severely limited!"
done;
fpath+=(~/.zsh/functions ~/.zsh/functions/hooks)
autoload -- ~/.zsh/functions/[^_]*(:t) ~/.zsh/functions/hooks/[^_]*(:t)


RPROMPT="%(?..${fg_light_gray}[$fg_red%U%?%u${fg_light_gray}]$fg_no_colour) %h %D{%T %a %e.%m.%Y}"
#PS2='%_ > '                                     # show for i in 1 2 3 \r foo > 
#RPS2="<%^"                                      # _right_ PS2 
SPROMPT="zsh: correct '%R' to '%r'? [N/y/a/e] "  # the prompt we see when being asked for substitutions


PATH+=:/usr/bin
PATH=/usr/local/bin:$PATH
[[ -d ~/.bin ]] && PATH=~/.bin:$PATH
[[ -d /usr/local/vim_extended/bin ]] && PATH=/usr/local/vim_extended/bin:$PATH

watch=(notme)
LOGCHECK=300
WATCHFMT='%n %a %l from %m at %t.'

HISTFILE=~/.zsh_history
SAVEHIST=50000
HISTSIZE=50000

EDITOR="vim"

CORRECT_IGNORE='_*'

if [[ -x $( which less) ]]
export LESSCHARSET="utf-8"
then
	export PAGER="less"
	if [ $terminfo[colors] -ge 8 ]
	then
		export LESS_TERMCAP_mb=$'\E[01;31m'
		export LESS_TERMCAP_md=$'\E[01;31m'
		export LESS_TERMCAP_me=$'\E[0m'
		export LESS_TERMCAP_se=$'\E[0m'
		export LESS_TERMCAP_so=$'\E[01;44;33m'
		export LESS_TERMCAP_ue=$'\E[0m'
		export LESS_TERMCAP_us=$'\E[01;32m'
	fi
else
	export PAGER="more"
fi

[[ -x $(which colordiff) ]] && alias diff=colordiff

([[ -x $(which w3m) ]]       && export BROWSER="w3m")      || \
([[ -x $(which links2) ]]    && export BROWSER="links2")   || \
([[ -x $(which elinks) ]]    && export BROWSER="elinks")   || \
([[ -x $(which lynx) ]]      && export BROWSER="lynx")     || \
([[ -x $(which links) ]]     && export BROWSER="links")    || \
echo "WARNING: You do not have any browser installed!"

([[ -x $(which vimdiff) ]]   && export DIFFER="vimdiff")   || \
([[ -x $(which colordiff) ]] && export DIFFER="colordiff") || \
([[ -x $(which diff) ]]      && export DIFFER="diff")      || \
echo "WARNING: You do not have any differ installed!"


# set options
setopt    append_history               # don't overwrite history
setopt    extended_history             # [unset] 
setopt    hist_find_no_dups            # [unset] ignore dupes in history search
setopt    hist_ignore_dups             # this will not put _consecutive_ duplicates in the history
setopt    hist_ignore_space            # if any command starts with a whitespace, it will not be saved. it will stil be displayed in the current session, though
setopt    hist_verify                  # [unset] when doing history substitution, put the substituted line into the line editor
# perhaps we want to change HISTCONTROL=ignoredups ?

setopt    auto_remove_slash            # [unset] If a completion ends with a slash and you type another slash, remove one of them
setopt    bg_nice                      # [set -6] Renice background jobs
#setopt cdablevars
setopt    auto_param_slash             # [set] append a slash if completion target was a directory
setopt    auto_cd                      # [unset] enables you to omit 'cd' before a path
setopt    correct_all                  # Try to autocorrect commands & file names
setopt    hash_list_all                # [set] always make sure that the entire command path is hashed
setopt    short_loops                  # [unset] 'for i in *; echo $i;' instead of 'for i in *; do echo $i; done'
#setopt globdots                # with this, we could treat dotfiles the same as normal ones

setopt    interactive_comments         # with this, we can do 'some_evil_stuff # which we explain' and just execute some_evil_stuff
setopt    list_packed                  # [unset] show compact completion list
setopt    long_list_jobs               # [unset] show job number & PID when suspending
setopt no_clobber                      # this will probihbit 'cat foo > bar' if bar exists. use >! instead
setopt    extended_glob                # enables various things, most notably ^negation. '^', '#' and forgotwhich :/ see cheatsheet & http://zsh.dotsrc.org/Intro/intro_2.html#SEC2
setopt    numeric_glob_sort            # [unset] enables numeric order in globs
setopt    notify                       # [on] this will put info from finished background processes over the current line
setopt    function_arg_zero            # [on] this will fill $0 with the function name, not 'zsh'
# POSIX_BUILTINS                # find out about this one
setopt    complete_in_word             # [unset] tab completion within words

setopt    multios                      # this enables various goodness
                                       # ls > foo > bar
                                       # cmd > >(cmd1) > >(cmd2) # would redirect stdout from cmd to stdin of cmd1,2
                                       # make install > /tmp/logfile | grep -i error
setopt    braceccl                     # {a-z} {0-2} etc expansion

autoload compinit;compinit            # this enables autocompletion for pretty much everything


# make ^W on foo | bar delete 'bar', not '| bar'
typeset WORDCHARS='|'$WORDCHARS


# quick editor commands
alias vimrc="$EDITOR ~/.vimrc"
alias zshrc="$EDITOR ~/.zshrc"
alias zshrc.staging="$EDITOR ~/.zshrc.staging"
alias zshrc.local="$EDITOR ~/.zshrc.local.$HOST"


# shortcuts
alias a='aptitude'
alias ai='aptitude install'
alias as='aptitude search'
alias ass='aptitude show'
alias au='aptitude update'
alias asu='aptitude safe-upgrade'

alias afu='apt-file update'
alias afs='apt-file search'
alias afsl='apt-file -l search'

#alias a=alias
alias ua=unalias

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lll="ll $* | less -r"
alias lh='ls -lh'
alias ld='ls -ld'
alias l='ll'

alias v='vim'

alias sr='screen -r'
alias sdr='screen -D -r'
alias scls='screen -ls'
alias scdr='screen -dr'

#edit without a trace
alias vim-noswap='vim -n -i NONE --cmd "setlocal noswapfile" --cmd "set nocompatible" --cmd "set tabstop=4" -u NONE'

alias dd_status='kill -SIGUSR1 $(pidof dd)'

# various stuff to make the commands more sane
alias mv='nocorrect mv -i'      # prompt before overwriting files
alias mkdir='nocorrect mkdir'   # don't correct mkdir
alias man='nocorrect man'
alias wget='noglob wget'        # else, i will have my home dir cluttered with dozens of foo.n
alias whois='whois -H'
alias gpg='gpg --no-use-agent'
alias grep='grep --color=auto'
alias scp='noglob scp_wrap'
alias vimdiff='vimdiff -O2'

alias why='whence -ca'

# useful to see what hogs your disk (this is so i can actually find this damn alias in here: find disk space)
alias sz='du -ax | sort -n | tail -n 10'

# various stuff from thailand
alias s='sync'
alias dt='dmesg | tail'
alias dh='df -h'
alias dm='df -m'

#ebg13 vf frpher
alias rot13='tr a-zA-Z n-za-mN-ZA-M <<<'

# base64 conversion
alias base64-encode='perl -MMIME::Base64 -e "print encode_base64(<>)" <<<'
alias base64-decode='perl -MMIME::Base64 -e "print decode_base64(<>)" <<<'

# global aliases. use with care!
alias -g C='| wc -l'
alias -g N='1>/dev/null 2>/dev/null'
alias -g E='| egrep'
alias -g G='| grep -i'
alias -g H='| head'
alias -g GV='| grep -iv'
alias -g L='| $PAGER'
alias -g T='| tail'
alias -g V='| vim -'
alias -g X='| xargs'
alias -g      ...=../..
alias -g     ....=../../..
alias -g    .....=../../../..
alias -g   ......=../../../../..
alias -g  .......=../../../../../..
alias -g ........=../../../../../../..

alias -g S='| sort'
alias -g SN='| sort -n'
alias -g SNR='| sort -nr'
alias -g SHR='| sort -Hr'

alias -g A='| awk '
alias -g A1="| awk '{print \$1}'"
alias -g A2="| awk '{print \$2}'"
alias -g A3="| awk '{print \$3}'"
alias -g A4="| awk '{print \$4}'"
alias -g A5="| awk '{print \$5}'"


# display the ten newest files
alias lsnew="ls -rl *(D.om[1,10])"
# display the ten oldest files
alias lsold="ls -rtlh *(D.om[1,10])"
# display the ten smallest files
alias lssmall="ls -Srl *(.oL[1,10])"

#ssh & scp without security checks
alias ssh-noverify='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
alias scp-noverify='scp -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'


## named directories

hash -d deb=/var/cache/apt/archives
hash -d doc=/usr/share/doc
hash -d grub=/boot/grub
hash -d log=/var/log
hash -d www=/var/www
hash -d git=$HOME/work/git
hash -d func=$HOME/.zsh/functions
hash -d mr=$XDG_CONFIG_HOME/mr
hash -d repo.d=$XDG_CONFIG_HOME/vcsh/repo.d

# move cursor between the chars when typing '', "", (), [], and {}
magic-single-quotes()   { if [[ $LBUFFER[-1] == \' ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi }; bindkey \' magic-single-quotes
magic-double-quotes()   { if [[ $LBUFFER[-1] == \" ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi }; bindkey \" magic-double-quotes
magic-parentheses()     { if [[ $LBUFFER[-1] == \( ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi }; bindkey \) magic-parentheses
magic-square-brackets() { if [[ $LBUFFER[-1] == \[ ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi }; bindkey \] magic-square-brackets
magic-curly-brackets()  { if [[ $LBUFFER[-1] == \{ ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi }; bindkey \} magic-curly-brackets
magic-angle-brackets()  { if [[ $LBUFFER[-1] == \< ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi }; bindkey \> magic-angle-brackets
zle -N magic-single-quotes
zle -N magic-double-quotes
zle -N magic-parentheses
zle -N magic-square-brackets
zle -N magic-curly-brackets
zle -N magic-angle-brackets

# escape URLs automagically
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# "ctrl-e e" : open iZLE buffer in $EDITOR
autoload      edit-command-line
zle -N        edit-command-line
bindkey '^Ee' edit-command-line

## This function allows you type a file pattern,
## and see the results of the expansion at each step.
## When you hit return, they will be inserted into the command line.
autoload -U   insert-files
zle -N        insert-files
bindkey "^Xf" insert-files ## C-x-f

# "ctrl-e r" : search backwards using globbing
autoload -U   history-pattern-search
zle -N        history-pattern-search-backward history-pattern-search
bindkey '^Xr' history-pattern-search-backward

# zmv
autoload -U zmv

## Allow known mime types to be used as 'command'
autoload -U zsh-mime-setup
zsh-mime-setup

# Show what the completion system is trying to complete with at a given point
bindkey '^Xh' _complete_help


# "ctrl-x t" : tetris
autoload -U   tetris
zle -N        tetris
bindkey "^Xt" tetris ## C-x-t to play

# My own completions

compdef _options toggleopt      # tab completion for toggleopt
compdef _mkdir   mcd            # tab completion for mcd


# "alt-h" : run run-help.
# fancy stuff like "git add" starting man git-add works
autoload run-help




startup

# source any local settings we might have
foreach dotfile (/etc/zsh/local ~/.zshrc.local ~/.zshrc.$HOST); do
	if [[ -r $dotfile ]]; then; echo "Sourcing $dotfile"; source $dotfile; fi
done
