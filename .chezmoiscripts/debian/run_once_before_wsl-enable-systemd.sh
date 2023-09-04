#!/usr/bin/env bash

sudo tee /etc/wsl.conf <<EOF >/dev/null
[boot]
systemd=true
EOF