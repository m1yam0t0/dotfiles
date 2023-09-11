#!/usr/bin/env bash

# Enable systemd on WSL
# https://learn.microsoft.com/ja-jp/windows/wsl/systemd

sudo tee /etc/wsl.conf <<EOF >/dev/null
[boot]
systemd=true
EOF
