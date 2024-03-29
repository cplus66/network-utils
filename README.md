# network-utils
Network Monitor Utilities

## Usage
```
Usage: ./net-mon.sh
```

## Output Log Format
Log Filename: /usr/local/AgentService/logs/NetworkMonitor.txt

```
<timestamp> <hostname> <object> <status>
<details>

timestamp: format "%Y-%m-%d %H:%M:%S"
hostname: $(hostname)
object: ethernet | dhcp | gateway | public-ip | dns | network-manager | service | firewall
status: PASSED | FAILED | INFO | WARN
```

## Monitor Network Availability

###  Ethernet Interface (L2)
```
ip addr
ifconfig -a
ETH=$(ifconfig | grep eth | awk -F ":" '{print $1}')
nmcli -colors no dev
nmcli -colors no dev show $ETH
```

### DHCP (L3)
```
nmcli -f dhcp4 dev show $ETH
```

###  Gateway (L3)
```
ip route
GATEWAY=$(ip route | grep default | awk '{print $3}')
```

### Public IP (L3)
```
ping 8.8.8.8
apt update && apt get -y traceroute
traceroute 8.8.8.8
```

### DNS (L3)
```
cat /etc/resolv.conf
ping www.google.com
```


### Network Manager
```
systemctl --no-pager status NetworkManager
nmcli connection
nmcli -f all dev show $ETH
```

###  TCP/UDP service
```
netstat -na
```

###  Firewall Setting
```
iptables -nL
iptables -t nat -nL
```

## Other Important Logs

### Kernel log
```
dmesg -T
```

### System Log
```
/var/log/syslog*
```
