# ~/.zshrc file for zsh interactive shells.

setopt promptsubst # enable command substitution in prompt (show git_branch_name() in prompt)

WORDCHARS=${WORDCHARS//\/} # don't consider certain characters part of the word
PROMPT_EOL_MARK="" # hide EOL sign ('%')

bindkey '^[[3~' delete-char         # delete
bindkey '^[[1;5C' forward-word      # ctrl + ->
bindkey '^[[1;5D' backward-word     # ctrl + <-
bindkey '^[[H' beginning-of-line    # home
bindkey '^[[F' end-of-line          # end

autoload -Uz compinit
compinit
zstyle ':completion:*:*:*:*:*' menu select # show selected
# zstyle ':completion:*' format 'Completing %d' # show what completing

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_ignore_dups       # ignore duplicated commands in history list
setopt share_history         # share commands of history data

TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P' # configure time format

case "$TERM" in
    xterm-color|*-256color) 
        color_prompt=yes
    ;;
esac

git_branch_name() {
    branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
    if [[ $branch != "" ]]; then
        echo '%F{green}('$branch$')%B%F{white} '
    fi
}

DEFAULT_PROMPT='%n@%m:%~ %(#.#.$) '
configure_prompt() {
    #prompt_symbol=㉿
    prompt_symbol=@
    # [ "$EUID" -eq 0 ] && prompt_symbol=💀
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            ;;
        oneline)
            PROMPT=$'%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            ;;
        backtrack)
            PROMPT=$'%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            ;;
        custom)
            PROMPT=$'%B%F{white}%B%F{%(#.red.33)}%n'$prompt_symbol$'%m%B%F{white}:%B%F{yellow}%~%B%F{white} $(git_branch_name)$ %b%F{reset}'
            # RPROMPT='$(git_branch_name)'
            ;;
        *)
            PROMPT=$DEFAULT_PROMPT
        ;;
    esac
    unset prompt_symbol
}

PROMPT_ALTERNATIVE=custom
NEWLINE_BEFORE_PROMPT=no

if [ "$color_prompt" = yes ]; then
    configure_prompt
else
    PROMPT=$DEFAULT_PROMPT
fi

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    # test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    eval "$(dircolors -b)"
    
    zstyle ':completion:*' list-colors "${LS_COLORS}"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
fi

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-shift-select/zsh-shift-select.plugin.zsh