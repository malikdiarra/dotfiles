#! /bin/bash
if [ -f ~/.vimrc ]; then
  rm ~/.vimrc
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -s $DIR/vimrc ~/.vimrc
