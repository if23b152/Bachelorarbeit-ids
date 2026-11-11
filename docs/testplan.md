# Testplan

## Grundsätze

- ein Test nach dem anderen, jeweils mit **nur einem** aktiven IDS auf dem Sensor
- vor jedem Lauf: VM-Snapshot, IDS neu starten, neuen Log-Ordner anlegen
- klare Trennung zwischen Angriffsziel und Messsystem
- jeder Lauf wird mit [`test_result_template.md`](../templates/test_result_template.md) dokumentiert

## Phasen

| Phase | Inhalt | Status |
|---|---|---|
| 1 – Baseline | Ping, `nmap -sn`, `nmap -sV`, Paketmitschnitt auf Kali und Sensor | ✅ abgeschlossen |
| 2 – Integration | Suricata, Snort, Zeek installieren; lokale Testregeln für ICMP und TCP-SYN | ✅ abgeschlossen |
| 3 – Reconnaissance | TCP-SYN-Scan gegen Windows und Ubuntu, alle drei IDS | ✅ abgeschlossen |
| 4 – Exploits Windows | W-01 EternalBlue-Probe, W-02 SMB psexec, alle drei IDS | ✅ abgeschlossen |
| 5 – Exploits Linux | vergleichbare Szenarien gegen Ubuntu | ⏳ Ausblick |
| 6 – Angepasste Konfiguration | Default- vs. Custom-Regeln, Thresholding, Zeek-Notices | ⏳ Ausblick |

## Ablauf eines Messlaufs

```text
Sensor:  IDS starten  ──►  measure_resources.sh  ──►  (optional) start_tcpdump.sh
Kali:                      Szenario ausführen
Sensor:  IDS stoppen  ──►  collect_logs.sh  ──►  count_alerts.sh  ──►  Ergebnis dokumentieren
```

Szenarien: [exploit-list.md](exploit-list.md) · Bewertung: [detection-schema.md](detection-schema.md) · Ergebnisse: [results.md](results.md)
