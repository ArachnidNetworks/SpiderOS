#!/bin/bash
# This script downloads the iso of slitaz linux and converts it into a
# full blown installed image where we can then create a stage 3 tarball
# for easy UMSDOS-style installation and configuration in the future.

#Constants.
CWD=$(pwd);
IMAGESIZE=8192;

#change both of these accordingly!!!
URL="http://mirror.slitaz.org/iso/rolling/slitaz-rolling.iso"
ISO="slitaz-rolling.iso"

printf "THIS SCRIPT MUST BE RUN AS ROOT!!!!!!\n";
printf "Slitaz Stage3 builder. This script creates a .img you can\n";
printf "use to either flash drives with and will create a stage 3 tarball.\n"

#Get mounting directory to do all this work
printf "Enter the directory path to perform this operation in: ";
read -r MOUNTPOINT;

#Quick check of validity of user input.
while true
do
	if [ "$MOUNTPOINT" == "" ]
	then
		printf "Enter a directory: ";
		read -r MOUNTPOINT;
	else
		break
	fi
done

#Get user input to start the process, and create a disk image
#to build a chroot for.

printf "Press Y to begin: ";
read -r USER_IN;

while true
do
	if [ "$USER_IN" == "Y" ]
	then
		printf "Creating disk image...\n";
		dd if=/dev/zero of="$CWD"/minisystem.img bs=1M count="$IMAGESIZE";
		mkfs.ext4 "$CWD"/minisystem.img;
		
		printf "\n\nCreating mountpoints...\n";
		mkdir "$MOUNTPOINT"/ISO;
		mkdir "$MOUNTPOINT"/INSTALL;

		printf "\n\nDownloading Slitaz image...\n";
		cd "$CWD";
		wget "$URL";

		printf "\n\nMounting images...\n";
		mount "$CWD"/"$ISO" "$MOUNTPOINT"/ISO;
		mount "$CWD"/minisystem.img "$MOUNTPOINT"/INSTALL;

		printf "\n\nCopying chroot files...\n";
		mkdir "$MOUNTPOINT"/INSTALL/boot;
		cp -a "$MOUNTPOINT"/ISO/boot/vmlinuz-* "$MOUNTPOINT"/INSTALL/boot;
		cp "$MOUNTPOINT"/ISO/boot/rootfs* "$MOUNTPOINT"/INSTALL;

		printf "\n\nCreating Chroot...\n";
		cd "$MOUNTPOINT"/INSTALL || exit 1;
		unlzma < rootfs4.gz | cpio -id;
		unlzma < rootfs3.gz | cpio -id;
		unlzma < rootfs2.gz | cpio -id;
		unlzma < rootfs1.gz | cpio -id;
		rm rootfs* init;

		printf "\n\nChroot Created! Remember that this is a stage 3.\n";
		printf "You need manually edit your fstab, install grub, etc.\n";

		break;
	elif [ "$USER_IN" != "Y" ]
	then
		printf "Enter a capital Y to begin: ";
		read -r USER_IN;
	else
		printf "Error getting user input, exiting...\n";
		exit 1;
	fi
done
