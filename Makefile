.PHONY: all clean clean_tools test
.PRECIOUS: %.lz4 %.lzsa2 %.zx0

as := tools/cc65/bin/ca65
ld := tools/cc65/bin/ld65
lz4 := tools/lz4ultra/lz4ultra
lzsa := tools/lzsa/lzsa
zx0 := tools/salvador/salvador
mesen := /Applications/Mesen.app/Contents/MacOS/Mesen
make_test := ./make_lua_test.py
query_dbg := ./query_dbg.py

ld_script := link.cfg

src_dir := src
build_dir := build
obj_dir := $(build_dir)/obj
data_dir := test_data

inc := $(wildcard include/*.inc)

common_obj_list := boot/boot.o boot/init.o boot/header.o
lz4_obj := $(addprefix $(obj_dir)/,$(common_obj_list) shvc-lz4.o boot/main-lz4.o)
lzsa2_obj := $(addprefix $(obj_dir)/,$(common_obj_list) shvc-lzsa2.o boot/main-lzsa2.o)

default: $(build_dir)/shcv_lz4.sfc $(build_dir)/shcv_lzsa2.sfc

all: clean default

$(build_dir)/shcv_lz4.sfc: $(ld_script) Makefile $(ld) $(lz4_obj)
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(lz4_obj)

$(build_dir)/shcv_lzsa2.sfc: $(ld_script) Makefile $(ld) $(lzsa2_obj)
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(lzsa2_obj)

$(obj_dir)/%.o: $(src_dir)/%.s $(inc) $(data_dir)/abam.txt.lz4 $(data_dir)/abam.txt.lzsa2 Makefile $(as)
	@mkdir -p $(@D)
	$(as) -I include --debug-info -o $@ $<

$(as):
	@$(MAKE) -C tools/cc65 ca65 -j6

$(ld):
	@$(MAKE) -C tools/cc65 ld65 -j6

%.lzsa2: % $(lzsa)
	$(lzsa) -v -f2 -r $< $@

%.lz4: % $(lz4)
	$(lz4) -v -r $< $@

%.zx0: % $(zx0)
	$(zx0) -v $< $@

$(lz4):
	@$(MAKE) -C tools/lz4ultra -j6

$(lzsa):
	@$(MAKE) -C tools/lzsa -j6

$(zx0):
	@$(MAKE) -C tools/salvador -j6

clean:
	@rm -rf $(build_dir)

clean_all:
	@rm -f $(data_dir)/*.lz4
	@rm -f $(data_dir)/*.lzsa2
	@rm -f $(data_dir)/*.zx0
	@$(MAKE) clean -C tools/cc65
	@$(MAKE) clean -C tools/lz4ultra
	@$(MAKE) clean -C tools/lzsa
	@$(MAKE) clean -C tools/salvador

#
# Tests
#

test_data_src := $(data_dir)/2889.txt $(data_dir)/abam.txt $(data_dir)/short.txt
test_data_src += $(data_dir)/map1.bin $(data_dir)/map2.bin
test_data_src += $(data_dir)/tile1.bin $(data_dir)/tile2.bin $(data_dir)/tile3.bin $(data_dir)/tile4.bin
test_data := $(addsuffix .lz4,$(test_data_src))
test_data += $(addsuffix .lzsa2,$(test_data_src))

test_src_dir := test
test_common_obj := $(addprefix $(obj_dir)/,$(common_obj_list))

test_roms := $(build_dir)/test_shvc_lzsa2_abam.sfc $(build_dir)/test_shvc_lzsa2_2889.sfc $(build_dir)/test_shvc_lzsa2_short.sfc
test_roms += $(build_dir)/test_shvc_lzsa2_map1.sfc $(build_dir)/test_shvc_lzsa2_map2.sfc
test_roms += $(build_dir)/test_shvc_lzsa2_tile1.sfc $(build_dir)/test_shvc_lzsa2_tile2.sfc $(build_dir)/test_shvc_lzsa2_tile3.sfc $(build_dir)/test_shvc_lzsa2_tile4.sfc
test_roms += $(build_dir)/test_reference_lzsa2_abam.sfc $(build_dir)/test_reference_lzsa2_map2.sfc $(build_dir)/test_reference_lzsa2_tile2.sfc

report: $(build_dir)/test_shvc_lzsa2_abam.sfc $(build_dir)/test_reference_lzsa2_abam.sfc
	@echo "Code size"
	@echo "------------------------------------------------"
	@$(query_dbg) $(build_dir)/test_shvc_lzsa2_abam.dbg size:LZSA2_DecompressBlock
	@$(query_dbg) $(build_dir)/test_reference_lzsa2_abam.dbg value:Reference_LZSA2_DecompressBlock

test: $(test_roms)
	@echo "Running tests..."
	@echo "\n64K text (26582 -> 64115 bytes)"
	@echo "------------------------------------------------"
	@$(mesen) --testrunner $(build_dir)/test_shvc_lzsa2_abam.sfc $(build_dir)/test_shvc_lzsa2_abam.sfc.lua
	@$(mesen) --testrunner $(build_dir)/test_reference_lzsa2_abam.sfc $(build_dir)/test_reference_lzsa2_abam.sfc.lua
	@echo "\n32K text (15450 -> 32893 bytes)"
	@echo "------------------------------------------------"
	@$(mesen) --testrunner $(build_dir)/test_shvc_lzsa2_2889.sfc $(build_dir)/test_shvc_lzsa2_2889.sfc.lua
	@echo "\nTiny text (42 -> 51 bytes)"
	@echo "------------------------------------------------"
	@$(mesen) --testrunner $(build_dir)/test_shvc_lzsa2_short.sfc $(build_dir)/test_shvc_lzsa2_short.sfc.lua
	@echo "\nTile data (411 -> 2048 bytes)"
	@echo "------------------------------------------------"
	@$(mesen) --testrunner $(build_dir)/test_shvc_lzsa2_tile1.sfc $(build_dir)/test_shvc_lzsa2_tile1.sfc.lua
	@echo "\nTile data (1263 -> 4096 bytes)"
	@echo "------------------------------------------------"
	@$(mesen) --testrunner $(build_dir)/test_shvc_lzsa2_tile2.sfc $(build_dir)/test_shvc_lzsa2_tile2.sfc.lua
	@$(mesen) --testrunner $(build_dir)/test_reference_lzsa2_tile2.sfc $(build_dir)/test_reference_lzsa2_tile2.sfc.lua
	@echo "\nMap data (311 -> 8192 bytes)"
	@echo "------------------------------------------------"
	@$(mesen) --testrunner $(build_dir)/test_shvc_lzsa2_map1.sfc $(build_dir)/test_shvc_lzsa2_map1.sfc.lua
	@echo "\nMap data (958 -> 8192 bytes)"
	@echo "------------------------------------------------"
	@$(mesen) --testrunner $(build_dir)/test_shvc_lzsa2_map2.sfc $(build_dir)/test_shvc_lzsa2_map2.sfc.lua
	@$(mesen) --testrunner $(build_dir)/test_reference_lzsa2_map2.sfc $(build_dir)/test_reference_lzsa2_map2.sfc.lua
	@echo

checks: test report

$(obj_dir)/%.o: $(test_src_dir)/%.s $(inc) $(test_data) Makefile $(as)
	@mkdir -p $(@D)
	$(as) -I include --debug-info -o $@ $<

# SHVC-LZSA2 test targets
# TODO: Generate these!
test_shvc_lzsa2_short_obj := $(addprefix $(obj_dir)/,shvc-lzsa2.o test_shvc_lzsa2.o data_lzsa2_short.o) $(test_common_obj)
$(build_dir)/test_shvc_lzsa2_short.sfc: $(test_shvc_lzsa2_short_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_shvc_lzsa2_short_obj)
	$(make_test) bench:Benchmark:"SHVC-LZSA2 decompressor" assert_state:Asserts_END:[cpu.a]:51 assert_range:Asserts_END:Destination:$(data_dir)/short.txt done:Tests_DONE >$@.lua

test_shvc_lzsa2_2889_obj := $(addprefix $(obj_dir)/,shvc-lzsa2.o test_shvc_lzsa2.o data_lzsa2_2889.o) $(test_common_obj)
$(build_dir)/test_shvc_lzsa2_2889.sfc: $(test_shvc_lzsa2_2889_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_shvc_lzsa2_2889_obj)
	$(make_test) bench:Benchmark:"SHVC-LZSA2 decompressor" assert_state:Asserts_END:[cpu.a]:32893 assert_range:Asserts_END:Destination:$(data_dir)/2889.txt done:Tests_DONE >$@.lua

test_shvc_lzsa2_abam_obj := $(addprefix $(obj_dir)/,shvc-lzsa2.o test_shvc_lzsa2.o data_lzsa2_abam.o) $(test_common_obj)
$(build_dir)/test_shvc_lzsa2_abam.sfc: $(test_shvc_lzsa2_abam_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_shvc_lzsa2_abam_obj)
	$(make_test) bench:Benchmark:"SHVC-LZSA2 decompressor" assert_state:Asserts_END:[cpu.a]:64115 assert_range:Asserts_END:Destination:$(data_dir)/abam.txt done:Tests_DONE >$@.lua

test_shvc_lzsa2_map1_obj := $(addprefix $(obj_dir)/,shvc-lzsa2.o test_shvc_lzsa2.o data_lzsa2_map1.o) $(test_common_obj)
$(build_dir)/test_shvc_lzsa2_map1.sfc: $(test_shvc_lzsa2_map1_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_shvc_lzsa2_map1_obj)
	$(make_test) bench:Benchmark:"SHVC-LZSA2 decompressor" assert_state:Asserts_END:[cpu.a]:8192 assert_range:Asserts_END:Destination:$(data_dir)/map1.bin done:Tests_DONE >$@.lua

test_shvc_lzsa2_map2_obj := $(addprefix $(obj_dir)/,shvc-lzsa2.o test_shvc_lzsa2.o data_lzsa2_map2.o) $(test_common_obj)
$(build_dir)/test_shvc_lzsa2_map2.sfc: $(test_shvc_lzsa2_map2_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_shvc_lzsa2_map2_obj)
	$(make_test) bench:Benchmark:"SHVC-LZSA2 decompressor" assert_state:Asserts_END:[cpu.a]:8192 assert_range:Asserts_END:Destination:$(data_dir)/map2.bin done:Tests_DONE >$@.lua

test_shvc_lzsa2_tile1_obj := $(addprefix $(obj_dir)/,shvc-lzsa2.o test_shvc_lzsa2.o data_lzsa2_tile1.o) $(test_common_obj)
$(build_dir)/test_shvc_lzsa2_tile1.sfc: $(test_shvc_lzsa2_tile1_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_shvc_lzsa2_tile1_obj)
	$(make_test) bench:Benchmark:"SHVC-LZSA2 decompressor" assert_state:Asserts_END:[cpu.a]:2048 assert_range:Asserts_END:Destination:$(data_dir)/tile1.bin done:Tests_DONE >$@.lua

test_shvc_lzsa2_tile2_obj := $(addprefix $(obj_dir)/,shvc-lzsa2.o test_shvc_lzsa2.o data_lzsa2_tile2.o) $(test_common_obj)
$(build_dir)/test_shvc_lzsa2_tile2.sfc: $(test_shvc_lzsa2_tile2_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_shvc_lzsa2_tile2_obj)
	$(make_test) bench:Benchmark:"SHVC-LZSA2 decompressor" assert_state:Asserts_END:[cpu.a]:4096 assert_range:Asserts_END:Destination:$(data_dir)/tile2.bin done:Tests_DONE >$@.lua

test_shvc_lzsa2_tile3_obj := $(addprefix $(obj_dir)/,shvc-lzsa2.o test_shvc_lzsa2.o data_lzsa2_tile3.o) $(test_common_obj)
$(build_dir)/test_shvc_lzsa2_tile3.sfc: $(test_shvc_lzsa2_tile3_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_shvc_lzsa2_tile3_obj)
	$(make_test) bench:Benchmark:"SHVC-LZSA2 decompressor" assert_state:Asserts_END:[cpu.a]:8192 assert_range:Asserts_END:Destination:$(data_dir)/tile3.bin done:Tests_DONE >$@.lua

test_shvc_lzsa2_tile4_obj := $(addprefix $(obj_dir)/,shvc-lzsa2.o test_shvc_lzsa2.o data_lzsa2_tile4.o) $(test_common_obj)
$(build_dir)/test_shvc_lzsa2_tile4.sfc: $(test_shvc_lzsa2_tile4_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_shvc_lzsa2_tile4_obj)
	$(make_test) bench:Benchmark:"SHVC-LZSA2 decompressor" assert_state:Asserts_END:[cpu.a]:8192 assert_range:Asserts_END:Destination:$(data_dir)/tile4.bin done:Tests_DONE >$@.lua

# Reference LZSA2 test target
test_reference_lzsa2_abam_obj := $(addprefix $(obj_dir)/,decoder_reference_lzsa2.o test_reference_lzsa2.o data_lzsa2_abam.o) $(test_common_obj)
$(build_dir)/test_reference_lzsa2_abam.sfc: $(test_reference_lzsa2_abam_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_reference_lzsa2_abam_obj)
	$(make_test) bench:Benchmark:"Reference LZSA2 decompressor" assert_range:Asserts_END:Destination:$(data_dir)/abam.txt done:Tests_DONE >$@.lua

test_reference_lzsa2_map2_obj := $(addprefix $(obj_dir)/,decoder_reference_lzsa2.o test_reference_lzsa2.o data_lzsa2_map2.o) $(test_common_obj)
$(build_dir)/test_reference_lzsa2_map2.sfc: $(test_reference_lzsa2_map2_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_reference_lzsa2_map2_obj)
	$(make_test) bench:Benchmark:"Reference LZSA2 decompressor" assert_range:Asserts_END:Destination:$(data_dir)/map2.bin done:Tests_DONE >$@.lua

test_reference_lzsa2_tile2_obj := $(addprefix $(obj_dir)/,decoder_reference_lzsa2.o test_reference_lzsa2.o data_lzsa2_tile2.o) $(test_common_obj)
$(build_dir)/test_reference_lzsa2_tile2.sfc: $(test_reference_lzsa2_tile2_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_reference_lzsa2_tile2_obj)
	$(make_test) bench:Benchmark:"Reference LZSA2 decompressor" assert_range:Asserts_END:Destination:$(data_dir)/tile2.bin done:Tests_DONE >$@.lua
