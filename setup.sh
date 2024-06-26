#!/bin/bash

if pacman -Qu > /dev/null; then
  sudo pacman -Syy
  sudo pacman -Syu --noconfirm
fi

packages="alacritty picom brightnessctl zsh lazygit curl wget unzip lsd neofetch fzf fd ripgrep xdotool gpick htop grub-customizer xss-lock rust go zig ocaml obsidian obs-studio"
for pkg in $packages
do
  if pacman -Qs $pkg > /dev/null;
  then
    echo -n ""
  else
    sudo pacman -S --noconfirm $pkg
    echo -e "\e[92mSuccesfully Installed $pkg\e[m"
  fi
done

if [ command -v nvm &> /dev/null ];
then
  yay -S --noconfirm nvm
  [ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
  source /usr/share/nvm/nvm.sh
  source /usr/share/nvm/bash_completion
  source /usr/share/nvm/install-nvm-exec
  echo -e "\e[92mSuccesfully Installed nvm\e[m"
fi

if [ command -v node &> /dev/null ];
then
  nvm install node
  nvm use node
  echo -e "\e[92mSuccesfully Installed Node\e[m"
fi

# check for neovim package from npm
npm list -g | grep neovim > /dev/null || npm i -g neovim

if [ command -v blueman-manager &> /dev/null ];
then
  sudo pacman -S --noconfirm blueman bluez
fi

if [ command -v autotiling &> /dev/null ];
then
  yay -S --noconirm autotiling
  echo -e "\e[92mSuccesfully Installed Autotiling\e[m"
fi

if [ command -v nvim &> /dev/null ];
then
  sudo pacman -S --noconfirm neovim
  echo -e "\e[92mSuccesfully Installed NeoVim\e[m"
fi

if [ command -v gh &> /dev/null ];
then
  sudo pacman -S --noconfirm github-cli
  echo -e "\e[92mSuccesfully Installed GitHub CLI\e[m"
fi

if [ ! gh auth status >/dev/null 2>&1 ];
then
  git config --global user.name "thederpykrafter"
  git config --global user.email thederpykrafter@gmail.com
  git config --global init.defaultBranch main
  gh auth login
  echo -e "\e[94mSuccesfully configured Git & GitHub\e[m"
fi

if [ command -v github-desktop &> /dev/null ];
then
  yay -S github-desktop-bin --noconfirm
  echo -e "\e[94mSuccesfully installled GitHub Desktop\e[m"
fi

ff_profile=$(find ~/.mozilla/firefox -maxdepth 1 -type d -print | grep -m1 default)

if [ ! -d $ff_profile/.git ]; then
	git clone git@github.com:thederpykrafter/firefox $ff_profile/ff_theme
	mv $ff_profile/ff_theme/.git $ff_profile
	mv $ff_profile/ff_theme/chrome $ff_profile
	mv $ff_profile/ff_theme/user.js $ff_profile
	mv $ff_profile/ff_theme/LICENSE $ff_profile
	mv $ff_profile/ff_theme/README.md $ff_profile
	mv $ff_profile/ff_theme/.gitignore $ff_profile
	rm -rf $ff_profile/ff_theme
	echo -e "\e[94mSuccesfully configured firefox theme\e[m"
fi

if [ ! -d ~/.fonts ];
then
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip
	mkdir ~/.fonts
	unzip Hack.zip -d ~/.fonts/Hack
  	rm -rf github.com/
	sudo fc-cache -fv
	echo -e "\e[92mSuccesfully Installed Hack Nerd Font\e[m"
fi

if [ ! -f ~/.screenlayout/monitor.sh ];
then
  echo -e "\e[94mSave monitor layout as 'monitor'\e[m"
  echo -e "\e[91mPress enter to continue...\e[m"
  read -e
  arandr
  sudo chmod a+x ~/.screenlayout/monitor.sh
fi

if [ ! -d /usr/share/grub/themes/stylish ]; then
  wget https://github.com/vinceliuice/grub2-themes/archive/refs/tags/2022-10-30.zip
  unzip ~/2022-10-30.zip
  rm -rf ~/2022-10-30.zip
  echo -e "\e[92mChoose Stylish theme\e[m"
  echo -e "\[91mPress enter to continue\e[m"
  read -e
  ~/grub2-themes-2022-10-30/install.sh
  wget https://4kwallpapers.com/images/wallpapers/outrun-neon-dark-background-purple-3840x2160-4523.jpg
  mv outrun-neon-dark-background-purple-3840x2160-4523.jpg background.jpg
  mogrify -resize 1920x1080 background.jpg
  sudo mv /usr/share/grub/themes/stylish/background.jpg /usr/share/grub/themes/stylish/background.jpg.bak
  sudo cp ~/background.jpg /usr/share/grub/themes/stylish/
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  rm -rf ~/background.jpg
  rm -rf ~/grub2-themes-2022-10-30/
  echo -e "\e[94mGrub theme installed" 
  echo -e "Grub wallpaper changed\e[m"

  sudo cat /etc/default/grub | grep "GRUB_DISABLE_OS_PROBER=false"
  echo -e "\e[92m"
  PS3="Modify Grub OSProber config?"
  select option in Boot-Entries OS-Prober Continue
  do
    case $option in
      Os-Prober)
        sudo nano /etc/default/grub
        ;;
      Boot-Entries)
        sudo grub-customizer
        ;;
      *)
        break
        ;;
    esac
  done
  echo -e "\e[m"
fi

if [ ! -d ~/.oh-my-zsh ]; then
	echo -e "\e[91m** EXIT ZSH TO CONTINUE INSTALL"
	echo -e "** PRESS <ENTER> TO CONTINUE **\e[m"
	read -e
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	rm -rf ~/.bashrc
	rm -rf ~/.bash_history
	rm -rf ~/.bash_logout
	rm -rf ~/.profile
	echo -e "\e[94mSuccesfully installed oh-my-zsh\e[m"
fi

if [ ! -f ~/.oh-my-zsh/custom/shell.zsh ]; then
	echo -e "\e[94mCloning zsh config\e[m"
	rm -rf ~/.oh-my-zsh/custom
	git clone git@github.com:thederpykrafter/zsh ~/.oh-my-zsh/custom
	echo -e "\e[94mzsh config cloned\e[m"
fi

if pacman -Qu > /dev/null; then
  sudo pacman -Syy
  sudo pacman -Syu --noconfirm
fi

configs="alacritty nvim termux-nvim picom neofetch"

for cfg in $configs
do
  if [ ! -d ~/.config/$cfg/.git ];
  then
    rm -rf ~/.config/$cfg
    git clone git@github.com:thederpykrafter/$cfg ~/.config/$cfg
    echo -e "\e[94m$cfg config cloned\e[m"
  fi
done

if [ ! -f ~/.config/i3/i3-lock-screen.png ];
then
  echo -e "\e[94mCloning i3 config\[m"
  rm -rf ~/.conig/i3
  git clone git@github.com:thederpykrafter/endeavour-i3 ~/.config/i3
  echo -e "\e[92mi3 config cloned\[m"
fi

if [ ! -d ~/Dev ];
then
  echo -e "\e[94mCreating Dev directories\e[m"
  mkdir ~/Dev
  dev_folders="go rust ocaml zig js sh"
  for folder in $dev_folders
  do
    mkdir ~/Dev/$folder
  done

  echo -e "\e[92mCloning Dev projects\e[m"
  git clone git@github.com:thederpykrafter/thederpykrafter ~/Dev/thederpykrafter-GH
  git clone git@github.com:thederpykrafter/tdk-portfolio ~/Dev/js/tdk-portfolio
  git clone git@github.com:thederpykrafter/termux-scripts ~/Dev/sh/termux-scripts
  git clone git@github.com:thederpykrafter/hello_ocaml ~/Dev/ocaml/hello_ocaml
  git clone git@github.com:thederpykrafter/learning-go ~/Dev/go/learning-go
  git clone git@github.com:thederpykrafter/endeavour-arch-setup ~/Dev/sh/setup
  echo -e "\e[92mDev projects cloned\e[m"
fi

if [ ! -f ~/Documents/Notes/.obsidian.vimrc ];
then
  if [ ! -d ~/Documents/Notes ];
  then
    echo -e "\e[94mCreating Notes directory\e[m"
    mkdir ~/Documents/Notes
  fi
  git clone git@github.com:thederpykrafter/Obsidian ~/Documents/Notes/_config
  ln -sf ~/Documents/Notes/_config/.obsidian.vimrc ~/Documents/Notes/.obsidian.vimrc
  echo -e "\e[92mNotes directory created\e[m"
fi

echo -e "\e[92mAll setup complete!\e[m"
