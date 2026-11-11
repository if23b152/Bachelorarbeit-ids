# Snort 3

| Eigenschaft | Wert |
|---|---|
| Installation | aus dem Quellcode kompiliert (kein nutzbares Paket für Debian 13), > 30 min |
| Konfiguration | reduzierte Minimalkonfiguration [`snort.lua`](snort.lua), `HOME_NET = 192.168.56.0/24` |
| Regeln | [`local.rules`](local.rules) – ICMP-Echo und TCP-SYN von Kali auf die Ziele |
| Interface | `enp0s3` (Host-Only) |
| Ausgabe | `alert_fast` direkt im Terminal |

## Einrichtung (Kurzfassung)

```bash
# Abhängigkeiten
sudo apt install build-essential cmake libpcap-dev libpcre2-dev libdumbnet-dev \
     libhwloc-dev libluajit-5.1-dev libssl-dev zlib1g-dev pkg-config flex bison

# libdaq und Snort 3 aus dem Quellcode
git clone https://github.com/snort3/libdaq.git && cd libdaq
./bootstrap && ./configure && make && sudo make install && cd ..
git clone https://github.com/snort3/snort3.git && cd snort3
./configure_cmake.sh --prefix=/usr/local && cd build && make -j"$(nproc)" && sudo make install
sudo ldconfig
```

```bash
# Konfiguration prüfen und Sensor starten
snort -c snort.lua -R local.rules -T
sudo snort -c snort.lua -R local.rules -i enp0s3 -A alert_fast
```

> `snort.lua` bindet `snort_defaults.lua` aus der Installation ein. Ggf. mit `--include-path /usr/local/etc/snort` starten.

## Beobachtungen

- SYN-Scan: viele Einzelmeldungen (eine pro Zielport) – direkt sichtbar, bei großen Scans aber unübersichtlich.
- ICMP-Regel: Alert im Testlauf nur verzögert sichtbar, daher nicht als Echtzeit-Erkennung gewertet.
- SMB-Exploits (Port 445): 2 bzw. 1 Alert pro Lauf – sehr kompakt, aber ohne Protokollaufschlüsselung.
- Geringster Ressourcenbedarf: ~6 % CPU, ~0,8 % RAM (~44 MB RSS).
