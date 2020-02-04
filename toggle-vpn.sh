#!/usr/bin/env bash

VPN_UUID='client94'

(nmcli connection show --active | grep --quiet "$VPN_UUID") && nmcli connection down "$VPN_UUID" || nmcli connection up "$VPN_UUID"
