#!/bin/bash

installPackages() {
  apt-get update
  apt-get install iptables
  apt-get install kmod

  modprobe iptables_nat
  modprobe iptables_mangle
  modprobe iptables_filter
}

allowIpRouting() {
  echo 1 > /proc/sys/net/ipv4/ip_forward
}

installPackages
allowIpRouting