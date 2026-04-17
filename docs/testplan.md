# Testplan

## Ziel der ersten Testphase

Die erste Phase dient nicht der vollstaendigen IDS-Evaluierung, sondern dem sauberen Aufbau einer stabilen und nachvollziehbaren Laborbasis. Zunaechst werden wenige, einfache und reproduzierbare Tests durchgefuehrt.

## Erste Phase: Baseline und Grundfunktion

### Bereits umgesetzt
1. Kali-Linux-VM als Angreifersystem festgelegt
2. Windows-VM als erstes Zielsystem eingerichtet
3. NAT- und Host-Only-Netzwerk konfiguriert
4. Erreichbarkeit per Ping erfolgreich geprueft
5. erster Nmap-Host-Discovery-Scan durchgefuehrt
6. erster Paketmitschnitt erstellt

### Als Naechstes geplant
1. Windows-Victim vollstaendig dokumentieren
2. Snapshot der aktuellen Windows-VM erstellen
3. Debian-Sensor-VM aufsetzen
4. Sensor-VM in das bestehende Host-Only-Lab-Netz integrieren
5. Snort, Suricata und Zeek zunaechst in Standardkonfiguration vorbereiten
6. Ubuntu spaeter als zweites Zielsystem ergaenzen

## Grundsaetze der Testdurchfuehrung

Die Tests sollen zunaechst schrittweise durchgefuehrt werden:

- ein Test nach dem anderen
- sauber dokumentiert
- mit klarer Trennung zwischen Angriffsziel und Messsystem
- mit Fokus auf Vergleichbarkeit und Reproduzierbarkeit

Komplexere Testreihen mit Wiederholungen, hoeherer Last oder Variationen werden erst in einer spaeteren Phase ergaenzt.

## Erste Testarten

Die erste kleine Baseline-Testreihe umfasst:

1. Ping zwischen Kali und Windows
2. Host Discovery mit Nmap
3. einfacher Service-Scan mit Nmap
4. Paketmitschnitt des erzeugten Verkehrs

Diese Tests dienen als Ausgangsbasis fuer spaetere IDS-Auswertungen.

## Zweite Phase

Nach Aufbau der Sensor-VM sollen folgende Schritte folgen:

1. Snort in Standardkonfiguration testen
2. Suricata in Standardkonfiguration testen
3. Zeek in Standardkonfiguration testen
4. Verhalten der drei Systeme dokumentieren
5. Ergebnisse nach Alert, verdaechtigem Log-Eintrag und Zeitverhalten auswerten

## Spaetere Erweiterungen

In einer spaeteren Phase sollen zusaetzlich folgen:

- Ubuntu als zweites Victim
- Vergleich zwischen Windows- und Linux-Zielsystem
- speziell angepasste IDS-Konfigurationen
- weitere reproduzierbare Exploit-Szenarien

## 16.04: des weiteren Vorgehens

Nachdem die Debian-Sensor-VM erfolgreich in das interne Lab-Netz integriert wurde und ein erster Mitschnitt des Verkehrs zwischen Kali und Windows möglich war, folgt als nächster Schritt die Installation des ersten IDS auf der Sensor-VM.

Geplante Reihenfolge:
1. Suricata in Standardkonfiguration installieren und testen
2. Verhalten dokumentieren
3. danach Snort in getrenntem Testlauf vorbereiten
4. später Zeek ergänzen

Die IDS-Lösungen sollen dabei nicht parallel, sondern nacheinander unter möglichst gleichen Bedingungen untersucht werden.
