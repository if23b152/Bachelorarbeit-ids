# Snort 3

| Property | Value |
|---|---|
| Installation | compiled from source (no usable package for Debian 13), > 30 min |
| Configuration | reduced minimal configuration [`snort.lua`](snort.lua), `HOME_NET = 192.168.56.0/24` |
| Rules | [`local.rules`](local.rules) – ICMP echo and TCP SYN from Kali to the targets |
| Interface | `enp0s3` (host-only) |
| Output | `alert_fast` directly in the terminal |

## Setup (short version)

```bash
# Dependencies
sudo apt install build-essential cmake libpcap-dev libpcre2-dev libdumbnet-dev \
     libhwloc-dev libluajit-5.1-dev libssl-dev zlib1g-dev pkg-config flex bison

# libdaq and Snort 3 from source
git clone https://github.com/snort3/libdaq.git && cd libdaq
./bootstrap && ./configure && make && sudo make install && cd ..
git clone https://github.com/snort3/snort3.git && cd snort3
./configure_cmake.sh --prefix=/usr/local && cd build && make -j"$(nproc)" && sudo make install
sudo ldconfig
```

```bash
# Check the configuration and start the sensor
snort -c snort.lua -R local.rules -T
sudo snort -c snort.lua -R local.rules -i enp0s3 -A alert_fast
```

> `snort.lua` includes `snort_defaults.lua` from the installation. If needed, start with `--include-path /usr/local/etc/snort`.

## Observations

- SYN scan: many individual messages (one per target port) – directly visible, but cluttered for large scans.
- ICMP rule: alert only visible with a delay in the test run, so it was not counted as real-time detection.
- SMB exploits (port 445): 2 and 1 alert per run – very compact, but without protocol breakdown.
- Lowest resource usage: ~6 % CPU, ~0.8 % RAM (~44 MB RSS).
