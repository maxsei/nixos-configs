#!/usr/bin/env -S uv run --script
#
# /// script
# requires-python = ">=3.12"
# dependencies = ["requests"]
# ///

import os

import requests

from att_session import login

host = os.environ["ATT_GATEWAY_IP"]
cookies, headers = login(host)

dhcp_response = requests.patch(
    f"http://{host}/serviceElements/Device.DHCPv4.Server.",
    cookies=cookies,
    headers=headers,
    json={"parameters": {"Enable": 0}},
)
dhcp_response.raise_for_status()

ipv6_response = requests.patch(
    f"http://{host}/serviceElements/Device.IP.Interface.[Alias=='lan'].",
    cookies=cookies,
    headers=headers,
    json={"parameters": {"IPv6Enable": 0}},
)
ipv6_response.raise_for_status()
