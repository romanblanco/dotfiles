# Installation process template, not intended to be executed
exit

# Get ISO and verify signature
# - https://wiki.archlinux.org/index.php/Installation_guide#Verify_signature
# ============================

# https://www.archlinux.org/download/
gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig

# Preparing bootable USB
# - https://wiki.archlinux.org/index.php/USB_flash_installation_medium#Using_basic_command_line_utilities
# ======================

wipefs --all /dev/sdx # lsblk
dd bs=4M if=path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync

# Verify boot mode is UEFI
# - https://wiki.archlinux.org/index.php/Installation_guide#Verify_the_boot_mode
# ========================

# should end with 0 if is booted as UEFI
ls /sys/firmware/efi/efivars && echo $?

# Connect to the internet
# - https://wiki.archlinux.org/index.php/Installation_guide#Connect_to_the_internet
# - https://wiki.archlinux.org/index.php/Iwd#Connect_to_a_network
# =======================

# > [iwd]# device list
# > [iwd]# station wlan0 scan
# > [iwd]# station wlan0 get-networks
# iwctl --passphrase <passphrase> station <device> connect <SSID>
iwctl --passphrase mywifipassword station wlan0 connect mywifiname
ping archlinux.org

# Update the system clock
# - https://wiki.archlinux.org/index.php/Installation_guide#Update_the_system_clock
# =======================

timedatectl set-ntp true
timedatectl status

# Partition the disks
# - ~https://wiki.archlinux.org/index.php/Installation_guide#Partition_the_disks~
# - https://wiki.archlinux.org/index.php/Partitioning#Partitioning_tools
# - https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS
# ===================

# - https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Preparing_the_disk_2
#   - Create a partition to be mounted at /boot with a size of 200 MiB or more.
#   - Create a partition which will later contain the encrypted container.
cfdisk /dev/sda
# $ lsblk -f || fdisk -l
#Number  Start (sector)    End (sector)  Size       Code  Name
#   1            2048         1050623   512.0 MiB   EF00  EFI System
#   2         5244928       976773133   463.3 GiB   8E00  Linux LVM

#| in case of seeing "dev/sda2 is apparently in use by the system; will not make a filesystem here!"
#| https://superuser.com/questions/668347/installing-arch-linux-unable-to-format-filesystem#comment844950_668347
#| dmsetup ls
#| dmsetup remove VolumeGroup-swap
#| dmsetup remove VolumeGroup-root
#| dmsetup remove VolumeGroup-home
#| or also:
#| cgdisk /dev/nvme0n1

#| $ lsblk
#| NAME          MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
#| sda             8:0    0  1.8T  0 disk
#| └─sda1          252:0  0  1.8T  0 crypt
#| hardisk erasure
#| cryptsetup open --type plain -d /dev/urandom /dev/sda sda1
#| dd if=/dev/zero of=/dev/mapper/sda1 status=progress
#| cryptsetup close sda1

#   - Create a partition which will later contain the encrypted container.
#   - Create the LUKS encrypted container at the "system" partition. Enter the chosen password twice.
cryptsetup luksFormat --type luks2 -c aes-xts-plain64 -s 512 /dev/sda2
#   - Open the container
cryptsetup open /dev/sda2 cryptlvm
#   - Preparing the locical volumes
# create physical volume
pvcreate /dev/mapper/cryptlvm
#   - Create the volume group
vgcreate ux310uVolGroup /dev/mapper/cryptlvm
#   - Create logical volumes on the volume group
lvcreate -L 35G ux310uVolGroup -n swap
lvcreate -L 60G ux310uVolGroup -n root
lvcreate -l 100%FREE ux310uVolGroup -n home
#   - Format your filesystems on each logical volume
mkfs.ext4 /dev/ux310uVolGroup/root  #| mkfs.ext4 /dev/mapper/ux310uVolGroup-root
mkfs.ext4 /dev/ux310uVolGroup/home  #| mkfs.ext4 /dev/mapper/ux310uVolGroup-home
mkswap /dev/ux310uVolGroup/swap     #| mkswap /dev/mapper/ux310uVolGroup-swap
#   - Mount your filesystems
mount /dev/ux310uVolGroup/root /mnt      #| mount /dev/mapper/ux310uVolGroup-root /mnt
mkdir /mnt/home
mount /dev/ux310uVolGroup/home /mnt/home #| mount /dev/mapper/ux310uVolGroup-home /mnt
# activate swap
swapon /dev/ux310uVolGroup/swap          #| swapon /dev/mapper/ux310uVolGroup-swap

# - https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Preparing_the_boot_partition_2
mkfs.fat -F32 /dev/sda1
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot/

# Install esential packages
# - https://wiki.archlinux.org/index.php/Installation_guide#Install_essential_packages
# =========================

pacstrap /mnt base base-devel linux linux-firmware lvm2 efibootmgr grub-efi-x86_64 mkinitcpio grub nvim networkmanager

# Generate an fstab file
# - https://wiki.archlinux.org/index.php/Installation_guide#Fstab
# ======================

genfstab -pU /mnt >> /mnt/etc/fstab

# Change root into the new system
# - https://wiki.archlinux.org/index.php/Installation_guide#Chroot
# ===============================

arch-chroot /mnt

# Time zone
# - https://wiki.archlinux.org/index.php/Installation_guide#Time_zone
# =========

ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc

# Localization
# - https://wiki.archlinux.org/index.php/Installation_guide#Localization
# ============

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=\"en_US.UTF-8\"" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

# Network configuration
# - https://wiki.archlinux.org/index.php/Installation_guide#Network_configuration
# =====================

echo "ux310u" > /etc/hostname
# update /etc/hosts:

# 127.0.0.1	localhost
# ::1	      localhost
# 127.0.1.1	ux310u.localdomain ux310u
# # - https://github.com/StevenBlack/hosts

# Initramfs
# - https://wiki.archlinux.org/index.php/Installation_guide#Initramfs
# - https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_2
# =========

vi /etc/mkinitcpio.conf
# update /etc/mkinitcpio.conf hooks:
# HOOKS=(base udev systemd autodetect keyboard sd-vconsole consolefont modconf block sd-encrypt sd-lvm2 resume filesystems fsck shutdown)
mkinitcpio -p linux

# Root password
# - https://wiki.archlinux.org/index.php/Installation_guide#Root_password
# =============

passwd

# Boot loader
# - https://wiki.archlinux.org/index.php/Installation_guide#Boot_loader
# - https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Configuring_the_boot_loader_2
# ===========

# update /etc/default/grub kernel parameter for bootloader:
# lsblk -f | grep 'sda2' >> /etc/default/grub
# GRUB_CMDLINE_LINUX="... rd.luks.name=UUID=<device-UUID>=cryptlvm root=/dev/ux310uVolGroup/root resume=/dev/ux310uVolGroup/swap" ... #| GRUB_CMDLINE_LINUX="... rd.luks.name=UUID=<device-UUID>=cryptlvm root=/dev/mapper/ux310uVolGroup-root resume=/dev/mapper/ux310uVolGroup-swap" ...
# GRUB_ENABLE_CRYPTODISK=y
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

# Reboot
# - https://wiki.archlinux.org/index.php/Installation_guide#Reboot
# ======

exit
umount -R /mnt
swapoff -a
reboot

# Post-installation
# - https://wiki.archlinux.org/index.php/Installation_guide#Post-installation
# =================

vi /etc/systemd/logind.conf
# HandleLidSwitch=ignored
systemctl restart systemd-logind

useradd -m -g users -G wheel rblanco
passwd rblanco
# edit /etc/sudoers:
# rblanco ALL=(ALL) ALL

systemctl enable NetworkManager
systemctl start NetworkManager
# Network connection stored in /etc/NetworkManager/system-connections/
#| nmcli device wifi connect <uuid> password <password>
#| nmtui
#| ip link set dev enp0s31f6 up
#| dhcpcd enp0s31f6

# https://github.com/romanblanco/dotfiles
