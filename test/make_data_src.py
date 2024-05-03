#!/usr/bin/env python3

import sys

def make_data_src(path):
    return """
.export Compressed, Compressed_Length

.segment "RODATA"
Padding:
    .res $17
Compressed:
    .incbin "{{PATH}}"
Compressed_END:
Compressed_Length = Compressed_END - Compressed
""".replace("{{PATH}}", path)

def main():
    try:
        argv = sys.argv[1:]
        if (len(argv) < 2):
            raise ValueError("not enough arguments")
        open(argv[0], mode="w", encoding="utf-8").write(make_data_src(argv[1]))
        sys.exit(0)

    except Exception as err:
        print("error - {}".format(err))
        sys.exit(1)

if __name__ == "__main__":
    sys.exit(main())
