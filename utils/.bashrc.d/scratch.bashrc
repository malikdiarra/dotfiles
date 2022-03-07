#!/usr/bin/env bash
SCRATCH_BASE_PATH="$HOME/.scratch/"
scratch() {
  filename=$(echo "$@" | tr " " "-")
  vim "${SCRATCH_BASE_PATH}${filename}"
}

scratch-list() {
  ls -1 --color=never SCRATCH_BASE_PATH
}

see-scratch() {
  cat $(scratch-list | fzf)
}
