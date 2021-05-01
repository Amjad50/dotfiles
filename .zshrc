# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

# auto completion
fpath+=~/.zfunc

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'


zinit light romkatv/powerlevel10k
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zpm-zsh/colorize
zinit light zsh-users/zsh-history-substring-search

export VISUAL=nvim
export EDITOR=nvim

setopt autocd
setopt inc_append_history
setopt share_history


export SAVEHIST=10000
export HISTSIZE=10000
export HISTFILE=~/.zsh_history

ZSH_AUTOSUGGEST_STRATEGY=(history completion )
ZSH_AUTOSUGGEST_USE_ASYNC=1

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^[[3~" delete-char

# for easily activating python venv
activate_venv() {
	source ./venv/bin/activate
}

alias lc='colorls'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Created by `userpath` on 2020-03-22 07:27:33
export PATH="$PATH:$HOME/.local/bin"
# export PATH="$PATH:$HOME/.gem/ruby/2.7.0/bin"
export PATH="$PATH:$HOME/.gem/ruby/3.0.0/bin"

# rust
source $HOME/.cargo/env

# go
export PATH="$PATH:$(go env GOPATH)/bin"

# fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# rga-zfz (https://github.com/phiresky/ripgrep-all)
rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

PATH="/home/amjad/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/amjad/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/amjad/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/amjad/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/amjad/perl5"; export PERL_MM_OPT;

export PATH="$PATH:$HOME/AndroidSdk/tools/bin/"
export ANDROID_SDK_ROOT="$HOME/AndroidSdk/"
export PATH="$PATH:$HOME/Development/Flutter/FlutterSDK/flutter/bin/"

# TODO: edit location of the statement for better organization
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
