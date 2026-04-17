# Network Plan

## Netzwerkziel

Das Netzwerk der Laborumgebung soll einerseits normalen Internetzugang fuer Installation und Updates ermoeglichen und andererseits ein getrenntes internes Testnetz fuer kontrollierten und reproduzierbaren Verkehr zwischen Angreifer- und Zielsystem bereitstellen.

## Verwendete Netzwerkmodi

Sowohl Kali als auch Windows wurden mit zwei Netzwerkadaptern betrieben:

- **Adapter 1: NAT**
  - fuer allgemeinen Internetzugang
  - fuer Downloads, Updates und Standardnetzwerkzugriffe

- **Adapter 2: Host-Only**
  - fuer internes Testnetz
  - fuer reproduzierbaren Verkehr zwischen Kali und Windows
  - fuer spaetere Paketmitschnitte und IDS-Auswertung

## Aktuelle IP-Konfiguration

### Kali Linux
- NAT: `10.0.2.15`
- Host-Only: `192.168.56.102`

### Windows Victim
- NAT: `10.0.2.15`
- Host-Only: `192.168.56.103`

## Kommunikationstest

Die Erreichbarkeit zwischen Kali und Windows wurde erfolgreich geprueft.

### Ping-Tests
- Kali -> Windows: erfolgreich
- Windows -> Kali: erfolgreich

Die ICMP-Kommunikation funktioniert damit in beide Richtungen ueber das Host-Only-Netzwerk.

## Host Discovery

Ein erster Nmap-Host-Discovery-Scan wurde erfolgreich durchgefuehrt:

- `nmap -sn 192.168.56.103`

Das Windows-System wurde dabei korrekt als aktiver Host erkannt.

## Service-Scan / Baseline

Ein anschliessender Service-Scan mit:

- `nmap -sV 192.168.56.103`

ergab folgendes Baseline-Ergebnis:

- Host ist erreichbar
- alle 1000 standardmaessig gescannten TCP-Ports waren `filtered`
- es wurden aktuell keine offen identifizierbaren TCP-Dienste festgestellt

Dieses Ergebnis wird als **Baseline der aktuellen Windows-Standardkonfiguration** dokumentiert.

## Paketmitschnitt

Zusaetzlich wurde ein erster Paketmitschnitt auf Kali durchgefuehrt. Dabei wurde der Verkehr zwischen Kali und Windows auf dem Host-Only-Interface aufgezeichnet.

Verwendeter Mitschnitt:
- `windows-baseline.pcap`

Im Mitschnitt waren insbesondere sichtbar:

- ICMP Echo Request
- ICMP Echo Reply
- ARP Request
- ARP Reply

Damit ist nachgewiesen, dass nicht nur Kommunikation erzeugt, sondern diese auch erfolgreich erfasst und spaeter ausgewertet werden kann.

## Bedeutung des aktuellen Stands

Der aktuelle Netzwerkstand zeigt, dass:

- die grundlegende Kommunikationsbasis zwischen Kali und Windows funktioniert
- kontrollierter Testverkehr ueber das Host-Only-Netz erzeugt werden kann
- ein Mitschnitt des Verkehrs moeglich ist
- die Umgebung damit fuer die naechsten praktischen Schritte vorbereitet ist

## Naechste Netzwerkschritte

1. Mitschnitt-Dateien strukturiert im Repository ablegen
2. zusaetzliche Screenshots und Ausgaben dokumentieren
3. spaeter Sensor-VM in dasselbe Lab-Netz integrieren
4. Verkehr anschliessend parallel fuer IDS-Auswertung nutzbar machen

## 16.04: Debian-Sensor im Lab-Netz

Die Debian-basierte Sensor-VM wurde erfolgreich in das bestehende Host-Only-Netz integriert. Das Host-Only-Interface `enp0s3` erhielt die statische Adresse `192.168.56.104/24`. Zusätzlich bleibt das NAT-Interface `enp0s8` für allgemeinen Internetzugang aktiv.

### Erreichbarkeit des Sensors

Die Verbindung vom Sensor zu den bestehenden Systemen wurde erfolgreich geprüft:

- Sensor -> Kali (`192.168.56.102`): erfolgreich
- Sensor -> Windows (`192.168.56.103`): erfolgreich

### Paketmitschnitt auf dem Sensor

Auf dem Host-Only-Interface `enp0s3` wurde ein Mitschnitt des Verkehrs zwischen Kali und dem Windows-Victim erstellt.

Verwendete Datei:
- `/tmp/sensor-test2.pcap`

Die Auswertung mit `tshark` zeigte sichtbaren Verkehr zwischen Kali und Windows, darunter:

- ICMP Echo Request
- ICMP Echo Reply
- ARP Request
- ARP Reply

Damit ist nachgewiesen, dass die Sensor-VM den Verkehr im internen Lab-Netz erfolgreich beobachten und mitschneiden kann.