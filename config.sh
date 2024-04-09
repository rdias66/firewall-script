#!/bin/bash

configFirewall() {
  iptables -t nat -F
  iptables -t mangle -F
  iptables -t filter -F
  iptables -X

  iptables -t nat -Z
  iptables -t mangle -Z
  iptables -t filter -Z

  iptables -P OUTPUT ACCEPT
  iptables -P INPUT ACCEPT
  iptables -P FORWARD ACCEPT
}

configRouting(){
  iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
}

configFirewall
configRouting