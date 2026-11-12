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

att_gateway_port = int(os.environ["ATT_GATEWAY_PORT"])
host_port = int(os.environ["HOST_PORT"])

alias = f"{att_gateway_port}->{host_port}"

port_mapping_args = {
    "Alias": alias,
    "Description": alias,
    "Enable": 1,
    "ExternalPort": att_gateway_port,
    "ExternalPortEndRange": att_gateway_port,
    "Protocol": "TCP,UDP",
    "Origin": "User",
    "InternalPort": host_port,
    "InternalClient": os.environ["HOST_IP"],
    "Interface": "Device.Logical.Interface.1",
}

service_elements_list_response = requests.get(
    f"http://{host}/serviceElements/Device.NAT.PortMapping.",
    cookies=cookies,
    headers=headers,
)
service_elements_list_response.raise_for_status()
existing = [
    d for d in service_elements_list_response.json()
    if d.get("parameters", {}).get("Alias") == alias
]

if existing:
    port_mapping_path = existing[0]["path"]
else:
    port_mapping_response = requests.post(
        f"http://{host}/commands",
        cookies=cookies,
        headers=headers,
        json={
            "command": "Device.NAT.PortMapping._add()",
            "commandKey": "",
            "sendresp": True,
            "inputArgs": port_mapping_args,
        },
    )
    port_mapping_response.raise_for_status()
    port_mapping_path = port_mapping_response.json()[0]["outputArgs"]["path"]

service_elements_response = requests.patch(
    f"http://{host}/serviceElements/{port_mapping_path}",
    cookies=cookies,
    headers=headers,
    json={
        "parameters": {k: v for k, v in port_mapping_args.items() if k != "Alias"},
    },
)
service_elements_response.raise_for_status()
