# Lab setup

The practical study runs in a **VirtualBox** environment. The aim is a controlled, reproducible setting in which the same attacks can be executed repeatedly and the reactions of Snort, Suricata and Zeek compared under identical conditions.

## Roles

| Role | System | Purpose |
|---|---|---|
| Attacker | Kali Linux 2025.4 | scans and exploit attempts (Metasploit, Nmap, tcpdump, TShark) |
| Target 1 | Windows 11 (64-bit) | focus of the exploit-oriented evaluation (SMB, port 445) |
| Target 2 | Ubuntu 26.04 (64-bit) | general setup and baseline tests |
| Sensor | Debian 13.4 (64-bit) | passive monitoring; Snort, Suricata and Zeek in separate runs |

Attacker, targets and sensor are deliberately separate VMs. The sensor is never itself a target; it only listens to the traffic in the lab network. This keeps the comparison methodologically clean.

## Why VMs instead of containers?

VMs emulate complete operating systems and therefore provide a realistic attack surface. They also allow Windows and Linux targets in the same setup – for an IDS comparison with real exploits this is more suitable than a container-based setup.

## Setup steps

1. Kali as attacker and Windows 11 as the first target, each with a NAT and a host-only adapter
2. Reachability checked with ping and `nmap -sn`, first baseline capture
3. Debian sensor VM added, static host-only IP `192.168.56.104/24` on `enp0s3`
4. Capturing on the sensor verified with `tcpdump`/`tshark` (ARP, ICMP, TCP visible)
5. Ubuntu 26.04 added as the second target
6. Suricata → Snort → Zeek installed one after another and verified with local test rules
7. Measurement runs: SYN scan and two SMB exploit scenarios against Windows

VM snapshots are used before every measurement run so that all runs start from the same state.

Network details: [network-plan.md](network-plan.md)
