#/bin/bash

# vars
netdev=$(ip r | grep default | awk -F ' ' '{print $5}')
ipaddress='10.77.77.1'
# -dhcp range
dhcpstart=""
dhcpend=""
dhcpmask="255.255.255.0"
dhcprange="10.77.77.100,10.77.77.200,255.255.255.0"

# begin
sudo ip a add $ipaddress/24 dev $netdev
#sed -i "s/ENV\ IP_ADDRESS\ .*[0-9]\..*[0-9]\..*[0-9]\..*[0-9]/ENV\ IP_ADDRESS\ $ipaddress/g" Dockerfile
sed -i "s/fetch=tftp:\/\/.*[0-9]\..*[0-9]\..*[0-9]\..*[0-9]\//fetch=tftp:\/\/$ipaddress\//g" tftpboot/pxelinux.cfg/additional_menu_entries
sed -i "s/\[\"--dhcp-range=.*[0-9]\..*[0-9]\..*[0-9]\..*[0-9],*\"\]/\[\"--dhcp-range=$dhcprange\"\]/g" Dockerfile
docker build -t docker-pxe .
docker run -it --rm --net=host docker-pxe
sudo ip a del $ipaddress/24 dev $netdev
