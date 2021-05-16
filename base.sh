#!/bin/bash

#asking for parition numbers
lsblk
echo Enter the installation drive
read drive
echo Only enter the '1' for sda1 and 'p1' for nvme0n1p1
echo Enter boot drive
read boot
echo Enter root drive
read root

#updating mirrorlist
reflector --verbose --latest 50 --sort rate --save /etc/pacman.d/mirrorlist

#formating and mounting root partition
wipefs /dev/$drive$root
mkfs.btrfs -f /dev/$drive$root
mount /dev/$drive$root /mnt
cd /mnt

#creating subvolume
btrfs su cr @
btrfs su cr @home
btrfs su cr @var
cd

#unmounting and remounting subvolumes
umount /mnt
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@ /dev/$drive$root /mnt
mkdir /mnt/{boot,home,var}
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@home /dev/$drive$root /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@var /dev/$drive$root /mnt/var
mount /dev/$drive$boot /mnt/boot

#installing base system
pacstrap /mnt base linux linux-firmware vim btrfs-progs

#generating fstab
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash <<EOF
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
pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector \
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
