"""Robot Framework variable file: loads sensitive/environment-specific values.

Priority: OS environment variable > .env file (03_mobile_automation/.env).
The .env file is git-ignored; commit only .env.example.
"""
import os
from pathlib import Path

ENV_FILE = Path(__file__).resolve().parent.parent / ".env"

REQUIRED = ["ERASPACE_USERNAME", "ERASPACE_PASSWORD", "ERASPACE_ACCOUNT_NAME"]


def _read_env_file():
    values = {}
    if ENV_FILE.exists():
        for line in ENV_FILE.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, _, value = line.partition("=")
            values[key.strip()] = value.strip().strip('"').strip("'")
    return values


def get_variables():
    file_values = _read_env_file()

    def get(key, default=None):
        return os.environ.get(key, file_values.get(key, default))

    missing = [k for k in REQUIRED if not get(k)]
    if missing:
        raise RuntimeError(
            "Missing required env vars: %s. Copy .env.example to .env and fill it in, "
            "or export them in your shell." % ", ".join(missing)
        )

    return {
        "VALID_USERNAME": get("ERASPACE_USERNAME"),
        "VALID_PASSWORD": get("ERASPACE_PASSWORD"),
        "EXPECTED_ACCOUNT_NAME": get("ERASPACE_ACCOUNT_NAME"),
        "APPIUM_SERVER_URL": get("APPIUM_SERVER_URL", "http://127.0.0.1:4723/wd/hub"),
        "DEVICE_NAME": get("DEVICE_NAME", "Android"),
    }
