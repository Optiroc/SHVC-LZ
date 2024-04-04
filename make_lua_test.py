#!/usr/bin/env python3

# Add size:label

import random
import string
import sys
from pathlib import Path
from struct import unpack

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


def make_done(parameters):
    template = """
function {ID}_done()
  emu.stop(0)
end

{ID}_donePC = getHiRomAddress("{PC_LABEL}")
emu.addMemoryCallback({ID}_done, emu.callbackType.exec, {ID}_donePC)
"""
    if len(parameters) != 1:
        raise ValueError("done parameters malformed ({})".format(parameters))
    pc_label = parameters[0]

    id = ''.join(random.choices(string.ascii_letters, k=8))

    return template.replace("{ID}", id).replace("{PC_LABEL}", pc_label)


def make_assert_state(parameters):
    template = """
function {ID}_assertState()
  local expected = {EXPECTED}
  local state = emu.getState()
  local actual = state{STATE_PATH_ESC}
  if expected ~= actual then
    print("assert_state failed: {STATE_PATH} == 0x"..string.format("%x", expected).." @ {PC_LABEL}")
    print("  > expected:0x"..string.format("%x", expected).." actual:0x"..string.format("%x", actual))
    emu.stop(1)
  end
end

{ID}_assertPC = getHiRomAddress("{PC_LABEL}")
emu.addMemoryCallback({ID}_assertState, emu.callbackType.exec, {ID}_assertPC)
"""
    if len(parameters) != 3:
        raise ValueError("assert_state parameters malformed ({})".format(parameters))
    pc_label, state_path, expected = parameters

    id = ''.join(random.choices(string.ascii_letters, k=8))

    return template.replace("{ID}", id)\
      .replace("{PC_LABEL}", pc_label)\
      .replace("{STATE_PATH}", state_path)\
      .replace("{STATE_PATH_ESC}", state_path.replace("[", "[\"").replace("]", "\"]"))\
      .replace("{EXPECTED}", expected)


def make_assert_range(parameters):
    template = """
function {ID}_assertRange()
  local expected = {{VALUES}}
  local addr = emu.getLabelAddress("{ACTUAL_LABEL}")["address"]
  local success = true

  for i = 1, #expected do
    local e = expected[i]
    local a = emu.read(addr + i - 1, emu.memType.snesWorkRam)
    if e ~= a then
      print("assert_range failed: '{PATH}' == {ACTUAL_LABEL} @ {PC_LABEL}")
      print("  > offset "..(i - 1).." - expected:0x"..string.format("%x", e).." actual:0x"..string.format("%x", a))
      success = false
      break
    end
  end
  if not success then
    emu.stop(1)
  end
end

{ID}_assertPC = getHiRomAddress("{PC_LABEL}")
emu.addMemoryCallback({ID}_assertRange, emu.callbackType.exec, {ID}_assertPC)
"""
    if len(parameters) != 3:
        raise ValueError("assert_range parameters malformed ({})".format(parameters))
    pc_label, actual_label, path = parameters

    id = ''.join(random.choices(string.ascii_letters, k=8))

    expected_bytes = Path(path).read_bytes()
    chrs = unpack('B' * (len(expected_bytes)), expected_bytes)
    expected_values = []
    for c in chrs: expected_values.append(str(c))

    return template.replace("{ID}", id)\
      .replace("{PC_LABEL}", pc_label)\
      .replace("{ACTUAL_LABEL}", actual_label)\
      .replace("{VALUES}", ", ".join(expected_values))\
      .replace("{PATH}", path)


def make_benchmark(parameters):
    template = """
{ID}_clocks_start = 0
{ID}_cpu_cycles_start = 0

function {ID}_benchmarkStart(address, value)
  local state = emu.getState()
  {ID}_clocks_start = state["masterClock"]
  {ID}_cpu_cycles_start = state["cpu.cycleCount"]
end

function {ID}_benchmarkEnd(address, value)
  local state = emu.getState()
  local xtal = state["clockRate"]
  local clocks_end = state["masterClock"]
  local cpu_cycles_end = state["cpu.cycleCount"]

  local clocks_total = clocks_end - {ID}_clocks_start
  local seconds = clocks_total / xtal
  local cpu_cycles_total = cpu_cycles_end - {ID}_cpu_cycles_start
  print("benchmark: {NAME}")
  print(" > master clocks: "..clocks_total.." ("..seconds.."s)")
  print(" > cpu cycles:    "..cpu_cycles_total)
  emu.stop(0) --SUCCESS
end

{ID}_startAddr = getHiRomAddress("{LABEL}_START")
{ID}_endAddr = getHiRomAddress("{LABEL}_END")
emu.addMemoryCallback({ID}_benchmarkStart, emu.callbackType.exec, {ID}_startAddr)
emu.addMemoryCallback({ID}_benchmarkEnd, emu.callbackType.exec, {ID}_endAddr)
"""
    if len(parameters) != 2:
        raise ValueError("bench parameters malformed ({})".format(parameters))
    label, name = parameters

    id = ''.join(random.choices(string.ascii_letters, k=8))
    return template.replace("{ID}", id)\
      .replace("{NAME}", name)\
      .replace("{LABEL}", label)


def main():
    try:
        argv = sys.argv[1:]
        if (len(argv) < 1):
            raise ValueError("no tests defined")

        output = make_boilerplate()

        for arg in argv:
            parameters = arg.split(":")
            cmd = parameters.pop(0)
            if cmd == "assert_state": output += make_assert_state(parameters)
            if cmd == "assert_range": output += make_assert_range(parameters)
            if cmd == "bench": output += make_benchmark(parameters)
            if cmd == "done": output += make_done(parameters)

        print(output)
        sys.exit(0)

    except Exception as err:
        print("error - {}".format(err))
        sys.exit(1)

if __name__ == "__main__":
    sys.exit(main())
