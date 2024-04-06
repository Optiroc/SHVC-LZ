.PHONY: all run test clean clean_tools
.PRECIOUS: %.lzsa2

as := tools/cc65/bin/ca65
ld := tools/cc65/bin/ld65
lzsa := tools/lzsa/lzsa
mesen := /Applications/Mesen.app/Contents/MacOS/Mesen
make_test := ./make_lua_test.py

ld_script := link.cfg

src_dir := src
build_dir := build
obj_dir := $(build_dir)/obj
data_dir := test_data

inc := $(wildcard include/*.inc)

common_obj_list := boot/boot.o boot/init.o boot/header.o shvc-lzsa2.o
main_obj_list := boot/main-lzsa2.o
main_obj := $(addprefix $(obj_dir)/,$(main_obj_list) $(common_obj_list))

default: $(build_dir)/shcv_lzsa2.sfc

all: clean default

$(build_dir)/shcv_lzsa2.sfc: $(main_obj) $(ld_script) Makefile $(ld)
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(main_obj)

$(obj_dir)/%.o: $(src_dir)/%.s $(inc) $(data_dir)/abam.txt.lzsa2 Makefile $(as)
	@mkdir -p $(@D)
	$(as) -I include --debug-info -o $@ $<

$(as):
	@$(MAKE) -C tools/cc65 ca65 -j6

$(ld):
	@$(MAKE) -C tools/cc65 ld65 -j6

%.lzsa2: % $(lzsa)
	$(lzsa) -v -f2 -r $< $@

$(lzsa):
	@$(MAKE) -C tools/lzsa -j6

clean:
	@rm -rf $(build_dir)
	@rm -f $(data_dir)/*.lzsa2

clean_tools:
	@$(MAKE) clean -C tools/cc65
	@$(MAKE) clean -C tools/lzsa

#
# Tests
#

test_data := $(data_dir)/2889.txt.lzsa2 $(data_dir)/abam.txt.lzsa2 $(data_dir)/short.txt.lzsa2

test_src_dir := test
test_common_obj := $(addprefix $(obj_dir)/,$(common_obj_list))

test_roms := $(build_dir)/test_shvc_lzsa2_2889.sfc $(build_dir)/test_reference_lzsa2_2889.sfc
test_roms += $(build_dir)/test_shvc_lzsa2_abam.sfc $(build_dir)/test_reference_lzsa2_abam.sfc
test_roms += $(build_dir)/test_shvc_lzsa2_short.sfc $(build_dir)/test_reference_lzsa2_short.sfc

test: $(test_roms)
	@echo "Running tests..."
	@echo
	@echo "Short (text file, 42 -> 51 bytes)"
	@$(mesen) --testrunner $(build_dir)/test_shvc_lzsa2_short.sfc $(build_dir)/test_shvc_lzsa2_short.sfc.lua
	@$(mesen) --testrunner $(build_dir)/test_reference_lzsa2_short.sfc $(build_dir)/test_reference_lzsa2_short.sfc.lua
	@echo
	@echo "2889 (text file, 15450 -> 32893 bytes)"
	@$(mesen) --testrunner $(build_dir)/test_shvc_lzsa2_2889.sfc $(build_dir)/test_shvc_lzsa2_2889.sfc.lua
	@$(mesen) --testrunner $(build_dir)/test_reference_lzsa2_2889.sfc $(build_dir)/test_reference_lzsa2_2889.sfc.lua
	@echo
	@echo "ABAM (text file, 26582 -> 64115 bytes)"
	@$(mesen) --testrunner $(build_dir)/test_shvc_lzsa2_abam.sfc $(build_dir)/test_shvc_lzsa2_abam.sfc.lua
	@$(mesen) --testrunner $(build_dir)/test_reference_lzsa2_abam.sfc $(build_dir)/test_reference_lzsa2_abam.sfc.lua

$(obj_dir)/%.o: $(test_src_dir)/%.s $(inc) $(test_data) Makefile $(as)
	@mkdir -p $(@D)
	$(as) -I include --debug-info -o $@ $<

# SHVC-LZSA2 test targets
test_shvc_lzsa2_short_obj := $(addprefix $(obj_dir)/, test_shvc_lzsa2.o data_txt_short.o) $(test_common_obj)
$(build_dir)/test_shvc_lzsa2_short.sfc: $(test_shvc_lzsa2_short_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_shvc_lzsa2_short_obj)
	$(make_test) bench:Benchmark:"SHVC-LZSA2 decompressor" size:LZSA2_DecompressBlock assert_state:Asserts_END:[cpu.a]:51 assert_range:Asserts_END:Destination:$(data_dir)/short.txt done:Tests_DONE >$@.lua

test_shvc_lzsa2_2889_obj := $(addprefix $(obj_dir)/, test_shvc_lzsa2.o data_txt_2889.o) $(test_common_obj)
$(build_dir)/test_shvc_lzsa2_2889.sfc: $(test_shvc_lzsa2_2889_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_shvc_lzsa2_2889_obj)
	$(make_test) bench:Benchmark:"SHVC-LZSA2 decompressor" assert_state:Asserts_END:[cpu.a]:32893 assert_range:Asserts_END:Destination:$(data_dir)/2889.txt done:Tests_DONE >$@.lua

test_shvc_lzsa2_abam_obj := $(addprefix $(obj_dir)/, test_shvc_lzsa2.o data_txt_abam.o) $(test_common_obj)
$(build_dir)/test_shvc_lzsa2_abam.sfc: $(test_shvc_lzsa2_abam_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_shvc_lzsa2_abam_obj)
	$(make_test) bench:Benchmark:"SHVC-LZSA2 decompressor" assert_state:Asserts_END:[cpu.a]:64115 assert_range:Asserts_END:Destination:$(data_dir)/abam.txt done:Tests_DONE >$@.lua

# Reference LZSA2 test targets
test_reference_lzsa2_short_obj := $(addprefix $(obj_dir)/, test_reference_lzsa2.o decoder_reference_lzsa2.o data_txt_short.o) $(test_common_obj)
$(build_dir)/test_reference_lzsa2_short.sfc: $(test_reference_lzsa2_short_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_reference_lzsa2_short_obj)
	$(make_test) bench:Benchmark:"Reference LZSA2 decompressor" assert_range:Asserts_END:Destination:$(data_dir)/short.txt done:Tests_DONE >$@.lua

test_reference_lzsa2_2889_obj := $(addprefix $(obj_dir)/, test_reference_lzsa2.o decoder_reference_lzsa2.o data_txt_2889.o) $(test_common_obj)
$(build_dir)/test_reference_lzsa2_2889.sfc: $(test_reference_lzsa2_2889_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_reference_lzsa2_2889_obj)
	$(make_test) bench:Benchmark:"Reference LZSA2 decompressor" assert_range:Asserts_END:Destination:$(data_dir)/2889.txt done:Tests_DONE >$@.lua

test_reference_lzsa2_abam_obj := $(addprefix $(obj_dir)/, test_reference_lzsa2.o decoder_reference_lzsa2.o data_txt_abam.o) $(test_common_obj)
$(build_dir)/test_reference_lzsa2_abam.sfc: $(test_reference_lzsa2_abam_obj) $(ld_script) $(ld) Makefile
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(test_reference_lzsa2_abam_obj)
	$(make_test) bench:Benchmark:"Reference LZSA2 decompressor" assert_range:Asserts_END:Destination:$(data_dir)/abam.txt done:Tests_DONE >$@.lua
