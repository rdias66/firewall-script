#!/bin/bash

function start() {
  #Exclui regras e chains
  iptables -t nat -F
  iptables -t mangle -F
  iptables -t filter -F
  iptables -X

  #Habilita o roteamento no kernel
  echo 1 > /proc/sys/net/ipv4/ip_forward

  #Zera os contadores das cadeias
  iptables -t nat -Z
  iptables -t mangle -Z
  iptables -t filter -Z

  #Carrega os modulos do IPTABLES
  modprobe iptables_nat
  modprobe iptables_mangle
  modprobe iptables_filter
  
  #Define a política padrão de ACCEPT para OUTPUT
  iptables -P OUTPUT ACCEPT

  #Define a política padrão de ACCEPT para OUTPUT
  iptables -P INPUT DROP
  iptables -P FORWARD DROP

  #Liberando as conexões ja estabelecidas
  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

  #Liberando o loopback
  iptables -A INPUT -i lo -j ACCEPT

  #Liberando o ping
  iptables -A  INPUT -p icmp --icmp-type echo-request -j ACCEPT
  iptables -A  INPUT -p icmp --icmp-type echo-reply -j ACCEPT

  #Liberando as portas necessárias
  iptables -A INPUT -p tcp --dport <port number> -j ACCEPT #PROXY
  iptables -A INPUT -p tcp --dport <port number> -j ACCEPT #DHCP
  iptables -A INPUT -p tcp --dport <port number> -j ACCEPT #DOMINIO
  iptables -A INPUT -p tcp --dport <port number> -j ACCEPT #VPN
  iptables -A INPUT -p tcp --dport <port number> -j ACCEPT #NFS
  iptables -A INPUT -p tcp --dport <port number> -j ACCEPT #EMAIL
  iptables -A INPUT -p tcp --dport <port number> -j ACCEPT #PÁGINAS
  iptables -A INPUT -p tcp --dport <port number> -j ACCEPT #JAVAAPP
  iptables -A INPUT -p tcp --dport <port number> -j ACCEPT #SSH

  #Compartilhamento de internet
  iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE

  #Roteamento
  iptables -t filter -A FORWARD -i eth0 -o eth2 -m state --state RELATED,ESTABLISHED -j ACCEPT
  iptables -t filter -A FORWARD -i eth1-o eth2 -m state --state RELATED,ESTABLISHED -j ACCEPT
  iptables -t filter -A FORWARD -i eth2 -o eth0 -j ACCEPT
  iptables -t filter -A FORWARD -i eth2 -o eth1 -j ACCEPT
}

function stop(){
  #********CUIDADO COM O USO DESSA FUNÇAO NO PROJETO*********
  #Desliga todas as conexões
  iptables -P INPUT DROP
  iptables -P OUTPUT DROP
  iptables -P FORWARD DROP
}