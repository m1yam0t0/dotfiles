#!/bin/sh

HOSTNAME=$1

# change hostname
case "${OSTYPE}" in
    darwin*)
        # macOS
        sudo scutil --set HostName $HOSTNAME
        sudo scutil --set LocalHostName $HOSTNAME
        sudo scutil --set ComputerName $HOSTNAME
        dscacheutil -flushcache
        ;;
    linux*)
        # Debian
        if [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
            OLD_HOSTNAME=`hostname`
            sudo hostnamectl set-hostname $HOSTNAME
            sudo sed -i -e "s/127.0.1.1\s${OLD_HOSTNAME}/127.0.1.1\s${HOSTNAME}/g" /etc/hosts
        fi
        ;;
esac
