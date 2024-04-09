#!/usr/bin/env python3

import sys

def parse_dbg(path):
    dbg = {}
    with open(path) as file:
        for line in file:
            if line.startswith("sym"):
                values = line.removeprefix("sym").strip().split(",")
                props = {}
                name = None
                for value in values:
                    k, v = value.split("=")
                    if k in ["def", "ref", "scope", "seg"]: continue
                    if k == "name":
                      name = v.replace('"', '')
                    else:
                      if k == "id": v = int(v)
                      if k == "val": v = int(v, 16)
                      props[k] = v
                if props["type"] == "imp": continue
                dbg[name] = props
    return dbg

def get_value(parameters, dbg):
    if len(parameters) != 1:
        raise ValueError("value parameters malformed ({})".format(parameters))
    name = parameters[0]
    value = dbg[name]["val"]
    print("{} = 0x{:02x} ({})".format(name, value, value))

def get_size(parameters, dbg):
    if len(parameters) != 1:
        raise ValueError("size parameters malformed ({})".format(parameters))
    label = parameters[0]
    size = dbg[label + "_END"]["val"] - dbg[label]["val"]
    print("{} = 0x{:02x} ({})".format(label, size, size))
    return ""

def main():
    try:
        argv = sys.argv[1:]
        if (len(argv) < 1):
            raise ValueError("no dbg file argument")
        dbg = parse_dbg(argv.pop(0))

        for arg in argv:
            parameters = arg.split(":")
            cmd = parameters.pop(0)
            if cmd == "value": get_value(parameters, dbg)
            if cmd == "size": get_size(parameters, dbg)

        sys.exit(0)

    except Exception as err:
        print("error - {}".format(err))
        sys.exit(1)

if __name__ == "__main__":
    sys.exit(main())
