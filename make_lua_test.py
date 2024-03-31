#!/usr/bin/env python3

import argparse
import random
import string
import sys

def make_boilerplate():
    return """
function getHiRomAddress(label)
  addr = emu.getLabelAddress(label)["address"]
  if addr < 0x800000 then
    return addr + 0x800000
  else
    return addr
  end
end
"""

def make_benchmark(parameters, is_final=True):
    template = """
{ID}_clocks_start = 0
{ID}_cpu_cycles_start = 0

function {ID}_startTest(address, value)
  {ID}_clocks_start = emu.getState()["masterClock"]
  {ID}_cpu_cycles_start = emu.getState()["cpu.cycleCount"]
end

function {ID}_endTest(address, value)
  clocks_end = emu.getState()["masterClock"]
  cpu_cycles_end = emu.getState()["cpu.cycleCount"]

  clocks_total = clocks_end - {ID}_clocks_start
  cpu_cycles_total = cpu_cycles_end - {ID}_cpu_cycles_start
  print("{NAME} benchmark:")
  print(" > Master clocks: "..clocks_total)
  print(" > CPU cycles:    "..cpu_cycles_total)
  emu.stop(0)
end

startAddr = getHiRomAddress("{LABEL}_START")
endAddr = getHiRomAddress("{LABEL}_END")
--print("{LABEL}_START: 0x"..string.format("%x", startAddr))
--print("{LABEL}_END: 0x"..string.format("%x", endAddr))

emu.addMemoryCallback({ID}_startTest, emu.callbackType.exec, startAddr)
emu.addMemoryCallback({ID}_endTest, emu.callbackType.exec, endAddr)
"""
    if len(parameters) != 2:
        raise ValueError("bench parameters malformed ({})".format(parameters))
    label, name = parameters

    id = ''.join(random.choices(string.ascii_letters, k=8))
    output = template.replace("{ID}", id).replace("{NAME}", name).replace("{LABEL}", label)
    if (is_final == False): output = output.replace("emu.stop(0)", "--emu.stop(0)")
    return output

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-b", "--benchmark", dest="benchmarks", action="append", help="add benchmark for label")

    try:
        argv = sys.argv[1:]
        if (len(argv) < 1):
            raise ValueError("no tests defined")

        output = make_boilerplate()

        for i, arg in enumerate(argv):
            is_final = i == len(argv) - 1
            parameters = arg.split(":")
            cmd = parameters.pop(0)
            if cmd == "bench": output += make_benchmark(parameters, is_final)

        print(output)
        sys.exit(0)

    except Exception as err:
        print("error - {}".format(err))
        sys.exit(1)

if __name__ == "__main__":
    sys.exit(main())
