# GIT heart FZF (zsh version)
# Based on https://junegunn.kr/2016/07/fzf-git

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
}

_gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

_gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

_gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

_gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

_gf_widget() { local r; r=$(_gf); zle reset-prompt; LBUFFER+="$r" }
_gb_widget() { local r; r=$(_gb); zle reset-prompt; LBUFFER+="$r" }
_gt_widget() { local r; r=$(_gt); zle reset-prompt; LBUFFER+="$r" }
_gh_widget() { local r; r=$(_gh); zle reset-prompt; LBUFFER+="$r" }
_gr_widget() { local r; r=$(_gr); zle reset-prompt; LBUFFER+="$r" }

zle -N _gf_widget
zle -N _gb_widget
zle -N _gt_widget
zle -N _gh_widget
zle -N _gr_widget

bindkey '^G^F' _gf_widget
bindkey '^G^B' _gb_widget
bindkey '^G^T' _gt_widget
bindkey '^G^H' _gh_widget
bindkey '^G^R' _gr_widget
