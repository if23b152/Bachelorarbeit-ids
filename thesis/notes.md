# Working notes

## Practical progress

The VM-based lab environment works. A Kali Linux VM serves as the attacker system, and a Windows VM was set up as the first target.

Both systems were connected via NAT and additionally via a separate host-only network. This created an internal test network for controlled, reproducible communication between attacker and target.

Reachability was verified: ping tests worked in both directions, and Nmap correctly detected the Windows system as an active host. A service scan showed no openly identifiable default TCP services – all 1000 scanned ports appeared as `filtered`. This result is treated as the baseline of the default Windows configuration.

A first packet capture showed ICMP and ARP packets, confirming the basic communication and capture setup of the lab.

## Sensor integration

The lab was then extended with a Debian-based sensor VM. It was integrated into the same internal host-only network and additionally given a NAT adapter for general network access.

The sensor's host-only interface received a static IP address. Connectivity tests showed that both Kali and the Windows target are reachable from the sensor. A packet capture of the traffic between Kali and Windows on the sensor showed ICMP and ARP packets. This proved that the sensor can observe the internal test traffic and laid the technical foundation for installing and evaluating Snort, Suricata and Zeek.
