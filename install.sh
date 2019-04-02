#~/usr/bin/env bash
check() {
  result=0
  for requirement in stow git make
  do
    if [ -x "$(command $requirement)" ]
    then
      echo "$command is missing"
      result=1
    fi
  done
  return result
}

pushd ~
check
install
git clone https://github.com/malikdiarra/dotfiles.git .dotfiles
pushd .dotfiles
make
popd
popd
