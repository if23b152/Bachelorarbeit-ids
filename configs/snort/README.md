# Snort 3

| Property | Value |
|---|---|
| Installation | compiled from source (no directly usable package for Debian 13), > 30 min |
| Configuration | `/usr/local/etc/snort.lua`: [`snort.lua`](snort.lua), as shown in the thesis |
| Rules | `/usr/local/etc/rules/local.rules`: [`local.rules`](local.rules), as shown in the thesis |
| Interface | `enp0s3` (host-only) |
| Output | `alert_fast` directly in the terminal |

## Start

```bash
sudo snort -c /usr/local/etc/snort.lua -R /usr/local/etc/rules/local.rules -i enp0s3 -A alert_fast
```

For building Snort 3 see the [official repository](https://github.com/snort3/snort3).

## Observations

- SYN scan: many individual messages (one per target port) – directly visible, but long and cluttered for large scans.
- ICMP rule: alert only visible with a delay in the test run, so it was not counted as real-time detection.
- Windows tests (port 445): 2 alerts in W-01, 1 alert in W-02 – compact, but without protocol breakdown.
- Lowest memory usage: ~6 % CPU, ~0.8 % RAM (~44 MB RSS).
