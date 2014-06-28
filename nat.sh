#!/bin/bash

#@Author: Daniel Monotoko
#@Version: 0.1
#Description: Bash script to make NAT management with iptables easier.


function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

function die()
{
echo $1
exit 1;
}

#if valid_ip 2.2.2.2; then echo "success"; else echo "fail"; fi;
#errors fail;

#First we check if we actually have some arguments.

if [ -z $1 ]; then
die "No arguments supplied - Please use nat.sh help"
fi


if [ $1 == "open" ]; then

[ "$#" -eq 5 ] || die "Invalid Arguments - $(tput setaf 1)open [external] [internal] [protocol] [port]$(tput sgr0)"

if [[ $4 != @(TCP|UDP) ]]; then

die "Protocol needs to be TCP or UDP"

fi 

iptables -t nat -A PREROUTING --dst $2 -p $4 --dport $5 -j DNAT --to-destination $3

elif [ $1 == "close" ]; then
iptables -t nat -D PREROUTING --dst $2 -p $4 --dport $5 -j DNAT --to-destination $3

elif [ $1 == "one-to-one" ]; then
iptables -t nat -A PREROUTING --dst $2 -j DNAT --to-destination $3

elif [ $1 == "show" ]; then
iptables -t nat --list

elif [ $1 == "init" ]; then

iptables -t nat -A POSTROUTING -o $2 -j MASQUERADE
iptables -A FORWARD -i $2 -o $3 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $3 -o $2 -j ACCEPT

elif [ $1 == "help" ]; then

echo "Add single port, accepts TCP and UDP: $(tput setaf 1)open [external] [internal] [protocol] [port]$(tput sgr0)"
echo "Remove single port: $(tput setaf 1)close [external] [internal] [protocol] [port]$(tput sgr0)"
echo "1 to 1 NATTING: $(tput setaf 1)one-to-one [external] [internal]$(tput sgr0)"
echo "Shows all current nat rules: $(tput setaf 1)show$(tput sgr0)"
echo "Initialises the NAT between two networks: $(tput setaf 1)init [external network name] [internal network name]$(tput sgr0)"

fi


