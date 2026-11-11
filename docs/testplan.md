# Test plan

## Principles

- one test after another, always with **only one** active IDS on the sensor
- before every run: VM snapshot, restart the IDS, create a new log folder
- clear separation between attack target and measurement system
- every run is documented with [`test_result_template.md`](../templates/test_result_template.md)

## Phases

| Phase | Content | Status |
|---|---|---|
| 1 – Baseline | ping, `nmap -sn`, `nmap -sV`, packet capture on Kali and the sensor | ✅ done |
| 2 – Integration | install Suricata, Snort, Zeek; local test rules for ICMP and TCP SYN | ✅ done |
| 3 – Reconnaissance | TCP SYN scan against Windows and Ubuntu, all three IDS | ✅ done |
| 4 – Windows exploits | W-01 EternalBlue probe, W-02 SMB psexec, all three IDS | ✅ done |
| 5 – Linux exploits | comparable scenarios against Ubuntu | ⏳ outlook |
| 6 – Custom configuration | default vs. custom rules, thresholding, Zeek notices | ⏳ outlook |

## Flow of a measurement run

```text
Sensor:  start IDS  ──►  measure_resources.sh  ──►  (optional) start_tcpdump.sh
Kali:                    run scenario
Sensor:  stop IDS   ──►  collect_logs.sh  ──►  count_alerts.sh  ──►  document result
```

Scenarios: [exploit-list.md](exploit-list.md) · Evaluation: [detection-schema.md](detection-schema.md) · Results: [results.md](results.md)
