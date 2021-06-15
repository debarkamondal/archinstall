#!/bin/bash
timedatectl set-ntp true

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
clear
echo Enter the number of mirrors
read mirror
reflector --verbose --latest $mirror --sort rate --save /etc/pacman.d/mirrorlist

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


