#!/bin/bash

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

sudo pacman -S --noconfirm xorg sddm plasma firefox vlc alacritty audacity kdeconnect ark phonon-qt5 qt5-webkit qt5-script qt5-svg qt5-tools qt5-x11extras enchant jasper openexr libutempter docbook-xsl shared-mime-info giflib libxss upower udisks2 bzr git doxygen perl-json perl-libwww perl-xml-parser perl-io-socket-ssl akonadi xorg-server-devel libpwquality fontforge eigen libfakekey qca-qt5 xapian-core xsd gperf perl-yaml-syck intltool kdesdk qrencode libdmtx boost ruby-test-unit

sudo flatpak install -y spotify

sudo systemctl enable sddm
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
