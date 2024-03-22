clocks_start = 0
cpu_cycles_start = 0

function startTest(address, value)
  clocks_start = emu.getState()["masterClock"]
  cpu_cycles_start = emu.getState()["cpu.cycleCount"]
end

function endTest(address, value)
  clocks_end = emu.getState()["masterClock"]
  cpu_cycles_end = emu.getState()["cpu.cycleCount"]

  clocks_total = clocks_end - clocks_start
  cpu_cycles_total = cpu_cycles_end - cpu_cycles_start
  print(" > Test done")
  print(" > Master clocks: "..clocks_total)
  print(" > CPU cycles:    "..cpu_cycles_total)
  emu.stop(0)
end

function getHiRomAddress(label)
  addr = emu.getLabelAddress(label)["address"]
  if addr < 0x800000 then
    return addr + 0x800000
  else
    return addr
  end
end

print("SHVC-LZSA2/ROM decompressor benchmark:")

startAddr = getHiRomAddress("Test_START")
endAddr = getHiRomAddress("Test_END")
--print("Test_START: 0x"..string.format("%x", startAddr))
--print("Test_END: 0x"..string.format("%x", endAddr))

emu.addMemoryCallback(startTest, emu.callbackType.exec, startAddr)
emu.addMemoryCallback(endTest, emu.callbackType.exec, endAddr)
