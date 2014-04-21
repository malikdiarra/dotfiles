#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function deploy_file()
{
  ln -s $DIR/$1 ~/.$1
}

for i in vimrc vim gitignore gitconfig githelpers bashrc profile
do
  deploy_file $i
done
