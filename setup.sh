#! /bin/bash

if command -v stow 2>&1 >/dev/null
then
  echo "Deploying dotfiles"
  stow --no-folding stow
  stow --no-folding vim
  stow --no-folding nvim
  stow --no-folding bash
  stow --no-folding Xresources
  stow --no-folding git
  stow --no-folding i3
  stow --no-folding tmux
else
  echo "Stow is not available, Skipping deployment"
fi
