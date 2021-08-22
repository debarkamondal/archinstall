#!/bin/bash

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "dezire-PC" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 dezire-PC.localdomain dezire-PC" >> /etc/hosts
echo root:password | chpasswd

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S grub grub-btrfs efibootmgr networkmanager dialog wpa_supplicant mtools dosfstools reflector base-devel linux-headers avahi gvfs gvfs-smb nfs-utils inetutils dnsutils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack pulseaudio pulseaudio-alsa bash-completion openssh rsync acpi acpi_call virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font pavucontrol

# pacman -S --noconfirm xf86-video-amdgpu
pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
#systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
#systemctl enable tlp # laptop only
#systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

useradd -m dezire
echo dezire:password | chpasswd
usermod -aG libvirt dezire

echo "dezire ALL=(ALL) ALL" >> /etc/sudoers.d/dezire
mkinitcpio -p linux


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

