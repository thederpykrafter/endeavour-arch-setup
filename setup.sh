#!/bin/bash

sudo pacman -Syy
sudo pacman -Syu

packages="alacritty picom brightnessctl zsh lazygit curl wget unzip lsd neofetch fzf fd ripgrep xdotool gpick htop grub-customizer xss-lock rust go zig ocaml obsidian obs-studio"
for pkg in $packages
do
  if pacman -Qs $pkg > /dev/null;
  then
    echo -n ""
  else
    sudo pacman -S --noconfirm $pkg
  fi
done

if [ command -v nvm &> /dev/null ];
then
  yay -S --noconfirm nvm
  [ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
  source /usr/share/nvm/nvm.sh
  source /usr/share/nvm/bash_completion
  source /usr/share/nvm/install-nvm-exec
  echo -e "\e[92mSuccesfully Installed nvm\e[0m"
fi

if [ command -v node &> /dev/null ];
then
  nvm install node
  nvm use node
  echo -e "\e[92mSuccesfully Installed Node\e[0m"
fi

# check for neovim package from npm
npm list -g | grep neovim || npm i -g neovim

if [ command -v blueman-manager &> /dev/null ];
then
  sudo pacman -S --noconfirm blueman bluez
fi

if [ command -v autotiling &> /dev/null ];
then
  yay -S --noconirm autotiling
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

if [ ! gh auth status >/dev/null 2>&1 ];
then
  git config --global user.name "thederpykrafter"
  git config --global user.email thederpykrafter@gmail.com
  git config --global init.defaultBranch main
  gh auth login
  echo -e "\e[94mSuccesfully configured Git\e[0m"
fi

if [ command -v github-desktop &> /dev/null ];
then
  yay -S github-desktop-bin --noconfirm
  echo -e "\e[94mSuccesfully installled GitHub Desktop\e[0m"
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
  sudo chmod a+x ~/.screenlayout/monitor.sh
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
  echo -e "\e[0m"
fi

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
fi

if [ ! -f ~/.oh-my-zsh/custom/shell.zsh ]; then
	echo -e "\e[94mCloning zsh config\e[0m"
	rm -rf ~/.oh-my-zsh/custom
	git clone git@github.com:thederpykrafter/zsh ~/.oh-my-zsh/custom
	echo -e "\e[94mzsh config cloned\e[0m"
fi

sudo pacman -Syy
sudo pacman -Syu

if [ ! -f setup/setup.sh ];
then
  git clone git@github.com:thederpykrafter/endeavour-arch-setup ~/setup
  echo -e "\e[94mSetup script cloned\[0m"
fi

configs="alacritty nvim termux-nvim picom"

for cfg in $configs
do
  if [ ! -d ~/.config/$cfg ];
  then
    git clone git@github.com:thederpykrafter/$cfg ~/.config/$cfg
    echo -e "\e[94m$cfg config cloned\[0m"
  fi
done

if [ ! -f ~/.config/i3/i3-lock-screen.png ];
then
  rm -rf ~/.conig/i3
  git clone git@github.com:thederpykrafter/endeavour-i3 ~/.config/i3
  echo -e "\e[94mi3 config cloned\[0m"
fi

if [ ! -d ~/Dev ];
then
  mkdir ~/Dev
  dev_folders="go rust ocaml zig"
  for folder in $dev_folders
  do
    mkdir ~/Dev/$folder
  done
fi
