configFirewall() {
  iptables -t nat -F
  iptables -t mangle -F
  iptables -t filter -F
  iptables -X

  iptables -t nat -Z
  iptables -t mangle -Z
  iptables -t filter -Z

  iptables -P OUTPUT ACCEPT
  iptables -P INPUT DROP
  iptables -P FORWARD DROP
}