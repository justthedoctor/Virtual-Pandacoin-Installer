#!/bin/bash
# Currently working for Debian 8, Will be tested agesnt other distro's for compatablity. 
# Digital Pandacoin Development Team Presents Virtual PandaBank Installer
BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m'
BOLD='\e[1m'

echo -e "//------- ${YELLOW}${BOLD}Virtual PandaBank Installer ${NC}---------"
echo "|| version: 0.1a                        "
echo "|| developer: Digital Pandacoin Dev Team"
echo "|| email: justthedoctor.931@gmail.com   "
echo " \\-------------------------------------_______"
echo -e " ${RED}${BOLD}Starting${YELLOW}${BOLD}.... ${NC}"
sleep 5s
echo -e "${YELLOW}${BOLD}|| Updating package manager database ||${NC}"
apt-get update
echo  -e "${YELLOW}${BOLD}|| upgrading base packages ||${NC}"
sleep 5s
apt-get -y upgrade
echo  -e "${YELLOW}${BOLD}|| Upgrading Distro ||${NC}"
apt-get -y dist-upgrade
sleep 5s
echo  -e "${YELLOW}${BOLD}|| Installing xfce4 Desktop Enviroment and Tight VNC Server ||${NC}"
apt-get -y install task-xfce-desktop nano xfce4-goodies tightvncserver sudo
echo  -e "${YELLOW}${BOLD}|| Creating Sudo User account||${NC}"
sleep 5s
read -p "Enter Desired Sudo Username: " sudousername
adduser $sudousername
usermod -aG sudo $sudousername
echo  -e "${YELLOW}${BOLD}|| Starting VNC Server on Port 5955 ||${NC}"
sleep 5s
su - $sudousername -c "vncserver :55"
echo  -e "${YELLOW}${BOLD}|| VNC Server Running on Port 5955 ||${NC}"
sleep 5s
echo  -e "${YELLOW}${BOLD}|| Installing the dependancies for pandacoin ||${NC}"
sleep 5s
apt-get -y install qt5-default qt5-qmake qtbase5-dev-tools qttools5-dev-tools build-essential libboost-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev git libminiupnpc-dev
echo  -e "${YELLOW}${BOLD}|| Cloning Pandabank from Github ||${NC}"
sleep 5s
# Still needs to be tested to ensure properly working.
su - $sudousername -c "git clone https://github.com/digitalpandacoin/pandacoin/"
echo  -e "${YELLOW}${BOLD}|| Compile PandaBank ||${NC}"
sleep 5s
su - $sudousername -c "chmod +x ~/pandacoin/src/leveldb/build_detect_platform"
su - $sudousername -c "cd ~/pandacoin/ && qmake && make"
su - $sudousername -c "cp ~/pandacoin/pandacoin-qt ~/Desktop/PandaBank"
echo -e "${YELLOW}${BOLD} Installation Successful${NC}"
echo -e "${YELLOW}${BOLD} || Downloading pandacoin.conf ||${NC}"
sleep 5s
su - $sudousername -c "mkdir ~/.pandacoin/ && wget -O ~/.pandacoin/pandacoin.conf http://files.cryptodepot.org/installer_resources/pandacoin.conf"