import os
import time
import urllib.parse

import requests


def login(host):
    # shortcut: modem LAN route isn't always up yet when network-online.target fires; retry with backoff instead of fixing unit ordering
    max_attempts = 8
    for attempt in range(max_attempts):
        try:
            session_response = requests.post(
                f"http://{host}/session",
                json={
                    "username": "admin",
                    "password": open(os.environ["ATT_PASSWORD_FILE"]).read().strip(),
                },
            )
            session_response.raise_for_status()
            break
        except (requests.exceptions.ConnectionError, requests.exceptions.Timeout):
            if attempt == max_attempts - 1:
                raise
            time.sleep(2**attempt)
    session = session_response.json()

    cookies = {
        "ember_simple_auth-session": urllib.parse.urlencode({"authenticated": session}),
    }
    headers = {
        "Authorization": f'Bearer {session["sessionID"]}',
    }
    return cookies, headers
