# Zeek

| Eigenschaft | Wert |
|---|---|
| Version | 9.0.0-dev.154 |
| Installation | aus dem Quellcode kompiliert, > 90 min (davon `make` ca. 70 min) |
| Skripte | Standard-Skripte, siehe [`local.zeek`](local.zeek); keine eigenen Detektionsskripte |
| Interface | `enp0s3` (Host-Only) |
| Logpfad | eigener Ordner pro Lauf, z. B. `/opt/zeek-win-test1`, `/opt/zeek-win-test2` |

## Einrichtung (Kurzfassung)

```bash
sudo apt install cmake make gcc g++ flex bison libpcap-dev libssl-dev \
     python3-dev swig zlib1g-dev
git clone --recursive https://github.com/zeek/zeek && cd zeek
./configure --prefix=/opt/zeek && make -j"$(nproc)" && sudo make install
export PATH=/opt/zeek/bin:$PATH
```

```bash
sudo mkdir -p /opt/zeek-win-test1 && cd /opt/zeek-win-test1
sudo zeek -i enp0s3 /pfad/zu/configs/zeek/local.zeek
# Auswertung
zeek-cut ts id.orig_h id.resp_h id.resp_p proto conn_state < conn.log
```

## Erzeugte Logs

| Lauf | Dateien |
|---|---|
| Baseline / SYN-Scan | `conn.log`, `dhcp.log`, `dns.log`, `packet_filter.log`, `reporter.log` |
| Windows W-01 (EternalBlue) | `conn.log`, `dhcp.log`, `dns.log`, `packet_filter.log`, `reporter.log` |
| Windows W-02 (psexec) | `conn.log`, `dhcp.log`, **`ntlm.log`**, `packet_filter.log`, `reporter.log` |

Ein `notice.log` entstand in keinem Lauf – Zeek erzeugt ohne zusätzliche Skripte keine Alerts.

## Beobachtungen

- SYN-Scan im `conn.log` über `conn_state` `REJ`/`RSTO` klar erkennbar – kompakt statt tausender Alerts.
- `ntlm.log` macht den fehlgeschlagenen SMB-Login auf Protokollebene nachvollziehbar.
- Niedrigste CPU-Last (0,8–1,3 %), Speicher ~5 % (~260 MB RSS).
