#!/usr/bin/env python3
"""Reads config/repo-governance.yml and prints requested values as JSON or plain text.
Used by the bash scripts so config stays in one declarative YAML file instead of being
duplicated inline in shell.
"""
import sys, json, yaml, pathlib

def main():
    if len(sys.argv) < 2:
        print("usage: read_config.py <config.yml> <dotted.key.path>", file=sys.stderr)
        sys.exit(2)
    cfg_path = pathlib.Path(sys.argv[1])
    data = yaml.safe_load(cfg_path.read_text())
    if len(sys.argv) == 2:
        print(json.dumps(data))
        return
    key_path = sys.argv[2].split(".")
    node = data
    for k in key_path:
        if isinstance(node, list):
            node = node[int(k)]
        else:
            node = node.get(k)
        if node is None:
            print("", end="")
            return
    if isinstance(node, (dict, list)):
        print(json.dumps(node))
    else:
        print(node)

if __name__ == "__main__":
    main()
