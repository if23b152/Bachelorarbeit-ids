# Suricata

| Eigenschaft | Wert |
|---|---|
| Installation | Debian-Paket (`apt install suricata`), ca. 20 min inkl. Regel-Update |
| Regelquellen | `suricata-update` (ET Open) → `/var/lib/suricata/rules/suricata.rules` + [`local.rules`](local.rules) |
| Interface | `enp0s3` (Host-Only, 192.168.56.104) |
| Outputs | `fast.log` (kompakte Alerts), `eve.json` (strukturiert, alle Event-Typen) |
| Logpfad | `/var/log/suricata/` |

## Einrichtung

```bash
sudo apt install suricata
sudo suricata-update                                     # ET-Open-Regeln laden
sudo cp local.rules /var/lib/suricata/rules/local.rules
```

In `/etc/suricata/suricata.yaml`:

```yaml
vars:
  address-groups:
    HOME_NET: "[192.168.56.0/24]"
    EXTERNAL_NET: "!$HOME_NET"

default-rule-path: /var/lib/suricata/rules
rule-files:
  - suricata.rules
  - local.rules

af-packet:
  - interface: enp0s3
```

```bash
sudo suricata -T -c /etc/suricata/suricata.yaml          # Konfiguration testen
sudo suricata -c /etc/suricata/suricata.yaml -i enp0s3   # Sensor starten
tail -f /var/log/suricata/fast.log
jq 'select(.event_type=="alert") | .alert.signature' /var/log/suricata/eve.json | sort | uniq -c
```

## Beobachtungen

- Standardregeln alarmieren interne Ping-/SYN-Tests im Host-Only-Netz nicht zuverlässig → lokale Regeln nötig.
- SYN-Scan: > 2000 Alert-Events in `eve.json` für ein einziges Scan-Szenario (keine Verdichtung).
- Hintergrund-Alert `ET INFO Possible Kali Linux hostname in DHCP Request Packet` tritt unabhängig vom Testfall auf.
- SMB/psexec: zusätzlich NTLM-Alerts (Negotiate, Challenge, Authenticate) aus dem ET-Regelsatz.
