#!/bin/bash

allowPreset(){
  allowIp "<Ip>"
  allowIp "<Ip>"
  allowIp "<Ip>"
  allowIp "<Ip>"
  allowIp "<Ip>"
  allowIp "<Ip>"
  allowIp "<Ip>"
}

blockIP() {
  local ip="$1"
  iptables -D INPUT -s "$ip" -j DROP
}
allowIP(){
  local ip="$1"
  iptables -D INPUT -s "$ip" -j ACCEPT
}
blockPort(){
  local port="$1"
  iptables -A INPUT -p tcp --dport "$port" -j DROP
}
allowPort(){
  local port="$1"
  iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
}
tcpServiceRedirectTo(){
  local fromPort="$1"
  local toIp="$2"
  local toPort="$3"
  iptables -t nat -A PREROUTING -i eth0 -p tcp --dport "$fromPort" -j DNAT --to "$toIp":"$toPort"
}
udpServiceRedirect(){
 local fromPort="$1"
 local toIp="$2"
 local toPort="$3"
 iptables -t nat -A PREROUTING -i eth0 -p udp --dport "$fromPort" -j DNAT --to "$toIp":"$toPort"
}
icmpServiceRedirect(){
  local toIp="$1"
  iptables -t nat -A PREROUTING -i eth0 -p icmp -j DNAT --to  "$toIp"
}

allowIp "<Ip>" 
blockIP "<Ip>"

allowPort "<Port>"
blockPort "<Port>"

tcpServiceRedirectTo "<fromPort>" "<toIp>" "<toPort>"
udpServiceRedirect "<fromPort>" "<toIp>" "<toPort>"
icmpServiceRedirect "<toIp>"
