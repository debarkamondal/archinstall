sudo timedatectl set-ntp true
sudo hwclock --systohc

sudo firewall-cmd --add-port=1025-65535/tcp --permanent
sudo firewall-cmd --add-port=1025-65535/udp --permanent
sudo firewall-cmd --reload

git clone https://aur.archlinux.org/paru.git
cd paru/
makepkg -si --noconfirm

paru -S --noconfirm zramd xdman brave-bin picom-jonaburg-git nerd-fonts-fira-code nerd-font-hack starship timeshift timeshift-autosnap xwinwrap
echo "MAX_SIZE=2048" >> /etc/default/zramd
sudo systemctl enable --now zramd.service

sudo pacman -S --noconfirm qtile xorg xorg-xinit vlc alacritty lxqt-policykit zsh zsh-syntax-highlighting python-psutil zsh-autosuggestions lm_sensors mpv file-roller thunar thunar-archive-plugin thunar-volman
echo "Please reboot"
