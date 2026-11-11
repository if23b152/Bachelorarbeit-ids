# Laboraufbau

Die praktische Untersuchung läuft in einer **VirtualBox**-Umgebung. Ziel ist ein kontrollierter, reproduzierbarer Rahmen, in dem dieselben Angriffe mehrfach ausgeführt und die Reaktionen von Snort, Suricata und Zeek unter identischen Bedingungen verglichen werden können.

## Rollen

| Rolle | System | Aufgabe |
|---|---|---|
| Angreifer | Kali Linux 2025.4 | Scans und Exploit-Versuche (Metasploit, Nmap, tcpdump, TShark) |
| Ziel 1 | Windows 11 (64-bit) | Fokus der exploitnahen Auswertung (SMB, Port 445) |
| Ziel 2 | Ubuntu 26.04 (64-bit) | allgemeiner Aufbau und Baseline-Tests |
| Sensor | Debian 13.4 (64-bit) | passive Beobachtung; Snort, Suricata und Zeek in getrennten Läufen |

Angreifer, Ziele und Sensor sind bewusst getrennte VMs. Der Sensor ist nie selbst Angriffsziel, sondern liest den Verkehr im Labornetz nur mit. So bleibt der Vergleich methodisch sauber.

## Warum VMs statt Container?

VMs emulieren vollständige Betriebssysteme und bieten damit eine realistische Angriffsfläche. Außerdem lassen sich Windows- und Linux-Ziele im selben Aufbau betreiben – für einen IDS-Vergleich mit echten Exploits ist das geeigneter als ein containerbasierter Aufbau.

## Aufbau in Schritten

1. Kali als Angreifer und Windows 11 als erstes Ziel eingerichtet, jeweils mit NAT- und Host-Only-Adapter
2. Erreichbarkeit per Ping und `nmap -sn` geprüft, erster Baseline-Mitschnitt
3. Debian-Sensor-VM ergänzt, statische Host-Only-IP `192.168.56.104/24` auf `enp0s3`
4. Mitschnitt auf dem Sensor mit `tcpdump`/`tshark` verifiziert (ARP, ICMP, TCP sichtbar)
5. Ubuntu 26.04 als zweites Ziel ergänzt
6. Suricata → Snort → Zeek nacheinander installiert und mit lokalen Testregeln verifiziert
7. Messläufe: SYN-Scan und zwei SMB-Exploit-Szenarien gegen Windows

Vor jedem Messlauf werden VM-Snapshots verwendet, damit alle Läufe vom selben Zustand starten.

Netzwerkdetails: [network-plan.md](network-plan.md)
