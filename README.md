<div align="center">

# Snort vs. Suricata vs. Zeek

**Vergleichende Evaluierung der Detektionsleistung von Open-Source-IDS bei reproduzierbaren Exploit-Angriffen in einer virtualisierten Laborumgebung**

![Thema](https://img.shields.io/badge/Thema-Intrusion%20Detection-1f6feb)
![Snort](https://img.shields.io/badge/Snort-3-red)
![Suricata](https://img.shields.io/badge/Suricata-apt-orange)
![Zeek](https://img.shields.io/badge/Zeek-9.0--dev-2ea043)
![Lab](https://img.shields.io/badge/Lab-VirtualBox-183a61)
![Typ](https://img.shields.io/badge/Bachelorarbeit-B.Sc.%20Informatik-6e40c9)

</div>

---

Dieses Repository begleitet eine Bachelorarbeit, in der die drei bekanntesten Open-Source-Intrusion-Detection-Systeme **Snort**, **Suricata** und **Zeek** unter identischen Bedingungen gegeneinander getestet wurden. Es enthält den kompletten Laboraufbau, die verwendeten Konfigurationen und Regeln, Hilfsskripte, das Bewertungsschema und die Ergebnisse – so aufbereitet, dass die Versuche von Dritten nachvollzogen und wiederholt werden können.

> **Kurz gesagt:** Alle drei Systeme haben die Angriffe gesehen – aber auf völlig unterschiedliche Weise.
> **Suricata** liefert die inhaltlich reichsten Alerts, **Snort** die kompakteste und ressourcenschonendste Alarmierung, **Zeek** die strukturierteste, analyseorientierte Sicht über Logs. Ein pauschal „bestes“ IDS gibt es nicht – die Wahl hängt vom Einsatzzweck ab.

## Inhalt

- [Forschungsfrage](#forschungsfrage)
- [Laborumgebung](#laborumgebung)
- [Methodik](#methodik)
- [Ergebnisse](#ergebnisse)
  - [TCP-SYN-Scan](#1-tcp-syn-scan-reconnaissance)
  - [Windows – exploitnahes SMB-Szenario](#2-windows--exploitnahes-smb-szenario)
  - [Ressourcenverbrauch](#3-ressourcenverbrauch)
  - [Bewertungsmatrix](#4-bewertungsmatrix-qualitativ-skala-15)
- [Fazit und Empfehlung](#fazit-und-empfehlung)
- [Versuche reproduzieren](#versuche-reproduzieren)
- [Repository-Struktur](#repository-struktur)
- [Grenzen und Ausblick](#grenzen-und-ausblick)

## Forschungsfrage

> Wie unterscheiden sich die Open-Source-Intrusion-Detection-Systeme Snort, Suricata und Zeek hinsichtlich ihrer Detektionsleistung bei ausgewählten, reproduzierbaren Netzwerkangriffsszenarien in einer kontrollierten Laborumgebung?

| Teilfrage | Inhalt |
|---|---|
| **RQ1** | Wie unterscheiden sich die drei Systeme in ihrer Detektionsleistung bei identischen Angriffsszenarien? |
| **RQ2** | Lässt sich aus den Messdaten eine belastbare Bewertungsmatrix für einen strukturierten Vergleich ableiten? |
| **RQ3** | Wie unterscheiden sich die Systeme bei CPU-/RAM-Auslastung und praktischer Benutzbarkeit? |

## Laborumgebung

Alle Systeme laufen als VMs in **VirtualBox**. Angreifer, Ziele und Sensor sind strikt getrennt; der Testverkehr läuft ausschließlich über ein internes **Host-Only-Netz**, das NAT-Netz dient nur für Updates und Paketinstallationen.

```mermaid
flowchart LR
    subgraph HO["Host-Only-Netz 192.168.56.0/24 (Testverkehr)"]
        K["Kali Linux 2025.4<br/>Angreifer<br/>192.168.56.102"]
        W["Windows 11 (64-bit)<br/>Ziel 1<br/>192.168.56.103"]
        U["Ubuntu 26.04 (64-bit)<br/>Ziel 2<br/>192.168.56.105"]
        S["Debian 13.4 Sensor<br/>Snort · Suricata · Zeek<br/>192.168.56.104 (enp0s3)"]
    end
    K -- "Scans / Exploits" --> W
    K -- "Scans / Baseline" --> U
    S -. "passives Mitlesen" .- K
    S -. "passives Mitlesen" .- W
    S -. "passives Mitlesen" .- U
    NAT(("NAT-Netz<br/>Internet / Updates")) --- K & W & U & S
```

| Rolle | System | Host-Only-IP | Werkzeuge |
|---|---|---|---|
| Angreifer | Kali Linux 2025.4 | `192.168.56.102` | Metasploit, Nmap, tcpdump, TShark |
| Ziel 1 (Fokus) | Windows 11, 64-bit | `192.168.56.103` | SMB-Dienst auf Port 445 |
| Ziel 2 (Baseline) | Ubuntu 26.04, 64-bit | `192.168.56.105` | – |
| Sensor | Debian 13.4, 64-bit | `192.168.56.104` | Snort 3, Suricata, Zeek 9.0.0-dev |

Die drei IDS laufen **nacheinander** auf derselben Sensor-VM und beobachten damit identischen bzw. vergleichbaren Verkehr. Details: [`docs/labor-setup.md`](docs/labor-setup.md) · [`docs/network-plan.md`](docs/network-plan.md)

## Methodik

Kombination aus Literaturrecherche und quantitativem Experiment. Für jeden Testfall wird dasselbe [Bewertungsschema](docs/detection-schema.md) angewendet:

1. **Alert ausgelöst?** – wichtigstes Kriterium
2. **Verdächtiger Log-Eintrag vorhanden?** – relevant v. a. für Zeek, das kaum klassische Alerts erzeugt
3. **Zeitverhalten** – Echtzeit, verzögert oder erst nachträglich in Logs sichtbar

Ergänzend werden CPU/RAM sowie Installations-/Konfigurationsaufwand, Analysierbarkeit, Dokumentation und Benutzbarkeit (Skala 1–5) bewertet.

**Konfigurationsphasen:** zuerst standardnahe Konfiguration, danach gezielt ergänzte lokale Regeln (`local.rules`), damit Test-Scans im Host-Only-Netz nachvollziehbar alarmiert werden. Alle verwendeten Konfigurationen liegen unter [`configs/`](configs/).

**Getestete Szenarien**

| ID | Szenario | Ziel | Werkzeug |
|---|---|---|---|
| B-01 | Ping / Host Discovery (`nmap -sn`) | Windows, Ubuntu | Nmap |
| B-02 | Service-Scan (`nmap -sV`) | Windows, Ubuntu | Nmap |
| S-01 | TCP-SYN-Scan (`nmap -sS`) | Windows, Ubuntu | Nmap |
| W-01 | MS17-010 EternalBlue (Probe/Check) gegen SMB 445 | Windows | Metasploit |
| W-02 | SMB-Authentifizierung via `psexec` (NTLM) gegen SMB 445 | Windows | Metasploit |

Ziel war **nicht** die erfolgreiche Kompromittierung, sondern die Frage, ob und wie der Angriffsverkehr erkannt wird. Beide Windows-Exploits schlugen fehl (keine Session, `STATUS_ACCESS_DENIED`) – hinterließen aber auswertbare Spuren im Netz. Siehe [`docs/exploit-list.md`](docs/exploit-list.md) und [`docs/testplan.md`](docs/testplan.md).

## Ergebnisse

Ausführliche Auswertung pro System: [`docs/results.md`](docs/results.md) · Rohtabellen als CSV: [`results/tables/`](results/tables/)

### 1. TCP-SYN-Scan (Reconnaissance)

| Kriterium | Suricata | Snort | Zeek |
|---|---|---|---|
| Alert ausgelöst | ✅ Ja – lokale Regel | ✅ Ja – lokale Regel | ➖ Kein klassischer Alert |
| Sichtbarkeit | `fast.log` + `eve.json` | `alert_fast` im Terminal | `conn.log` (strukturiert) |
| Alert-Qualität | > 2000 Einzel-Events, zusätzl. Hintergrund-Alert (DHCP) | viele Einzelmeldungen je Zielport | klare Verbindungsprotokolle, `conn_state` `REJ`/`RSTO` |
| Verdichtung | 🔴 gering – jedes Paket einzeln | 🔴 gering – jeder Port einzeln | 🟢 hoch – tabellarisch |

**Erkenntnis:** Signaturbasierte IDS „schreien“ bei breiten Scans sehr laut – erkannt wird zuverlässig, die Ausgabe ist ohne Thresholding aber kaum noch lesbar. Zeek fasst denselben Scan als nachvollziehbare Verbindungstabelle zusammen.

### 2. Windows – exploitnahes SMB-Szenario

| Kriterium | Suricata | Snort | Zeek |
|---|---|---|---|
| Alert (W-01 EternalBlue) | ✅ lokale TCP-Regel, SMB 445 | ✅ 2 Alerts, lokale TCP-Regel 445 | ➖ kein Alert |
| Alert (W-02 psexec/NTLM) | ✅ TCP-Regel **+ NTLM-Alerts** (Negotiate, Challenge, Auth) | ✅ 1 Alert, lokale TCP-Regel 445 | ➖ kein Alert |
| Verdächtige Log-Einträge | `fast.log`, `eve.json` | `alert_fast` | `conn.log` (W-01), `conn.log` + **`ntlm.log`** (W-02) |
| Protokolltiefe | 🟢 hoch – NTLM-Phasen sichtbar | 🔴 gering – nur TCP-Regel | 🟡 mittel–hoch |
| Alert-Menge | moderat | sehr gering (1–2 je Lauf) | keine – strukturierte Logs |
| Zeitverhalten | Echtzeit | Echtzeit | Echtzeit (Auswertung nach dem Lauf) |
| Hintergrund-Alerts | ja (Kali-Hostname im DHCP-Request) | nein | nein |

**Erkenntnis:** Bei gezielten Exploit-Versuchen sinkt die Alert-Menge deutlich und die Ergebnisse werden gut interpretierbar. Suricata und Zeek dekodieren das SMB-/NTLM-Protokoll und machen die Phasen des fehlgeschlagenen Logins sichtbar; Snort erkennt den Zugriff, bleibt aber auf die lokale TCP-Regel beschränkt.

### 3. Ressourcenverbrauch

Beobachtungswerte des IDS-Prozesses auf der Sensor-VM (`ps`/`top` während des Laufs):

| Szenario | Metrik | Suricata | Snort | Zeek |
|---|---|---:|---:|---:|
| SYN-Scan | CPU | ~5,0 % | ~6,1 % | **~1,3 %** |
| SYN-Scan | MEM | ~11,0 % | **~0,8 %** | ~5,2 % |
| SYN-Scan | RSS | 557.584 KB | **43.796 KB** | 265.544 KB |
| Windows W-01 | CPU | ~15,4 % | ~6,0 % | **~1,3 %** |
| Windows W-01 | MEM | ~10,6 % | **~0,8 %** | ~5,1 % |
| Windows W-02 | CPU | zweistellig | ~6,0 % | **~0,8 %** |
| Windows W-02 | MEM | ~10,6 % | **~0,8 %** | ~5,1 % |

- **Snort**: mit Abstand geringster Speicherbedarf (~44 MB RSS)
- **Zeek**: niedrigste CPU-Last, Speicher im Mittelfeld
- **Suricata**: höchster Speicherbedarf (~0,5 GB RSS) und bei Exploits zweistellige CPU-Last

### 4. Bewertungsmatrix (qualitativ, Skala 1–5)

`1` = sehr ungünstig/aufwändig · `3` = akzeptabel · `5` = sehr günstig/einfach

| Kriterium | Suricata | Snort | Zeek | Begründung |
|---|:---:|:---:|:---:|---|
| Installationsaufwand | **5** | 3 | 2 | Suricata per `apt` ~20 min · Snort aus Quellcode ~30 min · Zeek aus Quellcode > 90 min (allein `make` ~70 min) |
| Konfigurationsaufwand | 3 | 3 | **4** | Suricata: Standardregeln + einfache lokale Ergänzung · Snort: lokale Regeldatei nötig · Zeek: keine Regeln nötig |
| Analysierbarkeit | 3 | 2 | **4** | Suricata: `fast.log` + `eve.json` · Snort: unübersichtlich bei vielen Alerts · Zeek: strukturierte Logs |
| Dokumentation / Community | **5** | 4 | 4 | docs.suricata.io · snort.org + große Community · docs.zeek.org |
| Praktische Benutzbarkeit | **5** | 4 | 3 | Suricata sofort einsatzbereit · Snort direkt, aber regelabhängig · Zeek erfordert aktive Log-Analyse |
| **Summe** | **21** | **16** | **17** | |

## Fazit und Empfehlung

| Wenn du … brauchst | dann nimm | weil |
|---|---|---|
| reichhaltige, protokollbewusste **Alerts** und schnellen Einstieg | **Suricata** | differenzierteste Alarmierung (z. B. NTLM-Phasen), `eve.json` für SIEM, Installation per Paketmanager |
| **schlanke**, direkte Alarmierung auf schwacher Hardware | **Snort** | geringster RAM-Bedarf, Alerts sofort im Terminal – Aussagekraft hängt aber stark von der Regelbasis ab |
| **Forensik** / Network Security Monitoring, Nachvollziehen ganzer Abläufe | **Zeek** | strukturierte, kompakte Logs (`conn.log`, `ntlm.log`, …) bei niedrigster CPU-Last – ohne eigene Skripte aber keine Alerts |

Die Systeme ergänzen sich eher, als dass sie sich ersetzen: Eine Kombination aus **Suricata (Alarmierung) + Zeek (Kontext/Forensik)** deckt in der Praxis beide Seiten ab.

## Versuche reproduzieren

> ⚠️ Nur in einer isolierten Laborumgebung ausführen. Die Angriffe richten sich ausschließlich gegen eigene Test-VMs.

```bash
# 1. Repo auf der Sensor-VM klonen und Ergebnisordner anlegen
git clone https://github.com/if23b152/Bachelorarbeit-ids.git && cd Bachelorarbeit-ids
./scripts/setup/prepare_dirs.sh

# 2. IDS-Konfiguration übernehmen (Beispiel Suricata)
sudo cp configs/suricata/local.rules /var/lib/suricata/rules/local.rules
sudo suricata -T -c /etc/suricata/suricata.yaml          # Konfiguration prüfen

# 3. IDS auf dem Host-Only-Interface starten (jeweils nur EIN IDS gleichzeitig)
sudo suricata -c /etc/suricata/suricata.yaml -i enp0s3
#   sudo snort -c configs/snort/snort.lua -R configs/snort/local.rules -i enp0s3 -A alert_fast
#   sudo zeek -i enp0s3 configs/zeek/local.zeek     (im Ausgabeordner, z. B. /opt/zeek-win-test1)

# 4. parallel: Ressourcen messen und Verkehr mitschneiden
./scripts/evaluation/measure_resources.sh suricata 60
sudo ./scripts/capture/start_tcpdump.sh enp0s3

# 5. auf Kali: Szenario ausführen (siehe docs/exploit-list.md)
#   nmap -sS 192.168.56.103

# 6. Logs einsammeln und Alerts zählen
sudo ./scripts/capture/collect_logs.sh
./scripts/evaluation/count_alerts.sh
```

Jeder Lauf wird mit [`templates/test_result_template.md`](templates/test_result_template.md) dokumentiert.

## Repository-Struktur

```text
Bachelorarbeit-ids/
├── configs/            IDS-Konfigurationen und lokale Regeln
│   ├── snort/          snort.lua (Minimalkonfig) + local.rules
│   ├── suricata/       local.rules + Hinweise zu suricata.yaml
│   └── zeek/           local.zeek + Hinweise zu Logs
├── docs/               Laboraufbau, Netzplan, Testplan, Exploit-Liste,
│                       Bewertungsschema und ausführliche Ergebnisse
├── results/
│   ├── raw/            Rohdaten (PCAPs/Logs bleiben lokal) und Screenshots
│   └── tables/         Ergebnistabellen als CSV
├── scripts/
│   ├── setup/          Ordnerstruktur vorbereiten
│   ├── capture/        tcpdump-Mitschnitt, Logs einsammeln
│   └── evaluation/     Ressourcen messen, Alerts zählen
├── templates/          Vorlagen für Testfälle und Testergebnisse
└── thesis/             Gliederung und Arbeitsnotizen
```

## Grenzen und Ausblick

- Detaillierte Exploit-Auswertung nur für das **Windows-Ziel**; Ubuntu wurde für Aufbau und Baseline genutzt.
- Wenige Wiederholungen pro Testfall; CPU/RAM sind **Beobachtungswerte**, keine standardisierten Messreihen.
- Aussagekraft von Snort/Suricata hängt stark vom Regelstand ab – lokale Testregeln sind keine vollständige Abbildung realer Angriffe.

Mögliche Erweiterungen: Exploit-Szenarien gegen Linux, systematischer Vergleich Default- vs. angepasste Regeln (inkl. Thresholding), Zeek-Skripte/Notice-Framework, mehr Wiederholungen, Payload-Delivery und mehrstufige Angriffe.
