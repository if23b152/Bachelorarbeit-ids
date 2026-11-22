HOME_NET = '192.168.56.0/24'
EXTERNAL_NET = 'any'

ips =
{
    variables =
    {
        nets =
        {
            HOME_NET = HOME_NET,
            EXTERNAL_NET = EXTERNAL_NET
        }
    },

    rules = [[
        include /usr/local/etc/rules/local.rules
    ]]
}
