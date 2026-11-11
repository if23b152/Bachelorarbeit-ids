# Zeek configuration for the measurement runs
# Start inside the output folder of the run: sudo zeek -i enp0s3 /path/to/local.zeek

# Default analysis (protocol analysers, conn.log, dns.log, dhcp.log, ...)
@load base/frameworks/notice

# SMB and NTLM analysis for the Windows scenario (ntlm.log, smb_*.log)
@load base/protocols/smb
@load base/protocols/ntlm

# Optional (not active in the measurement runs): scan detection via the notice framework
# @load misc/scan
# redef Scan::port_scan_threshold = 25;
