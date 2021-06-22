sudo timedatectl set-ntp true
sudo hwclock --systohc

sudo firewall-cmd --add-port=1025-65535/tcp --permanent
sudo firewall-cmd --add-port=1025-65535/udp --permanent
sudo firewall-cmd --reload

git clone https://aur.archlinux.org/paru.git
cd paru/
makepkg -si --noconfirm

paru -S --noconfirm zramd xdman brave picom-jonaburg-git  nerd-fonts-fira-code nerd-font-hack starship python-psutils
sudo systemctl enable --now zramd.service

sudo pacman -S --noconfirm xorg xorg-init vlc alacritty audacity fish lxqt-policykit
sudo systemctl enable zram 
sudo flatpak install -y spotify

/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
