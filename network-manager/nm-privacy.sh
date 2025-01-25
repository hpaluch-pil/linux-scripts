#!/bin/bash
# Important NetworkManager privacy settings
set -xeuo pipefail

# NM aggresivelly ping DNS and even several HTTP servers for "connectivity checks"...
cat <<'EOF' | sudo tee /etc/NetworkManager/conf.d/50-disable-connectivity-check.conf
[connectivity]
interval=0
EOF

# ensure that MAC address is not spilled on public IPv6 networks
cat <<'EOF' | sudo tee /etc/NetworkManager/conf.d/60-ip6-privacy.conf
[connection]
ipv6.ip6-privacy=2
EOF

sudo systemctl restart NetworkManager
exit 0

