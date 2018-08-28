#
# MIT License
#
# Copyright (c) 2018 Guoli Lyu <guoli-lv@hotmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

TARGET = aarch64-unknown-none

OBJCOPY = cargo objcopy --
OBJCOPY_PARAMS = --strip-all -O binary

RUST_BINARY := $(shell cat Cargo.toml | grep name | cut -d\" -f 2)

RUST_BUILD_DIR := target/$(TARGET)
RUST_DEBUG_OUTPUT := $(RUST_BUILD_DIR)/debug/$(RUST_BINARY)
RUST_RELEASE_OUTPUT := $(RUST_BUILD_DIR)/release/$(RUST_BINARY)

BUILD_DIR := build
KERNEL := $(BUILD_DIR)/$(RUST_BINARY)

RUST_DEPS = Cargo.toml $(LD_LAYOUT) src/*


.PHONY: all clean
# .PHONY: all clean check

all: $(KERNEL).img

# check:
# 	cargo check --target=$(TARGET)

$(BUILD_DIR):
	@echo "mkdir build"
	@mkdir -p $@

$(RUST_DEBUG_OUTPUT): $(RUST_DEPS)
	@echo "+ Building $@ [cargo xbuild]"
	cargo xbuild --target=$(TARGET)

$(RUST_RELEASE_OUTPUT): $(RUST_DEPS)
	@echo "+ Building $@ [cargo xbuild --release]"
	cargo xbuild --release --target=$(TARGET)

ifeq ($(DEBUG),1)
$(KERNEL): $(RUST_DEBUG_OUTPUT) | $(BUILD_DIR)
	@cp $< $@
else
$(KERNEL): $(RUST_RELEASE_OUTPUT) | $(BUILD_DIR)
	@cp $< $@
endif

$(KERNEL).img: $(KERNEL) | $(BUILD_DIR)
	$(OBJCOPY) $(OBJCOPY_PARAMS) $< $@

clean:
	cargo clean
	rm -rf $(BUILD_DIR)
