cd ~
[ ! -d .dotfiles ] && git clone https://github.com/malikdiarra/dotfiles.git .dotfiles
[ -f .bashrc ] && mv .bashrc .bashrc.old
[ -f .profile ] && mv .profile .profile.old
cd .dotfiles
git submodule update --init
./deploy_dotfiles.sh
cd ..
source .bashrc
