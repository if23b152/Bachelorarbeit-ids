# Network plan

Every VM has two adapters:

| Adapter | Mode | Purpose |
|---|---|---|
| 1 | NAT | internet access for installation and updates – **no** test traffic |
| 2 | Host-only (`192.168.56.0/24`) | internal test network for all scans and exploits |

The separation prevents background traffic from the internet from influencing the measurements.

## Addresses in the host-only network

| System | IP | Interface |
|---|---|---|
| Kali Linux (attacker) | `192.168.56.102` | – |
| Windows 11 (target 1) | `192.168.56.103` | – |
| Debian sensor | `192.168.56.104/24` (static) | `enp0s3` (NAT: `enp0s8`) |
| Ubuntu 26.04 (target 2) | `192.168.56.105` | – |

## Verification

| Test | Result |
|---|---|
| Ping Kali ↔ Windows | successful in both directions |
| Ping sensor → Kali / Windows | successful |
| `nmap -sn 192.168.56.103` | Windows detected as an active host |
| `nmap -sV 192.168.56.103` | all 1000 default TCP ports `filtered` → baseline of the default Windows configuration |
| Capture on Kali (`windows-baseline.pcap`) | ICMP echo request/reply, ARP request/reply |
| Capture on the sensor (`sensor-test2.pcap`, `enp0s3`) | ICMP, ARP and TCP between Kali and the targets visible |

**Difference between the targets:** Windows does not answer SYN packets (filtered), Ubuntu answers with `RST/ACK` (closed ports). This is already visible in the sensor capture and explains the different `conn_state` values in Zeek.

Screenshots: [`results/raw/ip_a.png`](../results/raw/ip_a.png), [`results/raw/tshark.png`](../results/raw/tshark.png)
