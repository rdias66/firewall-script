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