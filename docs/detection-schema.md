# Detection Schema

## Ziel des Schemas

Fuer jeden Testfall soll ein einheitliches Bewertungsschema verwendet werden, damit die Ergebnisse von Snort, Suricata und Zeek systematisch und nachvollziehbar verglichen werden koennen.

## Hauptkriterien

Fuer jeden Angriff bzw. Test wird untersucht:

1. **Wird ein Alert ausgeloest?**
   - ja / nein

2. **Gibt es einen verdaechtigen Log-Eintrag?**
   - ja / nein

3. **Wie schnell erfolgt die Erkennung?**
   - in Echtzeit
   - mit Verzoegerung
   - erst nachtraeglich in Logs sichtbar

4. **Wurde der Angriff erkannt oder nicht erkannt?**
   - erkannt
   - nicht erkannt

5. **War der Angriff technisch erfolgreich oder nicht?**
   - erfolgreich
   - nicht erfolgreich

Dieser Punkt ist ergaenzend relevant, steht aber nicht im Mittelpunkt. Im Fokus der Arbeit steht die Detektion.

## Prioritaet der Beobachtung

Die Reihenfolge der Bedeutung ist:

1. Alert
2. verdaechtiger Log-Eintrag
3. Zeitverhalten der Erkennung

Diese Priorisierung ist wichtig, weil insbesondere Zeek nicht immer wie klassische IDS-Systeme ueber eindeutige Alerts arbeitet.

## Zusaetzliche Vergleichspunkte

Neben den Hauptkriterien werden spaeter zusaetzlich betrachtet:

- Unterschiede zwischen Windows und Linux
- Unterschiede zwischen Standardkonfiguration und angepasster Konfiguration
- Unterschiede in CPU- und RAM-Auslastung
- Nachvollziehbarkeit und Auswertbarkeit der Ergebnisse

## Dokumentation pro Testfall

Fuer jeden Test sollen mindestens folgende Punkte festgehalten werden:

- Test-ID
- Datum
- Zielsystem
- Angriff / Scan
- verwendetes Tool
- IDS-Konfiguration
- Alert ja/nein
- verdaechtiger Log ja/nein
- Zeitverhalten
- erkannt / nicht erkannt
- technisch erfolgreich ja/nein
- Bemerkungen
