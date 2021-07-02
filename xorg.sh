sudo timedatectl set-ntp true
sudo hwclock --systohc

sudo firewall-cmd --add-port=1025-65535/tcp --permanent
sudo firewall-cmd --add-port=1025-65535/udp --permanent
sudo firewall-cmd --reload

git clone https://aur.archlinux.org/paru.git
cd paru/
makepkg -si --noconfirm

paru -S --noconfirm zramd xdman brave picom-jonaburg-git nerd-fonts-fira-code nerd-font-hack starship python-psutils
echo "MAX_SIZE=2048"
sudo systemctl enable --now zramd.service

sudo pacman -S --noconfirm xorg xorg-init vlc alacritty audacity lxqt-policykit zsh zsh-autocompletion zsh-syntax-highlighting zsh-autosuggestions lm_sensors
sudo systemctl enable zram 

echo "Please reboot"
