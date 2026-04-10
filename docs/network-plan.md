# Network Plan

## Netzwerkaufbau

### Kali

- NAT: 10.0.2.15
- Host-Only: 192.168.56.102

### Windows Victim

- NAT: 10.0.2.15
- Host-Only: 192.168.56.103

## Kommunikationstest

Die Erreichbarkeit zwischen Kali und Windows wurde erfolgreich ueberprueft.

### Ping

- Windows -> Kali: erfolgreich
- Kali -> Windows: erfolgreich

### Host Discovery

- `nmap -sn 192.168.56.103` erkannte das Windows-System als aktiv

## Paketmitschnitt

Ein erster Mitschnitt wurde auf Kali mit `tcpdump` auf dem Host-Only-Interface erstellt. In der Datei `windows-baseline.pcap` waren ICMP- und ARP-Pakete zwischen Kali und Windows sichtbar.

## Baseline-Ergebnis

Ein anschliessender Service-Scan mit `nmap -sV 192.168.56.103` zeigte, dass das Windows-Zielsystem erreichbar ist, jedoch innerhalb der standardmaessig gescannten 1000 TCP-Ports keine offen identifizierbaren Dienste bereitstellt. Alle Ports wurden als `filtered` angezeigt. Dieses Ergebnis wird als Baseline der aktuellen Windows-Standardkonfiguration dokumentiert.

## Geplante Artefakte

Die folgenden Dateien sollen als Nachweise im Repository abgelegt werden:

- `results/raw/windows-baseline.pcap`
- `results/screenshots/windows-ipconfig.png`
- `results/screenshots/kali-ip-a.png`
- `results/screenshots/ping-bidirectional.png`
- `results/screenshots/nmap-sn-discovery.png`
- `results/screenshots/nmap-sV-baseline.png`
- `results/screenshots/tshark-baseline.png`
