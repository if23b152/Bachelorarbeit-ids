# Bachelorarbeit IDS

Repository fuer die Bachelorarbeit zum Vergleich und zur Evaluation von Intrusion-Detection-Systemen.

## Ziel

Dieses Projekt dokumentiert Laboraufbau, Netzwerkplanung, Testfaelle, Erkennungsschema und Ergebnisse fuer IDS-Werkzeuge wie Snort, Suricata und Zeek.

## Struktur

- `docs/`: Dokumentation zu Labor, Netzwerk, Tests und Exploits
- `configs/`: Hinweise und Konfigurationsnotizen fuer IDS-Komponenten
- `scripts/`: Hilfsskripte fuer Setup, Capture und Auswertung
- `templates/`: Vorlagen fuer Testfaelle und Testergebnisse
- `results/`: Rohdaten, verarbeitete Ergebnisse, Tabellen und Screenshots
- `thesis/`: Gliederung und Arbeitsnotizen zur Bachelorarbeit

## Start

```bash
chmod +x scripts/setup/prepare_dirs.sh
./scripts/setup/prepare_dirs.sh
```

Danach koennen PCAPs, Logs und Auswertungstabellen in `results/` abgelegt werden.
