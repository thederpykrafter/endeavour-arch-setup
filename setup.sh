#!/bin/bash

packages="alacritty picom brightnessctl zsh lazygit curl wget unzip lsd fzf fd ripgrep xdotool gpick"
for pkg in $packages
do
  if [ command -v $pkg &> /dev/null ];
  then
    sudo pacman -S --noconfirm $pkg
    echo -e "\e[92mSuccesfully Installed $pkg\e[0m"
  fi
done

if [ command -v blueman-manager ];
then
  sudo pacman -S --noconfirm blueman bluez
fi

if [ command -v autotiling &> /dev/null ];
then
  yay -S autotiling
  echo -e "\e[92mSuccesfully Installed Autotiling\e[0m"
fi

if [ command -v nvim &> /dev/null ];
then
  sudo pacman -S --noconfirm neovim
  echo -e "\e[92mSuccesfully Installed NeoVim\e[0m"
fi

if [ command -v gh &> /dev/null ];
then
  sudo pacman -S --noconfirm github-cli
  echo -e "\e[92mSuccesfully Installed GitHub CLI\e[0m"
fi

if ! gh auth status >/dev/null 2>&1
then
  git config --global user.name "thederpykrafter"
  git config --global user.email thederpykrafter@gmail.com
  git config --global init.defaultBranch main
  gh auth login
  echo -e "\e[94mSuccesfully configured git\e[0m"
fi

echo -e "\e[91m************************************\e[92m"
echo "Select Firefox profile parent folder"
echo "(ends with .default or .default-release)"
echo "Press <ENTER> to continue"
echo -e "\e[91m************************************\e[0m"
read -e
ff_profile=$(find .mozilla/firefox -type d -print -maxdepth 1 | fzf)

if [ ! -d $ff_profile/.git ]; then
	git clone git@github.com:thederpykrafter/firefox $ff_profile/ff_theme
	mv $ff_profile/ff_theme/.git $ff_profile
	mv $ff_profile/ff_theme/chrome $ff_profile
	mv $ff_profile/ff_theme/user.js $ff_profile
	mv $ff_profile/ff_theme/LICENSE $ff_profile
	mv $ff_profile/ff_theme/README.md $ff_profile
	mv $ff_profile/ff_theme/.gitignore $ff_profile
	rm -rf $ff_profile/ff_theme
	echo -e "\e[94mSuccesfully configured firefox theme\e[0m"
fi

if [ ! -d ~/.fonts ];
then
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip
	mkdir ~/.fonts
	unzip Hack.zip -d ~/.fonts/Hack
  	rm -rf github.com/
	sudo fc-cache -fv
	echo -e "\e[92mSuccesfully Installed Hack Nerd Font\e[0m"
fi

if [ ! -f .screenlayout/monitor.sh ];
then
  echo -e "\e[94mSave monitor layout as 'monitor'\e[0m"
  echo -e "\e[91mPress enter to continue...\e[0m"
  read -e
  arandr
fi

if [ ! -d /usr/share/grub/themes/stylish ]; then
  wget https://github.com/vinceliuice/grub2-themes/archive/refs/tags/2022-10-30.zip
  unzip ~/2022-10-30.zip
  rm -rf ~/2022-10-30.zip
  echo -e "\e[92mChoose Stylish theme\e[0m"
  echo -e "\[91mPress enter to continue\e[0m"
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
  echo -e "Grub wallpaper changed\e[0m"
else
  echo -e "\e[94mGrub theme already configured\e[0m" 
fi

sudo cat /etc/default/grub | grep "GRUB_DISABLE_OS_PROBER=false"
echo -e "\e[92m"
PS3="Modify Grub OSProber config?"
select option in Modify Continue
do
  case $option in
    Modify)
      sudo nano /etc/default/grub
      ;;
    *)
      break
      ;;
  esac
done
echo -e "\e[0m"

if [ ! -d ~/.oh-my-zsh ]; then
	echo -e "\e[91m** EXIT ZSH TO CONTINUE INSTALL"
	echo -e "** PRESS <ENTER> TO CONTINUE **\e[0m"
	read -e
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	rm -rf ~/.bashrc
	rm -rf ~/.bash_history
	rm -rf ~/.bash_logout
	rm -rf ~/.profile
	echo -e "\e[94mSuccesfully installed oh-my-zsh\e[0m"
else
	echo -e "\e[94moh-my-zsh already installed\e[0m"
fi

if [ ! -f ~/.oh-my-zsh/custom/shell.zsh ]; then
	echo -e "\e[94mCloning zsh config\e[0m"
	rm -rf ~/.oh-my-zsh/custom
	git clone git@github.com:thederpykrafter/zsh ~/.oh-my-zsh/custom
	echo -e "\e[94mzsh config cloned\e[0m"
else
	echo -e "\e[94mzsh config already setup\e[0m"
fi
