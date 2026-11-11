# Zeek-Konfiguration für die Messläufe
# Start im jeweiligen Ausgabeordner: sudo zeek -i enp0s3 /pfad/zu/local.zeek

# Standard-Analyse (Protokoll-Analyzer, conn.log, dns.log, dhcp.log, ...)
@load base/frameworks/notice

# SMB- und NTLM-Analyse für das Windows-Szenario (ntlm.log, smb_*.log)
@load base/protocols/smb
@load base/protocols/ntlm

# Optional (nicht in den Messläufen aktiv): Scan-Erkennung über das Notice-Framework
# @load misc/scan
# redef Scan::port_scan_threshold = 25;
