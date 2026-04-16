# Notes

## Aktueller praktischer Stand

Die bisherige praktische Umsetzung zeigt, dass die VM-basierte Laborumgebung grundsaetzlich funktioniert. Als Angreifersystem ist eine Kali-Linux-VM vorhanden. Zusaetzlich wurde ein erstes Windows-Zielsystem erfolgreich eingerichtet und in Betrieb genommen.

Beide Systeme wurden ueber NAT sowie zusaetzlich ueber ein separates Host-Only-Netzwerk verbunden. Dadurch konnte ein internes Testnetz aufgebaut werden, das fuer kontrollierte und reproduzierbare Kommunikation zwischen Angreifer- und Zielsystem genutzt werden kann.

Die Erreichbarkeit wurde erfolgreich geprueft. Ping-Tests in beide Richtungen funktionierten. Ausserdem wurde das Windows-System ueber Nmap korrekt als aktiver Host erkannt. Ein Service-Scan zeigte, dass derzeit keine offen identifizierbaren Standard-TCP-Dienste sichtbar sind und alle 1000 gescannten Ports als `filtered` erschienen. Dieses Ergebnis wird als Baseline der aktuellen Windows-Standardkonfiguration interpretiert.

Zusaetzlich wurde ein erster Paketmitschnitt erstellt. Im Mitschnitt waren ICMP- und ARP-Pakete sichtbar. Damit ist die grundlegende Kommunikations- und Mitschnittbasis der Laborumgebung bestaetigt.

## Naechste praktische Schritte

1. aktuellen Stand im Repository dokumentieren
2. Snapshot der Windows-VM erstellen
3. Debian-Sensor-VM vorbereiten
4. spaeter Ubuntu als zweites Victim ergaenzen
5. Snort, Suricata und Zeek in Standardkonfiguration vorbereiten
