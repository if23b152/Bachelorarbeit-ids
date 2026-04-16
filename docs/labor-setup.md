# Labor Setup

## Ziel der Laborumgebung

Fuer die praktische Umsetzung der Bachelorarbeit wird eine VM-basierte Laborumgebung verwendet. Ziel ist es, reproduzierbare Angriffsszenarien in einer kontrollierten Umgebung auszufuehren und spaeter die Reaktion der IDS-Loesungen Snort, Suricata und Zeek systematisch zu vergleichen.

## Rollenverteilung der Systeme

Die Laborumgebung ist in getrennte Rollen aufgeteilt:

- **Kali Linux VM**: Angreifersystem
- **Windows VM**: erstes Zielsystem (Victim)
- **Debian VM**: geplante Sensor-VM fuer Snort, Suricata und Zeek
- **Ubuntu VM**: spaeteres zweites Zielsystem (Linux-Victim)

Diese Trennung wurde bewusst gewaehlt, um Zielsysteme und Detektionssysteme nicht zu vermischen. Dadurch bleibt der Vergleich methodisch sauber und nachvollziehbar.

## Aktueller Stand

Der Aufbau der Laborumgebung erfolgt schrittweise. Zum aktuellen Stand sind die Kali-Linux-VM als Angreifersystem und eine Windows-VM als erstes Zielsystem erfolgreich eingerichtet. Beide Systeme wurden mit NAT fuer allgemeinen Netzwerkzugang sowie zusaetzlich mit einem separaten Host-Only-Netzwerk fuer interne Lab-Kommunikation konfiguriert.

Damit ist eine erste stabile Kommunikationsbasis geschaffen, auf der die naechsten praktischen Schritte der Arbeit aufbauen koennen. Ein Linux-Zielsystem sowie die eigentliche Sensor-VM werden in den naechsten Schritten ergaenzt.

## Begruendung fuer den VM-basierten Aufbau

Die Testumgebung wird bewusst auf Basis virtueller Maschinen umgesetzt. Dadurch lassen sich vollstaendige Betriebssysteme mit realistischer Angriffsflaeche betreiben. Ausserdem koennen Windows- und Linux-Zielsysteme sinnvoll in denselben Aufbau integriert werden. Fuer den vorgesehenen Vergleich der IDS-Loesungen ist dies geeigneter als ein containerbasierter Aufbau.

## Naechste Schritte

Die naechsten praktischen Schritte sind:

1. Windows-Victim vollstaendig dokumentieren
2. Snapshot der aktuellen Windows-VM erstellen
3. Debian-basierte Sensor-VM aufsetzen
4. spaeter Ubuntu als zweites Zielsystem ergaenzen
5. danach Snort, Suricata und Zeek in Standardkonfiguration vorbereiten
