#!/usr/bin/env python3
# Strips // and /* */ comments outside of string literals from stdin, writes plain JSON to stdout.
# Shared by hypr/scripts/GenerateRofiColors.sh and SyncHyprlockFont.sh so style.json (JSONC) feeds jq.
import sys

s = sys.stdin.read()
out, i, n = [], 0, len(s)
in_str = in_line = in_block = False
while i < n:
    c = s[i]
    nxt = s[i + 1] if i + 1 < n else ""
    if in_line:
        if c == "\n":
            in_line = False
            out.append(c)
        i += 1
        continue
    if in_block:
        if c == "*" and nxt == "/":
            in_block = False
            i += 2
        else:
            i += 1
        continue
    if in_str:
        out.append(c)
        if c == "\\":
            out.append(nxt)
            i += 2
            continue
        if c == "\"":
            in_str = False
        i += 1
        continue
    if c == "\"":
        in_str = True
        out.append(c)
        i += 1
    elif c == "/" and nxt == "/":
        in_line = True
        i += 2
    elif c == "/" and nxt == "*":
        in_block = True
        i += 2
    else:
        out.append(c)
        i += 1
sys.stdout.write("".join(out))
