.PHONY: all clean clean_tools test report
.PRECIOUS: %.lz4 %.lzsa1 %.lzsa2 %.zx0

as := tools/cc65/bin/ca65
ld := tools/cc65/bin/ld65
lz4 := tools/lz4ultra/lz4ultra
lzsa := tools/lzsa/lzsa
zx0 := tools/salvador/salvador
query_dbg := test/query_dbg.py

src_dir := src
build_dir := build
obj_dir := $(build_dir)/obj
data_dir := test/data
ld_script := link.cfg

inc := $(wildcard include/*.inc)

common_obj_list := boot/boot.o boot/init.o boot/header.o

default: $(build_dir)/shcv_lz4.sfc $(build_dir)/shcv_lzsa1.sfc $(build_dir)/shcv_lzsa2.sfc

all: clean default

data := $(data_dir)/short.txt.lz4 $(data_dir)/short.txt.lzsa1 $(data_dir)/short.txt.lzsa2

lz4_obj := $(addprefix $(obj_dir)/,$(common_obj_list) shvc-lz4.o boot/main-lz4.o)
$(build_dir)/shcv_lz4.sfc: $(ld_script) Makefile $(ld) $(lz4_obj)
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(lz4_obj)

lzsa1_obj := $(addprefix $(obj_dir)/,$(common_obj_list) shvc-lzsa1.o boot/main-lzsa1.o)
$(build_dir)/shcv_lzsa1.sfc: $(ld_script) Makefile $(ld) $(lzsa1_obj)
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(lzsa1_obj)

lzsa2_obj := $(addprefix $(obj_dir)/,$(common_obj_list) shvc-lzsa2.o boot/main-lzsa2.o)
$(build_dir)/shcv_lzsa2.sfc: $(ld_script) Makefile $(ld) $(lzsa2_obj)
	$(ld) --dbgfile $(basename $@).dbg -o $@ --config $(ld_script) $(lzsa2_obj)

$(obj_dir)/%.o: $(src_dir)/%.s $(inc) $(data) Makefile $(as)
	@mkdir -p $(@D)
	$(as) -I include --debug-info -o $@ $<

%.lzsa1: % $(lzsa)
	$(lzsa) -v -f1 -r $< $@

%.lzsa2: % $(lzsa)
	$(lzsa) -v -f2 -r $< $@

%.lz4: % $(lz4)
	$(lz4) -v -r $< $@

%.zx0: % $(zx0)
	$(zx0) -v $< $@

$(as):
	@$(MAKE) -C tools/cc65 ca65 -j6

$(ld):
	@$(MAKE) -C tools/cc65 ld65 -j6

$(lz4):
	@$(MAKE) -C tools/lz4ultra -j6

$(lzsa):
	@$(MAKE) -C tools/lzsa -j6

$(zx0):
	@$(MAKE) -C tools/salvador -j6

clean:
	@rm -rf $(build_dir)
	@find $(data_dir) -type f -name "*.lz4" -delete
	@find $(data_dir) -type f -name "*.lzsa1" -delete
	@find $(data_dir) -type f -name "*.lzsa2" -delete
	@find $(data_dir) -type f -name "*.zx0" -delete

clean_all:
	@rm -rf test/__pycache__
	@$(MAKE) clean -C tools/cc65
	@$(MAKE) clean -C tools/lz4ultra
	@$(MAKE) clean -C tools/lzsa
	@$(MAKE) clean -C tools/salvador

report: $(build_dir)/shcv_lz4.sfc $(build_dir)/shcv_lzsa1.sfc $(build_dir)/shcv_lzsa2.sfc
	@$(query_dbg) $(build_dir)/shcv_lz4.dbg size:LZ4_DecompressBlock
	@$(query_dbg) $(build_dir)/shcv_lzsa1.dbg size:LZSA1_DecompressBlock
	@$(query_dbg) $(build_dir)/shcv_lzsa2.dbg size:LZSA2_DecompressBlock

# Tests

make_data_src := test/make_data_src.py
testrunner := test/runner.py

$(obj_dir)/%.o: test/%.s $(inc) Makefile $(as)
	@mkdir -p $(@D)
	$(as) -I include --debug-info -o $@ $<

$(obj_dir)/%.data.o: $(data_dir)/% Makefile $(as)
	@mkdir -p $(@D)
	@$(make_data_src) $(obj_dir)/$*.data.s $(abspath $(data_dir))/$*
	$(as) -I include --debug-info -o $@ $(obj_dir)/$*.data.s
	@rm -f $(obj_dir)/$*.data.s

test:
	@$(testrunner)
