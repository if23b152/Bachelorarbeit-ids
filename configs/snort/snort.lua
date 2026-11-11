-- Minimalkonfiguration für Snort 3 im Labornetz
-- Start: sudo snort -c snort.lua -R local.rules -i enp0s3 -A alert_fast

HOME_NET = '192.168.56.0/24'
EXTERNAL_NET = '!$HOME_NET'

-- Standard-Defaults und Inspektoren aus der Snort-Installation übernehmen
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
    -- Regeln werden per -R local.rules übergeben
    enable_builtin_rules = false,
}

-- Kompakte Alert-Ausgabe (eine Zeile pro Alert)
alert_fast = { file = false }
