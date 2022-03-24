#!/bin/bash
# Date: Mar 24, 2022
# Description: network monitor

VERSION=0.1.0
EXTERNAL_IP=8.8.8.8
LOG=/usr/local/AgentService/logs/NetworkMonitor.txt
INFO=/usr/local/AgentService/logs/NetworkInfo.txt
DELAY=10

if [ ! -d /usr/local/AgentService/logs ]; then
	  mkdir -p /usr/local/AgentService/logs
fi

# Ethernet Interface
echo  [$(date +"%Y-%m-%d %H:%M:%S")] >> $INFO
echo "[Ethernet]" >> $INFO
echo "[ip addr]" >> $INFO
ip addr >> $INFO

echo -e "\n[ifconfig]" >> $INFO
ifconfig -a >> $INFO
ETH=$(ifconfig | grep -E eth[0..9] | awk -F ":" '{print $1}')

echo -e "\n[nmcli dev]" >> $INFO
nmcli -colors no dev >> $INFO
echo -e "\n[nmcli dev show]" >> $INFO
nmcli -colors no dev show $ETH >> $INFO

# DHCP
echo -e "\n[DHCP]" >> $INFO
nmcli -f dhcp4 dev show $ETH >> $INFO

# Gateway
echo -e "\n[Gateway]" >> $INFO
ip route >> $INFO

# DNS
echo -e "\n[DNS]" >> $INFO
cat /etc/resolv.conf >> $INFO

# Network Manager
echo -e "\n[Network Manager]" >> $INFO
systemctl --no-pager status NetworkManager >> $INFO
echo -e "\n[nmcli connection]" >> $INFO
nmcli connection >> $INFO
echo -e "\n[nmcli dev show all]" >> $INFO
nmcli -f all dev show $ETH >> $INFO

# TCP/UDP service
echo -e "\n[TCP/UDP Service]" >> $INFO
netstat -na >> $INFO

# Firewall
#echo -e "\n[Firewall]" >> $INFO
#iptables -nL >> $INFO

# kernel log
echo -e "\n[Kernel Log]" >> $INFO
dmesg -T >> $INFO

GATEWAY=$(ip route | grep default | awk '{print $3}')

while true; do
  for i in $GATEWAY; do
    ping -c 1 $i 1> /dev/null 2>&1
  
    if [ $? -eq 0 ]; then
      echo $(date +"%Y-%m-%d %H:%M:%S") $(hostname) gateway $i PASSED  >> $LOG
    else
      echo $(date +"%Y-%m-%d %H:%M:%S") $(hostname) gateway $i FAILED >> $LOG
    fi
  done
  sleep $DELAY
done
