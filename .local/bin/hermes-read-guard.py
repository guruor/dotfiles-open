#!/usr/bin/env python3
"""Reading guard for Hermes: blocks tool calls that would pull credentials into context.

Wired as a `pre_tool_call` shell hook with `fail_closed: true`, so a crash or timeout
blocks the tool rather than waving it through. Reads one JSON payload on stdin and
writes one JSON directive on stdout:

    {"action": "block", "message": "..."}   # refuse this tool call
    {}                                      # allow

Policy and rationale: the reading-policy note in the agentic setup notes (see
AGENTIC_NOTES_DIR in ~/.hermes/agentic-setup.conf). Tier 0 paths and patterns are
listed there; directory deny-list values come from AGENTIC_DENY_DIRS in that same
config file so no location is hardcoded here.

Honest limitation: this raises the cost of an accident and of prompt injection. It is
NOT a security boundary against a process that can also edit this file, rewrite the
hook, or read files directly. The durable fix is not having plaintext credentials in
files this user can read. See the policy note.
"""

from __future__ import annotations

import fnmatch
import json
import os
import re
import sys
import time
from pathlib import Path

LOG = Path(os.path.expanduser("~/.hermes/logs/read-guard.log"))
CONF = Path(os.environ.get("HERMES_HOME", os.path.expanduser("~/.hermes"))) / "agentic-setup.conf"

# Filenames that are credential material wherever they appear.
DENY_GLOBS = [
    ".env", ".env.*", "*.env",
    "*.pem", "*.key", "*.p12", "*.pfx", "*.jks", "*.keystore",
    "*.kdbx", "*.age", "*.gpg", "*.asc",
    "id_rsa*", "id_dsa*", "id_ecdsa*", "id_ed25519*",
    "*.tfstate", "*.tfvars",
    ".netrc", ".npmrc", ".pypirc", ".pgpass", ".my.cnf",
    "credentials", "credentials.json", "service-account*.json", "token.json",
    "hosts.yml", "*.ovpn", "*.mobileconfig",
]

# Explicitly fine even though they match a deny glob above.
ALLOW_GLOBS = [".env.example", ".env.template", ".env.sample", "*.pub", "*.example"]

# Directory prefixes that are never readable. Extended by AGENTIC_DENY_DIRS.
# Note ~/voidrice/Private: the dotfiles symlink credential files (SSH keys, cloud
# configs) out of their normal homes into that submodule, so the *resolved* target
# has to be denied too, not just the familiar path.
DENY_DIR_DEFAULTS = [
    "~/.ssh", "~/.aws", "~/.kube", "~/.gnupg", "~/.password-store",
    "~/.hermes/vault", "~/.hermes/mcp-tokens", "~/.honcho", "~/.multica",
    "~/.config/sops", "~/.config/gnupg", "~/.config/gh", "~/.local/share/keyrings",
    "~/Library/Keychains",
    "~/voidrice/Private",
    "~/Workspace/Personal/zsh-bitwarden/tests/bin",  # fake vault in the plugin's test tree
]


def _expand(value: str) -> str:
    """Expand $HOME/${HOME}/~ ourselves: the config file is shell syntax, not Python's."""
    home = os.path.expanduser("~")
    value = value.replace("${HOME}", home).replace("$HOME", home)
    return os.path.expanduser(value)

# Tools whose arguments can carry a path or a command. Others are skipped fast.
WATCHED = {
    "read_file", "search_files", "terminal", "execute_code", "patch", "write_file",
    "browser_exec", "computer_use", "document_extract", "image_gen",
}

TOKEN_SPLIT = re.compile(r"""[\s'"`(),;|&<>=]+""")
PATHISH = re.compile(r"""(^~?/|^\./|/|\\\\)""")


def load_deny_dirs() -> list[str]:
    dirs = list(DENY_DIR_DEFAULTS)
    try:
        text = CONF.read_text()
    except OSError:
        return dirs
    m = re.search(r'^AGENTIC_DENY_DIRS="?([^"\n]*)"?', text, re.M)
    if m:
        dirs += [p for p in m.group(1).split() if p]
    return dirs


def norm(candidate: str, cwd: str) -> tuple[str, list[str]] | None:
    """Return (display form, all path forms worth testing) for one token.

    Both the literal absolute path and the symlink-resolved realpath are returned: a
    symlink can point *into* a protected directory from outside it, or *out of* one
    into a location the deny list does not name (the dotfiles do exactly this with
    ~/.ssh files living in the Private submodule).
    """
    if not candidate or len(candidate) > 4096:
        return None
    c = candidate.strip().strip("\"'`")
    if not c or c.startswith("-"):
        return None
    try:
        p = Path(_expand(c))
        if not p.is_absolute():
            p = Path(cwd or os.getcwd()) / p
        literal = str(Path(os.path.normpath(str(p))))
        forms = [literal]
        real = os.path.realpath(literal)
        if real not in forms:
            forms.append(real)
        return (c, forms)
    except (OSError, ValueError):
        return None


def classify(forms: list[str], deny_dirs: list[str]) -> str | None:
    """Return a reason string when any form of the path is Tier 0, else None."""
    resolved_dirs = []
    for d in deny_dirs:
        d_abs = os.path.realpath(_expand(d))
        resolved_dirs.append((d, d_abs))

    for path in forms:
        for label, d_abs in resolved_dirs:
            if path == d_abs or path.startswith(d_abs + os.sep):
                return f"inside the protected directory {label}"
        base = os.path.basename(path)
        for g in ALLOW_GLOBS:
            if fnmatch.fnmatch(base, g):
                break
        else:
            for g in DENY_GLOBS:
                if fnmatch.fnmatch(base, g):
                    return f"matches the credential file pattern '{g}'"
    return None


def candidates(payload: dict) -> list[tuple[str, list[str]]]:
    """Paths worth testing, pulled out of whichever tool is running."""
    name = payload.get("tool_name") or ""
    args = payload.get("tool_input") or {}
    cwd = payload.get("cwd") or os.getcwd()
    found: list[str] = []

    if isinstance(args, dict):
        for key in ("path", "file_path", "filepath", "dir", "directory", "target", "source", "dest"):
            v = args.get(key)
            if isinstance(v, str):
                found.append(v)
        for key in ("command", "code", "script", "query"):
            v = args.get(key)
            if isinstance(v, str):
                found.extend(t for t in TOKEN_SPLIT.split(v) if PATHISH.search(t))
    elif isinstance(args, str):
        found.extend(t for t in TOKEN_SPLIT.split(args) if PATHISH.search(t))

    out: list[tuple[str, list[str]]] = []
    seen: set[str] = set()
    for c in found:
        n = norm(c, cwd)
        if n and n[0] not in seen:
            seen.add(n[0])
            out.append(n)
    return out


def decide(payload: dict) -> dict:
    name = payload.get("tool_name") or ""
    if name not in WATCHED:
        return {}
    deny_dirs = load_deny_dirs()
    for display, forms in candidates(payload):
        reason = classify(forms, deny_dirs)
        if reason:
            return {
                "action": "block",
                "message": (
                    f"Blocked by the reading policy: {display} {reason}. "
                    "Credentials in local files must not enter model context. "
                    "If this is a false positive, ask the human; if a value is genuinely "
                    "needed, it belongs in Bitwarden and is injected into the target process, "
                    "not read into a tool result."
                ),
            }
    return {}


def log(line: str) -> None:
    try:
        LOG.parent.mkdir(parents=True, exist_ok=True)
        stamp = time.strftime("%Y-%m-%dT%H:%M:%S")
        with LOG.open("a") as fh:
            fh.write(f"{stamp} {line}\n")
    except OSError:
        pass


def main() -> int:
    try:
        raw = sys.stdin.read()
        payload = json.loads(raw) if raw.strip() else {}
    except (json.JSONDecodeError, OSError):
        print("{}")
        return 0

    try:
        result = decide(payload)
    except Exception as exc:  # pragma: no cover - defensive
        # Never let a bug in this script wedge the agent: fall back to a substring
        # scan for the most dangerous names, then allow.
        blob = json.dumps(payload).lower()
        if any(marker in blob for marker in (".kdbx", "id_rsa", "/.ssh/", "auth.json", ".env")):
            result = {"action": "block", "message": f"Blocked by read-guard fallback ({exc.__class__.__name__})."}
        else:
            result = {}
            log(f"ERROR {exc!r}")

    if result.get("action") == "block":
        log(f"BLOCK tool={payload.get('tool_name')} profile={payload.get('profile')} msg={result['message'][:160]}")
    print(json.dumps(result))
    return 0


if __name__ == "__main__":
    sys.exit(main())
