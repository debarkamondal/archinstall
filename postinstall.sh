#!/bin/bash
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

#generating locale
sed -i '177s/.//' /etc/locale.gen
loacle-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

#configuring host and hostname
echo "dezire-PC" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

#setting up root password
echo root:23012015 | chpasswd

#installing required packages
pacman -S --noconfirm grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector \
base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip \
alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call virt-manager \
qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware \
nss-mdns acpid os-prober ntfs-3g terminus-font nvidia nvidia-utils nvidia-settings grub-btrfs pavucontrol

#installing grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

#enabling system services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

#setting up user
useradd -m dezire
echo dezire:23012015 | chpasswd
usermod -aG libvirt dezire
echo "dezire ALL=(ALL) ALL" >> /etc/sudoers.d/dezire
exit

EOF
umount -a
rm -rf archinstall/
#reboot
