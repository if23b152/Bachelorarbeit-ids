# Ergebnisse im Detail

Zusammenfassung siehe [README](../README.md#ergebnisse). Rohtabellen als CSV unter [`results/tables/`](../results/tables/).

Alle Werte stammen von der Debian-Sensor-VM (`192.168.56.104`, Interface `enp0s3`). Pro Lauf war immer nur **ein** IDS aktiv. CPU/RAM sind Beobachtungswerte des IDS-Prozesses (`ps`/`top`) während des aktiven Sensorbetriebs.

---

## 0. Installation und Einrichtung

| IDS | Weg | Dauer | Bemerkung |
|---|---|---|---|
| Suricata | Debian-Paket | ~20 min | direkt, Regelbasis per `suricata-update` |
| Snort 3 | Quellcode | > 30 min | kein nutzbares Paket für Debian 13 |
| Zeek 9.0.0-dev | Quellcode | > 90 min | `make` allein ~70 min |

**Baseline:** Der Sensor schneidet ARP-, ICMP- und TCP-Verkehr zwischen Kali und beiden Zielen korrekt mit (`tcpdump` + `tshark`). Windows antwortet auf SYN-Pakete nicht (alle Ports `filtered`), Ubuntu antwortet mit `RST/ACK` (Ports `closed`) – das unterschiedliche Antwortverhalten ist bereits im Mitschnitt sichtbar.

---

## 1. TCP-SYN-Scan (`nmap -sS`)

### Suricata
- Lokale Regel `LOCAL TCP SYN scan from Kali to victim` löst zahlreiche Einträge in `fast.log` aus (Kali `.102` → Ubuntu `.105`, viele Zielports).
- `eve.json` enthält **> 2000 Alert-Events** für ein einziges Scan-Szenario → sehr empfindlich, aber kaum verdichtet.
- Zusätzlicher Hintergrund-Alert: `ET INFO Possible Kali Linux hostname in DHCP Request Packet` – nicht jeder Alert gehört zum Testfall.
- Ressourcen: CPU ~5,0 %, MEM ~11,0 %, RSS 557.584 KB, VSZ 1.073.332 KB

### Snort
- Dieselbe lokale Regel feuert mehrfach im `alert_fast`-Modus (Kali `.102` → Windows `.103`, viele Zielports).
- Kein zusammenfassender Alarm, sondern eine Meldung pro Port → bei großen Scans lang und unübersichtlich.
- Ressourcen: CPU ~6,1 %, MEM ~0,8 %, RSS 43.796 KB, VSZ 127.012 KB

### Zeek
- Kein Alert, aber zahlreiche Einträge im `conn.log` (Kali `.102` → Windows `.103`, verteilt auf viele Ports).
- Das Feld `conn_state` (`REJ`, `RSTO`) zeigt abgewiesene bzw. per Reset beantwortete Verbindungsversuche – der Scan ist als Muster sofort erkennbar.
- Ressourcen: CPU ~1,3 %, MEM ~5,2 %, RSS 265.544 KB, VSZ 1.192.132 KB

---

## 2. Windows – exploitnahes Szenario (SMB, Port 445)

| Test | Angriff | Ergebnis am Ziel |
|---|---|---|
| W-01 | Metasploit `MS17-010 EternalBlue` (Probe/Check) | kein Zugriff, keine Session |
| W-02 | Metasploit SMB `psexec` mit Benutzername/Passwort (NTLM) | `STATUS_ACCESS_DENIED`, keine Session |

### Suricata
- **W-01:** SMB-bezogene Verbindungsversuche zum Ziel werden protokolliert; Alert-Menge deutlich kleiner als beim SYN-Scan und gut dem Szenario zuordenbar.
- **W-02:** Neben dem lokalen TCP-Alert auf Port 445 erscheinen mehrere **NTLM-Alerts**:
  NTLM Session Setup Request (Negotiate) → NTLMv1 Session Setup Response (Challenge) → NTLM Session Setup Request (Authenticate).
  Der fehlgeschlagene Login wird damit auf Protokollebene nachvollziehbar.
- Erneut DHCP-Hintergrund-Alert (Kali-Hostname).
- Ressourcen: CPU ~15,4 %, MEM ~10,6 %, RSS 536.612 KB, VSZ 1.055.836 KB

### Snort
- **W-01:** 2 Alerts der lokalen TCP-Regel für `192.168.56.102 → 192.168.56.103:445`; Statistik: 2 Alerts, 2 geloggte Events.
- **W-02:** 1 Alert derselben Regel; Statistik: 1 Alert, 1 geloggtes Event.
- Sehr kompakt und direkt im Terminal, aber ohne SMB-/NTLM-Aufschlüsselung – Aussagekraft hängt an der Regelbasis.
- Ressourcen (beide Läufe): CPU ~6,0 %, MEM ~0,8 %, RSS 43.964 KB, VSZ 127.012 KB

### Zeek
- **W-01** (`/opt/zeek-win-test1`): `conn.log`, `dhcp.log`, `dns.log`, `packet_filter.log`, `reporter.log`. Verbindungen Kali → Windows auf `445/tcp` im `conn.log`.
- **W-02** (`/opt/zeek-win-test2`): zusätzlich **`ntlm.log`** – der Authentifizierungsversuch wird strukturiert protokolliert.
- Keine Alerts; die Auswertung erfolgt aktiv über die Logs.
- Ressourcen: W-01 CPU ~1,3 %, MEM ~5,1 %, RSS 261.088 KB · W-02 CPU ~0,8 %, MEM ~5,1 %, RSS 260.988 KB

---

## 3. Gesamtvergleich

| | Suricata | Snort | Zeek |
|---|---|---|---|
| Arbeitsweise | signatur-/regelbasiert + Protokoll-Parser | signatur-/regelbasiert | protokoll-/ereignisorientiert |
| Erkennungsform | Alert | Alert | strukturierter Log-Eintrag |
| Stärke | inhaltlich differenzierteste Alerts | kompakteste Alarmierung, minimaler RAM | strukturierteste Nachvollziehbarkeit, minimale CPU |
| Schwäche | höchster RAM, Alarmflut bei Scans, Hintergrund-Alerts | wenig Protokolltiefe, regelabhängig | keine Alerts ohne Skripte, aufwändige Installation |

## 4. Antworten auf die Forschungsfragen

- **RQ1 – Detektionsleistung:** Alle drei Systeme haben SYN-Scan und beide SMB-Exploit-Versuche sichtbar gemacht – Suricata und Snort als Alert, Zeek als auswertbaren Log-Eintrag. Unterschiede liegen weniger im *Ob* als im *Wie* (Form, Menge, Protokolltiefe).
- **RQ2 – Bewertungsmatrix:** Eine Matrix ist sinnvoll und notwendig, weil neben der Erkennung auch Verständlichkeit, Nutzbarkeit und Performance zählen. Ergebnis (Summe qualitativ): Suricata 21, Zeek 17, Snort 16.
- **RQ3 – Ressourcen/Benutzbarkeit:** Snort mit geringstem Speicher, Zeek mit geringster CPU-Last, Suricata am ressourcenintensivsten, dafür am schnellsten einsatzbereit.
