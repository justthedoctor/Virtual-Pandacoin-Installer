#!/bin/bash
# Digital Pandacoin Development Team Presents Virtual PandaBank Installer
# Currently working for Debian 8, Will be tested agesnt other distro's for compatablity. 


## The Following is font properties.
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
apt-get -y install task-xfce-desktop nano xfce4-goodies tightvncserver sudo autocutsel
echo  -e "${YELLOW}${BOLD}|| Creating Sudo User account||${NC}"
sleep 5s
read -p "Enter Desired Sudo Username: " sudousername
adduser $sudousername
usermod -aG sudo $sudousername
echo  -e "${YELLOW}${BOLD}|| Starting VNC Server on Port 5955 ||${NC}"
sleep 5s
su - $sudousername -c "vncserver :55"
su - $sudousername -c "vncserver -kill :55"
echo 'export XKL_XMODMAP_DISABLE=1' >> ~/.vnc/xstartup
echo 'autocutsel -fork' >> ~/.vnc/xstartup
su - $sudousername -c "vncserver :55"
echo  -e "${YELLOW}${BOLD}|| VNC Server Running on Port 5955 ||${NC}"
sleep 5s
echo  -e "${YELLOW}${BOLD}|| Installing the dependancies for pandacoin ||${NC}"
sleep 5s
apt-get -y install qt5-default qt5-qmake qtbase5-dev-tools qttools5-dev-tools build-essential libboost-dev libboost-all-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev git libminiupnpc-dev libboost1.55*
echo  -e "${YELLOW}${BOLD}|| Cloning Pandabank from Github ||${NC}"
sleep 5s
su - $sudousername -c "git clone https://github.com/digitalpandacoin/pandacoin/"
echo  -e "${YELLOW}${BOLD}|| Compile PandaBank ||${NC}"
sleep 5s
su - $sudousername -c "chmod +x ~/pandacoin/src/leveldb/build_detect_platform"
su - $sudousername -c "cd ~/pandacoin/ && qmake && make"
echo -e "${YELLOW}${BOLD} Installation Successful${NC}"
echo -e "${YELLOW}${BOLD} || Downloading pandacoin.conf ||${NC}"
sleep 5s
su - $sudousername -c "mkdir ~/.pandacoin/ && wget -O ~/.pandacoin/pandacoin.conf http://files.cryptodepot.org/.installer/pandacoin.conf"
echo -e "${YELLOW}${BOLD} || Downloading & Installing most recent Blockchain ||${NC}"
sleep 5s
su - $sudousername -c "cd ~/.pandacoin/ && wget http://files.cryptodepot.org/.installer/database.tar.gz && tar zxvf database.tar.gz"
su - $sudousername -c "rm -rf ~/.pandacoin/database.tar.gz"
su - $sudousername -c "cp ~/pandacoin/pandacoin-qt ~/Desktop/PandaBank"
# Still needs to be tested to ensure properly working.
echo '' >> /usr/local/bin/myvncserver
echo '#!/bin/bash' >> /usr/local/bin/myvncserver
echo 'PATH="$PATH:/usr/bin/"' >> /usr/local/bin/myvncserver
echo 'DISPLAY="1"' >> /usr/local/bin/myvncserver
echo 'DEPTH="16"' >> /usr/local/bin/myvncserver
echo 'GEOMETRY="1024x768"' >> /usr/local/bin/myvncserver
echo 'OPTIONS="-depth ${DEPTH} -geometry ${GEOMETRY} :${DISPLAY}"' >> /usr/local/bin/myvncserver
echo '' >> /usr/local/bin/myvncserver
echo 'case "$1" in' >> /usr/local/bin/myvncserver
echo 'start)' >> /usr/local/bin/myvncserver
echo '/usr/bin/vncserver ${OPTIONS}' >> /usr/local/bin/myvncserver
echo ';;' >> /usr/local/bin/myvncserver
echo '' >> /usr/local/bin/myvncserver
echo 'stop)' >> /usr/local/bin/myvncserver
echo '/usr/bin/vncserver -kill :${DISPLAY}' >> /usr/local/bin/myvncserver
echo ';;' >> /usr/local/bin/myvncserver
echo '' >> /usr/local/bin/myvncserver
echo 'restart)' >> /usr/local/bin/myvncserver
echo '$0 stop' >> /usr/local/bin/myvncserver
echo '$0 start' >> /usr/local/bin/myvncserver
echo ';;' >> /usr/local/bin/myvncserver
echo 'esac' >> /usr/local/bin/myvncserver
echo 'exit 0' >> /usr/local/bin/myvncserver
chmod +x /usr/local/bin/myvncserver
echo '[Unit]' >> /lib/systemd/system/myvncserver.service
echo 'Description=Manage VNC Server on this droplet' >> /lib/systemd/system/myvncserver.service
echo '' >> /lib/systemd/system/myvncserver.service
echo '[Service]' >> /lib/systemd/system/myvncserver.service
echo 'Type=forking' >> /lib/systemd/system/myvncserver.service
echo 'ExecStart=/usr/local/bin/myvncserver start' >> /lib/systemd/system/myvncserver.service
echo 'ExecStop=/usr/local/bin/myvncserver stop' >> /lib/systemd/system/myvncserver.service
echo 'ExecReload=/usr/local/bin/myvncserver restart' >> /lib/systemd/system/myvncserver.service
echo 'User=vnc' >> /lib/systemd/system/myvncserver.service
echo '' >> /lib/systemd/system/myvncserver.service
echo '[Install]' >> /lib/systemd/system/myvncserver.service
echo 'WantedBy=multi-user.target' >> /lib/systemd/system/myvncserver.service
systemctl daemon-reload
systemctl enable myvncserver.service
echo -e "${YELLOW}%{BOLD} || Completed Enjoy your Virtual PandaBank, for further help please email: justthedoctor.931@gmail.com${NC}"

