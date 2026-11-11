# Zeek

| Property | Value |
|---|---|
| Version | 9.0.0-dev.154 |
| Installation | compiled from source, > 90 min (of which `make` approx. 70 min) |
| Scripts | default scripts, see [`local.zeek`](local.zeek); no custom detection scripts |
| Interface | `enp0s3` (host-only) |
| Log path | separate folder per run, e.g. `/opt/zeek-win-test1`, `/opt/zeek-win-test2` |

## Setup (short version)

```bash
sudo apt install cmake make gcc g++ flex bison libpcap-dev libssl-dev \
     python3-dev swig zlib1g-dev
git clone --recursive https://github.com/zeek/zeek && cd zeek
./configure --prefix=/opt/zeek && make -j"$(nproc)" && sudo make install
export PATH=/opt/zeek/bin:$PATH
```

```bash
sudo mkdir -p /opt/zeek-win-test1 && cd /opt/zeek-win-test1
sudo zeek -i enp0s3 /path/to/configs/zeek/local.zeek
# Analysis
zeek-cut ts id.orig_h id.resp_h id.resp_p proto conn_state < conn.log
```

## Generated logs

| Run | Files |
|---|---|
| Baseline / SYN scan | `conn.log`, `dhcp.log`, `dns.log`, `packet_filter.log`, `reporter.log` |
| Windows W-01 (EternalBlue) | `conn.log`, `dhcp.log`, `dns.log`, `packet_filter.log`, `reporter.log` |
| Windows W-02 (psexec) | `conn.log`, `dhcp.log`, **`ntlm.log`**, `packet_filter.log`, `reporter.log` |

No `notice.log` was produced in any run – without additional scripts Zeek does not generate alerts.

## Observations

- SYN scan clearly recognisable in `conn.log` via `conn_state` `REJ`/`RSTO` – compact instead of thousands of alerts.
- `ntlm.log` makes the failed SMB login traceable at protocol level.
- Lowest CPU load (0.8–1.3 %), memory ~5 % (~260 MB RSS).
