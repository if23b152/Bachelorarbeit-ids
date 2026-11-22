# Zeek

| Property | Value |
|---|---|
| Version | 9.0.0-dev.154 |
| Installation | compiled from source, > 90 min (of which `make` approx. 70 min), installed in `/usr/local/zeek` |
| Scripts | started without any custom script |
| Interface | `enp0s3` (host-only) |
| Log path | the working directory: `/opt/zeek-test`, `/opt/zeek-win-test1`, `/opt/zeek-win-test2` |

## Start

```bash
cd /opt/zeek-win-test1
sudo /usr/local/zeek/bin/zeek -i enp0s3
```

For building Zeek see the [official documentation](https://docs.zeek.org/en/current/building-from-source.html).

## Generated logs

| Run | Files mentioned in the thesis |
|---|---|
| First test (ping / SYN scan) | `conn.log`, `dhcp.log`, `dns.log`, `packet_filter.log`, `reporter.log` (no `notice.log`) |
| W-01 (EternalBlue) | among others `conn.log`, `dhcp.log`, `dns.log`, `packet_filter.log`, `reporter.log` |
| W-02 (psexec) | among others `conn.log`, `dhcp.log`, **`ntlm.log`**, `packet_filter.log`, `reporter.log` |

## Observations

- The SYN scan is visible in `conn.log` through the connection states instead of a long list of alerts.
- `ntlm.log` makes the failed SMB login traceable at protocol level.
- Lowest CPU load (0.8–1.3 %), memory ~5 % (~260 MB RSS).
