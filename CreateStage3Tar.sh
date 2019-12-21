#!/bin/bash

#This script creates a stage 3 tar file out of the existing file system
#constructed by the CreateLiteStage3.sh script.

printf "Run this script as root!!!\n";
printf "Stage 3 tar file creator\n";
printf "This program converts your fresh stage 3 filesystem into a .tar file,\n";
printf "Ready for installation and configuration.\n\n\n";

#Get User Input for the mountpoint
printf "minisystem.img needs to be mounted. Where is it's mountpoint: ";
read -r MOUNTPOINT;

#Check user input.
while true
do
	if [ "$MOUNTPOINT" == "" ]
	then
		printf "Enter it's mountpoint: ";
		read -r MOUNTPOINT;
	else
		break;
	fi
done

#Get user input for the save location
printf "Where would you like to save the file (absolute path): ";
read -r SAVEPTH;

#Check User Input
while true
do
	if [ "$SAVEPTH" == "" ]
	then
		printf "Enter the absolute path to the save location: ";
		read -r SAVEPTH;
	else
		break;
	fi
done

#Get user input to continue
printf "Stage 3 ready for creation. Would you like to proceed? [Y/n]: ";
read -r STARTVAR;

#Depending on input, create tar file, exit or pop an error and reread Input.
while true
do
	if [ "$STARTVAR" == "Y" ]
	then
		tar -cvpf "$SAVEPTH"/SpiderOS_Stage3.tar -C "$MOUNTPOINT" .; 
		printf "Stage 3 tar created!\n";
		break;
	elif [ "$STARTVAR" == "n" ]
	then
		printf "Exiting upon user request...\n";
		exit 0;
	else
		printf "Enter a Y or an n: ";
		read -r STARTVAR;
	fi
done
