# Netzplan

Jede VM hat zwei Adapter:

| Adapter | Modus | Zweck |
|---|---|---|
| 1 | NAT | Internetzugang für Installation und Updates – **kein** Testverkehr |
| 2 | Host-Only (`192.168.56.0/24`) | internes Testnetz für alle Scans und Exploits |

Die Trennung verhindert, dass Hintergrundverkehr aus dem Internet die Messungen beeinflusst.

## Adressen im Host-Only-Netz

| System | IP | Interface |
|---|---|---|
| Kali Linux (Angreifer) | `192.168.56.102` | – |
| Windows 11 (Ziel 1) | `192.168.56.103` | – |
| Debian Sensor | `192.168.56.104/24` (statisch) | `enp0s3` (NAT: `enp0s8`) |
| Ubuntu 26.04 (Ziel 2) | `192.168.56.105` | – |

## Verifikation

| Test | Ergebnis |
|---|---|
| Ping Kali ↔ Windows | erfolgreich in beide Richtungen |
| Ping Sensor → Kali / Windows | erfolgreich |
| `nmap -sn 192.168.56.103` | Windows als aktiver Host erkannt |
| `nmap -sV 192.168.56.103` | alle 1000 Standard-TCP-Ports `filtered` → Baseline der Windows-Standardkonfiguration |
| Mitschnitt auf Kali (`windows-baseline.pcap`) | ICMP Echo Request/Reply, ARP Request/Reply |
| Mitschnitt auf dem Sensor (`sensor-test2.pcap`, `enp0s3`) | ICMP, ARP und TCP zwischen Kali und den Zielen sichtbar |

**Unterschied der Ziele:** Windows beantwortet SYN-Pakete nicht (gefiltert), Ubuntu antwortet mit `RST/ACK` (geschlossene Ports). Das ist bereits im Sensor-Mitschnitt sichtbar und erklärt die unterschiedlichen `conn_state`-Werte in Zeek.

Screenshots: [`results/raw/ip_a.png`](../results/raw/ip_a.png), [`results/raw/tshark.png`](../results/raw/tshark.png)
