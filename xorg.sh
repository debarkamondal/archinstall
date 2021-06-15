sudo timedatectl set-ntp true
sudo hwclock --systohc

sudo firewall-cmd --add-port=1025-65535/tcp --permanent
sudo firewall-cmd --add-port=1025-65535/udp --permanent
sudo firewall-cmd --reload

git clone https://aur.archlinux.org/paru.git
cd paru/
makepkg -si --noconfirm

paru -S --noconfirm zramd google-chrome xdman
sudo

sudo pacman -S --noconfirm xorg vlc alacritty audacity 

sudo flatpak install -y spotify

sudo systemctl enable sddm
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
