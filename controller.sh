#!/bin/bash

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
  local toIp="$1"
  local toPort="$1"
  iptables -t nat -A PREROUTING -i eth0 -p tcp --dport "$fromPort" -j DNAT --to "$toIp":"$toPort"
}

udpServiceRedirectTo(){
  local fromPort="$1"
  local toIp="$1"
  local toPort="$1"
  iptables -t nat -A PREROUTING -i eth0 -p udp --dport "$fromPort" -j DNAT --to $toIp":"$toPort"
}

