# Detailed results

Summary: see the [README](../README.md#results). Raw tables as CSV in [`results/tables/`](../results/tables/).

All values were recorded on the Debian sensor VM (`192.168.56.104`, interface `enp0s3`). Only **one** IDS was active per run. CPU/RAM are observed values of the IDS process (`ps`/`top`) during active sensor operation.

---

## 0. Installation and setup

| IDS | Method | Duration | Note |
|---|---|---|---|
| Suricata | Debian package | ~20 min | straightforward, rule base via `suricata-update` |
| Snort 3 | from source | > 30 min | no usable package for Debian 13 |
| Zeek 9.0.0-dev | from source | > 90 min | `make` alone ~70 min |

**Baseline:** the sensor correctly captures ARP, ICMP and TCP traffic between Kali and both targets (`tcpdump` + `tshark`). Windows does not answer SYN packets (all ports `filtered`), Ubuntu answers with `RST/ACK` (ports `closed`) – the different response behaviour is already visible in the capture.

---

## 1. TCP SYN scan (`nmap -sS`)

### Suricata
- The local rule `LOCAL TCP SYN scan from Kali to victim` produces many entries in `fast.log` (Kali `.102` → Ubuntu `.105`, many target ports).
- `eve.json` contains **> 2000 alert events** for a single scan scenario → very sensitive, but barely aggregated.
- Additional background alert: `ET INFO Possible Kali Linux hostname in DHCP Request Packet` – not every alert belongs to the test case.
- Resources: CPU ~5.0 %, MEM ~11.0 %, RSS 557,584 KB, VSZ 1,073,332 KB

### Snort
- The same local rule fires repeatedly in `alert_fast` mode (Kali `.102` → Windows `.103`, many target ports).
- No summarising alert, but one message per port → long and cluttered for large scans.
- Resources: CPU ~6.1 %, MEM ~0.8 %, RSS 43,796 KB, VSZ 127,012 KB

### Zeek
- No alert, but many entries in `conn.log` (Kali `.102` → Windows `.103`, spread over many ports).
- The `conn_state` field (`REJ`, `RSTO`) shows rejected or reset connection attempts – the scan is immediately recognisable as a pattern.
- Resources: CPU ~1.3 %, MEM ~5.2 %, RSS 265,544 KB, VSZ 1,192,132 KB

---

## 2. Windows – exploit-oriented scenario (SMB, port 445)

| Test | Attack | Result on the target |
|---|---|---|
| W-01 | Metasploit `MS17-010 EternalBlue` (probe/check) | no access, no session |
| W-02 | Metasploit SMB `psexec` with username/password (NTLM) | `STATUS_ACCESS_DENIED`, no session |

### Suricata
- **W-01:** SMB-related connection attempts to the target are logged; the alert volume is much smaller than for the SYN scan and clearly attributable to the scenario.
- **W-02:** besides the local TCP alert on port 445, several **NTLM alerts** appear:
  NTLM session setup request (negotiate) → NTLMv1 session setup response (challenge) → NTLM session setup request (authenticate).
  This makes the failed login traceable at protocol level.
- Again a DHCP background alert (Kali hostname).
- Resources: CPU ~15.4 %, MEM ~10.6 %, RSS 536,612 KB, VSZ 1,055,836 KB

### Snort
- **W-01:** 2 alerts of the local TCP rule for `192.168.56.102 → 192.168.56.103:445`; statistics: 2 alerts, 2 logged events.
- **W-02:** 1 alert of the same rule; statistics: 1 alert, 1 logged event.
- Very compact and directly in the terminal, but without SMB/NTLM breakdown – its value depends on the rule base.
- Resources (both runs): CPU ~6.0 %, MEM ~0.8 %, RSS 43,964 KB, VSZ 127,012 KB

### Zeek
- **W-01** (`/opt/zeek-win-test1`): `conn.log`, `dhcp.log`, `dns.log`, `packet_filter.log`, `reporter.log`. Connections Kali → Windows on `445/tcp` in `conn.log`.
- **W-02** (`/opt/zeek-win-test2`): additionally **`ntlm.log`** – the authentication attempt is logged in a structured way.
- No alerts; analysis is done actively through the logs.
- Resources: W-01 CPU ~1.3 %, MEM ~5.1 %, RSS 261,088 KB · W-02 CPU ~0.8 %, MEM ~5.1 %, RSS 260,988 KB

---

## 3. Overall comparison

| | Suricata | Snort | Zeek |
|---|---|---|---|
| Approach | signature/rule-based + protocol parsers | signature/rule-based | protocol/event-oriented |
| Form of detection | alert | alert | structured log entry |
| Strength | most differentiated alerts | most compact alerting, minimal RAM | most structured traceability, minimal CPU |
| Weakness | highest RAM, alert flood during scans, background alerts | little protocol depth, rule-dependent | no alerts without scripts, laborious installation |

## 4. Answers to the research questions

- **RQ1 – detection performance:** all three systems made the SYN scan and both SMB exploit attempts visible – Suricata and Snort as alerts, Zeek as analysable log entries. The differences lie less in *whether* than in *how* (form, volume, protocol depth).
- **RQ2 – evaluation matrix:** a matrix is useful and necessary, because comprehensibility, usability and performance matter as well as detection. Result (qualitative total): Suricata 21, Zeek 17, Snort 16.
- **RQ3 – resources/usability:** Snort with the lowest memory usage, Zeek with the lowest CPU load, Suricata the most resource-intensive but the fastest to get running.
