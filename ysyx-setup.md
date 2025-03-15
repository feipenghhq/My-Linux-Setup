# YSYX Setup

## Install Tools for NJU ICS PA

### Basic tools

```bash
sudo apt-get install build-essential    # build-essential packages, include binary utilities, gcc, make, and so on
sudo apt-get install man                # on-line reference manual
sudo apt-get install gcc-doc            # on-line reference manual for gcc
sudo apt-get install gdb                # GNU debugger
sudo apt-get install libreadline-dev    # C readline library
sudo apt-get install libsdl2-dev        # C sdl2 library
sudo apt-get install bison              # used by kconfig
sudo apt-get install flex               # used by kconfig
sudo apt-get install ffmpeg
```

### ccache

ccache increase compile time of gcc

```bash
sudo apt-get install ccache
```

Add ccache to PATH environment

```bash
echo "" >> ~/.bashrc
echo "# ccache setup" >> ~/.bashrc
echo "export PATH=\"/usr/lib/ccache:\$PATH\"" >> ~/.bashrc
```

### RISC-V Cross Compiler

```bash
sudo apt-get install g++-riscv64-linux-gnu binutils-riscv64-linux-gnu gcc-riscv64-linux-gnu
```

## Setup YSYX Repos

Note: All the repos are my developed version

### Create YSYX folder

```bash
cd <location you want to place the repo>
mkdir YSYX && cd YSYX
echo "" >> ~/.bashrc
echo "# YSYX PATH" >> ~/.bashrc
echo "export YSYX=$PWD" >> ~/.bashrc
```

### Clone Repos and Setup path

```bash
git clone git@github.com:feipenghhq/ics2023.git         # NJU ICS
git clone git@github.com:feipenghhq/ysyx-npc.git        # YSYX NPC
git clone git@github.com:feipenghhq/ysyxSoC.git         # YSYX SOC

# Add PATH to .bashrc
cd $YSYX
echo "" >> ~/.bashrc
echo "# YSYX HOME PATH" >> ~/.bashrc
echo "export NEMU_HOME=$PWD/ics2023/nemu" >> ~/.bashrc
echo "export AM_HOME=$PWD/ics2023/abstract-machine" >> ~/.bashrc
echo "export FCEUX_AM_HOME=$PWD/ics2023/fceux-am" >> ~/.bashrc
echo "export NAVE_HOME=$PWD/ics2023/navy-apps" >> ~/.bashrc
echo "export NANOS_HOME=$PWD/ics2023/nanos-lite" >> ~/.bashrc
echo "export AM_KERNELS_HOME=$PWD/ics2023/am-kernels" >> ~/.bashrc
echo "export AM_YSYX_HOME=$PWD/ics2023/am-ysyx" >> ~/.bashrc
echo "export NPC_HOME=$PWD/npc" >> ~/.bashrc
source ~/.bashrc
```

### ICS setup

```bash
# ICS Setup
cd $YSYX/ics2023
git branch -m master
bash init.sh nemu
bash init.sh abstract-machine
bash init.sh am-kernels
git checkout ysyxSoC            # Check out the desired branch
```

### NEMU setup and sanity check
```bash
# nemu build
cd $YSYX/ics2023/nemu
make menuconfig     # Setup the nemu config
make                # Build nemu executable
```

#### Run sanity check on NEMU

Run cpu-test dummy to make sure the cross compiler works.

Create a run_batch target in the Makefile so that we don't need to manual run the program in NEMU shell

```bash
cd $YSYX/ics2023/am-kernels/tests/cpu-tests
```

Add the following to the Makefile

```makefile
run_batch: all
	@cat $(RESULT)
	@rm $(RESULT)
```

Now, run the `dummy` test. In case of compile error, check out [riscv 32 compile error](#riscv-32-compile-error) session.

```bash
make run_batch ARCH=riscv32-nemu ALL=dummy
```

If `dummy` test passes, then run all the tests

```bash
make run_batch ARCH=riscv32-nemu
```

Once all the test passes, try `bad-apple`

```bash
cd $YSYX/ics2023/am-kernels/kernels/bad-apple
make run_batch ARCH=riscv32-nemu
```

## NPC Setup and sanity check

## Backup

### riscv 32 compile error

Error #1
```
/usr/riscv64-linux-gnu/include/bits/wordsize.h:28:3: error: #error "rv32i-based targets are not supported"
```

```diff
--- /usr/riscv64-linux-gnu/include/bits/wordsize.h
+++ /usr/riscv64-linux-gnu/include/bits/wordsize.h
@@ -25,5 +25,5 @@
 #if __riscv_xlen == 64
 # define __WORDSIZE_TIME64_COMPAT32 1
 #else
-# error "rv32i-based targets are not supported"
+# define __WORDSIZE_TIME64_COMPAT32 0
 #endif
```

Error #2
```
/usr/riscv64-linux-gnu/include/gnu/stubs.h:8:11: fatal error: gnu/stubs-ilp32.h: No such file or directory
```

```diff
--- /usr/riscv64-linux-gnu/include/gnu/stubs.h
+++ /usr/riscv64-linux-gnu/include/gnu/stubs.h
@@ -5,5 +5,5 @@
 #include <bits/wordsize.h>

 #if __WORDSIZE == 32 && defined __riscv_float_abi_soft
-# include <gnu/stubs-ilp32.h>
+//# include <gnu/stubs-ilp32.h>
 #endif
```