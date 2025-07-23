# Ping utility with sensible defaults and optional target override
#
# Usage: pi [target]
# Arguments:
#   target - IP address or hostname to ping (optional, defaults to 1.1.1.1)
#
# Examples:
#   pi                      # Ping Cloudflare DNS (1.1.1.1) 5 times
#   pi google.com          # Ping google.com 5 times
#   pi 192.168.1.1         # Ping local gateway 5 times
#
# Returns: Ping results with audible alerts and count limit (5 pings)
function pi
    if count $argv >/dev/null
        ping -Anc 5 $argv
    else
        ping -Anc 5 1.1.1.1
    end
end
