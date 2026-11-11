# Suricata

| Property | Value |
|---|---|
| Installation | Debian package (`apt install suricata`), approx. 20 min incl. rule update |
| Rule sources | `suricata-update` (ET Open) → `/var/lib/suricata/rules/suricata.rules` + [`local.rules`](local.rules) |
| Interface | `enp0s3` (host-only, 192.168.56.104) |
| Outputs | `fast.log` (compact alerts), `eve.json` (structured, all event types) |
| Log path | `/var/log/suricata/` |

## Setup

```bash
sudo apt install suricata
sudo suricata-update                                     # load ET Open rules
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
sudo suricata -T -c /etc/suricata/suricata.yaml          # test the configuration
sudo suricata -c /etc/suricata/suricata.yaml -i enp0s3   # start the sensor
tail -f /var/log/suricata/fast.log
jq 'select(.event_type=="alert") | .alert.signature' /var/log/suricata/eve.json | sort | uniq -c
```

## Observations

- The default rules do not reliably alert internal ping/SYN tests in the host-only network → local rules required.
- SYN scan: > 2000 alert events in `eve.json` for a single scan scenario (no aggregation).
- Background alert `ET INFO Possible Kali Linux hostname in DHCP Request Packet` appears independently of the test case.
- SMB/psexec: additional NTLM alerts (negotiate, challenge, authenticate) from the ET rule set.
