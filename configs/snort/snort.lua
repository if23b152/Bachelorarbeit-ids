-- Minimal Snort 3 configuration for the lab network
-- Start: sudo snort -c snort.lua -R local.rules -i enp0s3 -A alert_fast

HOME_NET = '192.168.56.0/24'
EXTERNAL_NET = '!$HOME_NET'

-- Use the default settings and inspectors from the Snort installation
include 'snort_defaults.lua'

stream = { }
stream_ip = { }
stream_icmp = { }
stream_tcp = { }
stream_udp = { }

normalizer = { }
wizard = default_wizard

ips =
{
    variables = default_variables,
    -- Rules are passed with -R local.rules
    enable_builtin_rules = false,
}

-- Compact alert output (one line per alert)
alert_fast = { file = false }
