.PHONY: all run test clean clean_tools
.PRECIOUS: %.lzsa2

name := LZSA2

as := tools/cc65/bin/ca65
ld := tools/cc65/bin/ld65
lzsa := tools/lzsa/lzsa
mesen := /Applications/Mesen.app/Contents/MacOS/Mesen
make_test := ./make_lua_test.py

ld_script := link.cfg

src_dir := src
build_dir := build
obj_dir := $(build_dir)/obj

inc := $(wildcard include/*.inc)
rom := $(build_dir)/$(name).sfc
dbg := $(build_dir)/$(name).dbg
map := $(build_dir)/$(name)_map.txt

common_obj_list := boot.o init.o header.o lzsa2.o
main_obj_list := main.o
main_obj := $(addprefix $(obj_dir)/,$(main_obj_list) $(common_obj_list))
data := data/2889.txt.lzsa2 data/abam.txt.lzsa2 data/short.txt.lzsa2

default: $(rom)

all: clean default

$(rom): $(main_obj) $(ld_script) Makefile $(ld)
	$(ld) --dbgfile $(dbg) --mapfile $(map) -o $@ --config $(ld_script) $(main_obj)

$(obj_dir)/%.o: $(src_dir)/%.s $(inc) $(data) Makefile $(as) | $(obj_dir)
	$(as) -I include --debug-info -o $@ $<

$(obj_dir):
	mkdir -p $(obj_dir)

$(as):
	@$(MAKE) -C tools/cc65 ca65 -j6

$(ld):
	@$(MAKE) -C tools/cc65 ld65 -j6

%.lzsa2: % $(lzsa)
	$(lzsa) -v -f2 -r $< $@

$(lzsa):
	@$(MAKE) -C tools/lzsa -j6

run: $(rom)
	open -a /Applications/Mesen.app --args $(realpath $(rom)) --doNotSaveSettings

clean:
	@rm -rf $(build_dir)
	@rm -f data/*.lzsa2

clean_tools:
	@$(MAKE) clean -C tools/cc65
	@$(MAKE) clean -C tools/lzsa

# Tests

test_src_dir := test
test_common_obj := $(addprefix $(obj_dir)/,$(common_obj_list))

test_roms := $(build_dir)/test_rom_2889.sfc $(build_dir)/test_reference_2889.sfc
test_roms += $(build_dir)/test_rom_abam.sfc $(build_dir)/test_reference_abam.sfc
test_roms += $(build_dir)/test_rom_short.sfc $(build_dir)/test_reference_short.sfc

test_scripts := $(addsuffix .lua, $(test_roms))

test: $(test_roms) $(test_scripts)
	@echo "Running tests..."
	@echo
	@echo "Short (text file, 42 -> 51 bytes)"
	@$(mesen) --testrunner $(build_dir)/test_reference_short.sfc $(build_dir)/test_reference_short.sfc.lua
	@$(mesen) --testrunner $(build_dir)/test_rom_short.sfc $(build_dir)/test_rom_short.sfc.lua
	@echo
	@echo "2889 (text file, 15450 -> 32893 bytes)"
	@$(mesen) --testrunner $(build_dir)/test_reference_2889.sfc $(build_dir)/test_reference_2889.sfc.lua
	@$(mesen) --testrunner $(build_dir)/test_rom_2889.sfc $(build_dir)/test_rom_2889.sfc.lua
	@echo
	@echo "ABAM (text file, 26582 -> 64115 bytes)"
	@$(mesen) --testrunner $(build_dir)/test_reference_abam.sfc $(build_dir)/test_reference_abam.sfc.lua
	@$(mesen) --testrunner $(build_dir)/test_rom_abam.sfc $(build_dir)/test_rom_abam.sfc.lua

$(obj_dir)/test_%.o: $(test_src_dir)/%.s $(inc) $(data) Makefile $(as) | $(obj_dir)
	$(as) -I include --debug-info -o $@ $<

test_rom_2889_obj := $(addprefix $(obj_dir)/test_, test_rom.o data_txt_2889.o) $(test_common_obj)
$(build_dir)/test_rom_2889.sfc: $(test_rom_2889_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(build_dir)/test_rom_2889.dbg --mapfile $(build_dir)/test_rom_2889.map -o $@ --config $(ld_script) $(test_rom_2889_obj)
$(build_dir)/test_rom_2889.sfc.lua: $(build_dir)/test_rom_2889.sfc $(make_test)
	$(make_test) bench:Benchmark:"SHVC-LZSA2/ROM decompressor" assert_state:Asserts_END:[cpu.a]:32893 assert_range:Asserts_END:Destination:data/2889.txt done:Tests_DONE >$@

test_rom_abam_obj := $(addprefix $(obj_dir)/test_, test_rom.o data_txt_abam.o) $(test_common_obj)
$(build_dir)/test_rom_abam.sfc: $(test_rom_abam_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(build_dir)/test_rom_abam.dbg --mapfile $(build_dir)/test_rom_abam.map -o $@ --config $(ld_script) $(test_rom_abam_obj)
$(build_dir)/test_rom_abam.sfc.lua: $(build_dir)/test_rom_abam.sfc $(make_test)
	$(make_test) bench:Benchmark:"SHVC-LZSA2/ROM decompressor" assert_state:Asserts_END:[cpu.a]:64115 assert_range:Asserts_END:Destination:data/abam.txt done:Tests_DONE >$@

test_rom_short_obj := $(addprefix $(obj_dir)/test_, test_rom.o data_txt_short.o) $(test_common_obj)
$(build_dir)/test_rom_short.sfc: $(test_rom_short_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(build_dir)/test_rom_short.dbg --mapfile $(build_dir)/test_rom_short.map -o $@ --config $(ld_script) $(test_rom_short_obj)
$(build_dir)/test_rom_short.sfc.lua: $(build_dir)/test_rom_short.sfc $(make_test)
	$(make_test) bench:Benchmark:"SHVC-LZSA2/ROM decompressor" assert_state:Asserts_END:[cpu.a]:51 assert_range:Asserts_END:Destination:data/short.txt done:Tests_DONE >$@

test_reference_2889_obj := $(addprefix $(obj_dir)/test_, test_reference.o lzsa2_reference.o data_txt_2889.o) $(test_common_obj)
$(build_dir)/test_reference_2889.sfc: $(test_reference_2889_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(build_dir)/test_reference_2889.dbg --mapfile $(build_dir)/test_reference_2889.map -o $@ --config $(ld_script) $(test_reference_2889_obj)
$(build_dir)/test_reference_2889.sfc.lua: $(build_dir)/test_reference_2889.sfc $(make_test)
	$(make_test) bench:Benchmark:"Reference decompressor" assert_range:Asserts_END:Destination:data/2889.txt done:Tests_DONE >$@

test_reference_abam_obj := $(addprefix $(obj_dir)/test_, test_reference.o lzsa2_reference.o data_txt_abam.o) $(test_common_obj)
$(build_dir)/test_reference_abam.sfc: $(test_reference_abam_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(build_dir)/test_reference_abam.dbg --mapfile $(build_dir)/test_reference_abam.map -o $@ --config $(ld_script) $(test_reference_abam_obj)
$(build_dir)/test_reference_abam.sfc.lua: $(build_dir)/test_reference_abam.sfc $(make_test)
	$(make_test) bench:Benchmark:"Reference decompressor" assert_range:Asserts_END:Destination:data/abam.txt done:Tests_DONE >$@

test_reference_short_obj := $(addprefix $(obj_dir)/test_, test_reference.o lzsa2_reference.o data_txt_short.o) $(test_common_obj)
$(build_dir)/test_reference_short.sfc: $(test_reference_short_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(build_dir)/test_reference_short.dbg --mapfile $(build_dir)/test_reference_short.map -o $@ --config $(ld_script) $(test_reference_short_obj)
$(build_dir)/test_reference_short.sfc.lua: $(build_dir)/test_reference_short.sfc $(make_test)
	$(make_test) bench:Benchmark:"Reference decompressor" assert_range:Asserts_END:Destination:data/short.txt done:Tests_DONE >$@
