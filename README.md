# rust for raspberry pi 3 template

In the year 2018, rust have advanced a significant step toward embedded system. By August, the workflow have changed a lot, and is no longer the same as that in the beginning of the year, when the experimental course in Stanford CS140e starts.

This repository contains templates for embedded rust on raspberry pi 3.

The master branch is a template for **bare metal** embedded rust on raspberry pi 3.

## Include assembly files

In the previous days, we compile the assembly file to a `.o` object file, and then link the object file from assembly file and that from our main file together.

Nowadays, there is another way to do include assembly files. That is to use global_asm feature.
We can place the assembly file in the `src` folder and include the assembly file in our rust code with global_asm macro.

```rust
#![feature(global_asm)]
global_asm!(include_str!("crt0.S"));
```

## Link ld scripts

To ask linker to link custom ld scritps, we can pass a ld argument to rustc in the .cargo/config file.

```toml
[target.aarch64-unknown-none]
rustflags = [
  "-C", "link-arg=-Tldscripts/layout.ld",
]
```

## Makefile

The steps in makefile is quite straight forward. The core steps are:

- build with cargo-xbuild
- use objcopy to get the final binary file.

And the makefile is just a wrapper for the following commands.

```bash
$ export binary=rust-for-raspberry-pi-3-template
$ cargo xbuild check --target=aarch64-unknown-none --release
$ cargo objcopy -- --strip-all -O binary target/aarch64-unknown-none/release/$(binary) build/$(binary)
```
