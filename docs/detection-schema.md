# Detection-Schema

## Zweck

Einheitliches Schema zur Bewertung und Dokumentation von IDS-Erkennungen.

## Felder

| Feld | Beschreibung |
| --- | --- |
| Test-ID | Verweis auf den Testfall |
| Tool | Snort, Suricata oder Zeek |
| Zeitstempel | Zeitpunkt des Alerts |
| Signatur/Event | Name oder ID der Erkennung |
| Schweregrad | Niedrig, Mittel, Hoch |
| Quelle | Quell-IP und Port |
| Ziel | Ziel-IP und Port |
| Bewertung | True Positive, False Positive, False Negative |

## Bewertungslogik

- True Positive: Angriff/Test wurde korrekt erkannt
- False Positive: Harmloser Traffic wurde als Angriff erkannt
- False Negative: Angriff/Test wurde nicht erkannt
