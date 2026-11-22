# Suricata

| Property | Value |
|---|---|
| Installation | Debian package via `apt`, approx. 20 min |
| Rules | `/var/lib/suricata/rules/suricata.rules` (50,145 rules loaded) and the local file [`local-bachelor.rules`](local-bachelor.rules), as shown in the thesis |
| Interface | `enp0s3` (host-only) |
| Outputs | `fast.log` (compact alerts), `eve.json` (structured) in `/var/log/suricata/` |

## Start

```bash
sudo suricata -D -c /etc/suricata/suricata.yaml -i enp0s3
sudo tail -n 15 /var/log/suricata/fast.log
grep -c '"event_type":"alert"' /var/log/suricata/eve.json
```

The local file has to be listed under `rule-files` in `/etc/suricata/suricata.yaml`. The complete `suricata.yaml` is not part of this repository.

## Observations

- The default rules did not alert all relevant internal ping and scan tests, so local rules were added.
- SYN scan: > 2000 alert events in `eve.json` for a single scan scenario.
- Background alert `ET INFO Possible Kali Linux hostname in DHCP Request Packet` appears independently of the test case.
- W-02 (psexec): additional NTLM-related alerts (negotiate, challenge, authenticate).
