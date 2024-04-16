.PHONY: all clean clean_tools test
.PRECIOUS: %.lz4 %.lzsa2 %.zx0

as := tools/cc65/bin/ca65
ld := tools/cc65/bin/ld65
lz4 := tools/lz4ultra/lz4ultra
lzsa := tools/lzsa/lzsa
zx0 := tools/salvador/salvador

src_dir := src
build_dir := build
obj_dir := $(build_dir)/obj
data_dir := test/data
ld_script := link.cfg

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

$(obj_dir)/%.o: $(src_dir)/%.s $(inc) $(data_dir)/short.txt.lz4 $(data_dir)/short.txt.lzsa2 Makefile $(as)
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
