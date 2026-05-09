# history
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

# completion
autoload -Uz compinit && compinit

# options
setopt AUTO_CD

export EDITOR=nvim

alias ll='ls -alFG'
alias la='ls -AG'
alias l='ls -CFG'
alias append-file="nvim '+normal Go'"

[[ -d "$HOME/.local/bin:$PATH" ]] && export PATH="$HOME/.local/bin:$PATH"

# homebrew (use zsh-native completion instead of bash_completion)
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(starship init zsh)"

# zsh-specific modules
for f in ~/.zshrc.d/*.zshrc; do
  [[ -f "$f" ]] && source "$f"
done

# bash-compatible modules (skip git-shortcuts and homebrew, handled above)
for f in ~/.bashrc.d/*.bashrc; do
  [[ "$f" == *git-shortcuts* || "$f" == *homebrew* ]] && continue
  [[ -f "$f" ]] && source "$f"
done
