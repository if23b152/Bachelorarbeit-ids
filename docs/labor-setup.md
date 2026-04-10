# Labor Setup

## Aktueller Stand

Die VM-basierte Laborumgebung wurde initial mit einer Kali-Linux-VM als Angreifersystem und einer Windows-VM als Zielsystem aufgebaut. Beide Systeme verfuegen ueber einen NAT-Adapter fuer allgemeinen Netzwerkzugang sowie ueber ein separates Host-Only-Netzwerk fuer kontrollierten internen Testverkehr.

## Systeme

- Kali Linux VM: Angreifersystem
- Windows VM: erstes Zielsystem
- Linux-Victim: noch ausstehend

## Netzwerkmodus

- NAT: allgemeiner Netzwerkzugang der VMs
- Host-Only: isolierte Kommunikation zwischen Angreifer- und Zielsystem

## Ziel des aktuellen Aufbaus

Ziel dieses Zwischenschritts ist die Herstellung einer stabilen und reproduzierbaren Kommunikationsbasis zwischen Angreifer- und Zielsystem als Grundlage fuer spaetere IDS- und Exploit-Tests.

## Zweck des Laboraufbaus

Der Aufbau dient als kontrollierte Testumgebung, in der Netzwerkverkehr reproduzierbar erzeugt, mitgeschnitten und spaeter mit IDS-Systemen wie Snort, Suricata und Zeek ausgewertet werden kann.
