#!/usr/bin/env python3

import os
import statistics
import subprocess
import sys

from make_lua_test import make_lua_tests

CLOCK_RATE = 21477270
MESEN = "/Applications/Mesen.app/Contents/MacOS/Mesen"

# -----------------------------------------------------------------------------

def test():
    stats = {}
    data_files = [
        "calgary/obj1",
        "calgary/paper1",
        "calgary/paper3",
        "calgary/paper4",
        "calgary/paper5",
        "calgary/paper6",
        "calgary/progc",
        "calgary/progp",
        "canterbury/cp.html",
        "canterbury/fields.c",
        "canterbury/grammar.lsp",
        "canterbury/sum",
        "canterbury/xargs.1",
        "map1.bin",
        "tile1.bin",
        "tile2.bin",
        "tile3.bin",
        "tile4.bin",
        "vram1.bin",
        "abam.txt",
        "2889.txt",
    ]

    for data_file in data_files:
        run_tests(data_file, stats)
    print("# SHVC-LZ Statistics")
    print("```")
    print_stats(stats, "lz4")
    print()
    print_stats(stats, "lzsa2")
    print("```")
    print()

def run_tests(data_file, stats):
    print("## {}".format(data_file))
    print("```")
    run_lz4_test(data_file, stats)
    print()
    run_lzsa2_test(data_file, stats)
    print("```")

# -----------------------------------------------------------------------------
# test runner

def run_test_rom(base_name, lua):
    make_dir("build")
    open("build/{}.lua".format(base_name), mode="w", encoding="utf-8").write(lua)
    r = subprocess.run([MESEN, "--testrunner", "build/{}.sfc".format(base_name), "build/{}.lua".format(base_name)], stdout=subprocess.PIPE)
    if r.returncode != 0:
        print(r.stdout.decode())
        raise RuntimeError("test failed")
    d = {}
    for line in r.stdout.decode().split("\n"):
        if "=" in line:
            k, v = line.split("=")
            if k in ["clocks", "cycles"]:
                d[k] = int(v)
    return d

def collect_test_report(data_name, compressor, res, stats):
    data_path = "test/data/{}".format(data_name)
    data_size_uncompressed = os.path.getsize(data_path)
    data_size_compressed = os.path.getsize(data_path + "." + compressor)
    ratio = data_size_uncompressed / data_size_compressed
    speed = data_size_uncompressed / (res["clocks"] / CLOCK_RATE)
    add_stats(stats, compressor, ratio, speed)

    print("{}: {} -> {} bytes ({:.3f}x)".format(compressor.upper(), data_size_compressed, data_size_uncompressed, ratio))
    print("  CPU cycles:    {:8d}".format(res["cycles"]))
    print("  Master clocks: {:8d}".format(res["clocks"]))
    print("  Time:          {:8.3f} s".format(res["clocks"] / CLOCK_RATE))
    print("  Speed:        {:9.3f} KB/s".format(speed / 1000.0))

def add_stats(stats, compressor, ratio, speed):
    if not compressor in stats:
        stats[compressor] = {"ratio": [], "speed": []}
    stats[compressor]["ratio"].append(ratio)
    stats[compressor]["speed"].append(speed)
    return

def print_stats(stats, compressor):
    ratio_mean = statistics.mean(stats[compressor]["ratio"])
    ratio_median = statistics.median(stats[compressor]["ratio"])
    ratio_max = max(stats[compressor]["ratio"])
    ratio_min = min(stats[compressor]["ratio"])
    speed_mean = statistics.mean(stats[compressor]["speed"]) / 1000.0
    speed_median = statistics.median(stats[compressor]["speed"]) / 1000.0
    speed_max = max(stats[compressor]["speed"]) / 1000.0
    speed_min = min(stats[compressor]["speed"]) / 1000.0

    print("{:6}        Mean    Median       Min       Max".format(compressor.upper()))
    print("  Ratio   {:8.3f}  {:8.3f}  {:8.3f}  {:8.3f}".format(ratio_mean, ratio_median, ratio_min, ratio_max))
    print("  Speed  {:9.3f} {:9.3f} {:9.3f} {:9.3f}".format(speed_mean, speed_median, speed_min, speed_max))
    return

def cleanup_test():
    os.remove("build/test.sfc")
    os.remove("build/test.lua")
    os.remove("build/test.dbg")

# -----------------------------------------------------------------------------
# lz4 support

def run_lz4_test(data_name, stats):
    make_lz4_test_rom(data_name)
    data_path = "test/data/{}".format(data_name)
    lua = make_lua_tests([
        "bench:Benchmark",
        "assert_state:Asserts_END:[cpu.x]:{}".format(os.path.getsize(data_path)),
        "assert_range:Asserts_END:Destination:{}".format(data_path),
        "done:Tests_DONE"
    ])
    res = run_test_rom("test", lua)
    collect_test_report(data_name, "lz4", res, stats)
    cleanup_test()
    return

def make_lz4_test_rom(data_name):
    makefile = """
include Makefile

data_file := {{DATA_NAME}}.lz4
tmp_list := boot/boot.o boot/init.o boot/header.o shvc-lz4.o test_shvc_lz4.o $(data_file).data.o
tmp_obj := $(addprefix $(obj_dir)/,$(tmp_list))

build/test.sfc: $(tmp_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(tmp_obj)
""".replace("{{DATA_NAME}}", data_name)

    open("test.make", mode="w", encoding="utf-8").write(makefile)
    r = subprocess.run(["make", "-f", "test.make", "build/test.sfc"], stdout=subprocess.PIPE)
    os.remove("test.make")
    if r.returncode != 0:
        print(r.stdout.decode())
        raise RuntimeError("failed to build test.sfc with data file '{}.lz4'".format(data_name))

# -----------------------------------------------------------------------------
# lzsa2 support

def run_lzsa2_test(data_name, stats):
    make_lzsa2_test_rom(data_name)
    data_path = "test/data/{}".format(data_name)
    lua = make_lua_tests([
        "bench:Benchmark",
        "assert_state:Asserts_END:[cpu.x]:{}".format(os.path.getsize(data_path)),
        "assert_range:Asserts_END:Destination:{}".format(data_path),
        "done:Tests_DONE"
    ])
    res = run_test_rom("test", lua)
    collect_test_report(data_name, "lzsa2", res, stats)
    cleanup_test()

def make_lzsa2_test_rom(data_name):
    makefile = """
include Makefile

data_file := {{DATA_NAME}}.lzsa2
tmp_list := boot/boot.o boot/init.o boot/header.o shvc-lzsa2.o test_shvc_lzsa2.o $(data_file).data.o
tmp_obj := $(addprefix $(obj_dir)/,$(tmp_list))

build/test.sfc: $(tmp_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(tmp_obj)
""".replace("{{DATA_NAME}}", data_name)

    open("test.make", mode="w", encoding="utf-8").write(makefile)
    r = subprocess.run(["make", "-f", "test.make", "build/test.sfc"], stdout=subprocess.PIPE)
    os.remove("test.make")
    if r.returncode != 0:
        print(r.stdout.decode())
        raise RuntimeError("failed to build test.sfc with data file '{}.lzsa2'".format(data_name))

# -----------------------------------------------------------------------------
# utility functions, command line interface

def make_dir(path: str):
    if not os.path.exists(path):
        os.makedirs(path)

def main():
    try:
        test()
        sys.exit(0)

    except Exception as err:
        print("error - {}".format(err))
        sys.exit(1)

if __name__ == "__main__":
    sys.exit(main())
