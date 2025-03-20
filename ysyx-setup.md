# YSYX Setup

- [YSYX Setup](#ysyx-setup)
	- [Install Tools](#install-tools)
		- [Basic Tools](#basic-tools)
		- [RISC-V Cross Compiler](#risc-v-cross-compiler)
		- [Chip Design Tools](#chip-design-tools)
		- [Scala](#scala)
	- [Setup YSYX Repos](#setup-ysyx-repos)
		- [Create YSYX folder](#create-ysyx-folder)
		- [Clone Repos and Setup path](#clone-repos-and-setup-path)
	- [ICS setup](#ics-setup)
		- [Initiate all the sub-repos](#initiate-all-the-sub-repos)
		- [NEMU setup and sanity check](#nemu-setup-and-sanity-check)
	- [NPC setup and sanity check](#npc-setup-and-sanity-check)
		- [NPC repo setup and ics sanity check](#npc-repo-setup-and-ics-sanity-check)
		- [ysyxSoC build and sanity check](#ysyxsoc-build-and-sanity-check)
	- [Error Handling](#error-handling)
		- [riscv 32 compile error](#riscv-32-compile-error)


## Install Tools

### Basic Tools

```bash
sudo apt install build-essential    # build-essential packages, include binary utilities, gcc, make, and so on
sudo apt install man                # on-line reference manual
sudo apt install gcc-doc            # on-line reference manual for gcc
sudo apt install gdb                # GNU debugger
sudo apt install libreadline-dev    # C readline library
sudo apt install libsdl2-dev        # C sdl2 library
sudo apt install ffmpeg				# used to decode music
sudo apt install bison				# used by kconfig
sudo apt install flex				# used by kconfig
sudo apt install kconfig-frontends  # kconfig
sudo apt install llvm				# used by trace disassemble function
```

#### ccache

ccache increase compile time of gcc

```bash
sudo apt install ccache
```

Add ccache to PATH environment

```bash
echo "" >> ~/.bashrc
echo "# ccache setup" >> ~/.bashrc
echo "export PATH=\"/usr/lib/ccache:\$PATH\"" >> ~/.bashrc
```

### RISC-V Cross Compiler

```bash
sudo apt install g++-riscv64-linux-gnu binutils-riscv64-linux-gnu gcc-riscv64-linux-gnu
```

### Chip Design Tools

```bash
sudo apt install gtkwave		# gtkwave
```

#### Verilator

Use manual installation to get the latest Verilator version. Use [Git Quick Install](https://verilator.org/guide/latest/install.html#git-quick-install) instruction from verilator website:

```bash
# Prerequisites:
#sudo apt-get install git help2man perl python3 make autoconf g++ flex bison ccache
#sudo apt-get install libgoogle-perftools-dev numactl perl-doc
#sudo apt-get install libfl2  # Ubuntu only (ignore if gives error)
#sudo apt-get install libfl-dev  # Ubuntu only (ignore if gives error)
#sudo apt-get install zlibc zlib1g zlib1g-dev  # Ubuntu only (ignore if gives error)

git clone https://github.com/verilator/verilator   # Only first time

# Every time you need to build:
unsetenv VERILATOR_ROOT  # For csh; ignore error if on bash
unset VERILATOR_ROOT  # For bash
cd verilator
git pull         # Make sure git repository is up-to-date
git tag          # See what versions exist
#git checkout master      # Use development branch (e.g. recent bug fixes)
#git checkout stable      # Use most recent stable release
#git checkout v{version}  # Switch to specified release version

autoconf         # Create ./configure script
./configure      # Configure and create Makefile
make -j `nproc`  # Build Verilator itself (if error, try just 'make')
sudo make install
```

### Scala

Spinalhdl is based on Scala. Following the [Linux Installation](https://spinalhdl.github.io/SpinalDoc-RTD/master/SpinalHDL/Getting%20Started/Install%20and%20setup.html#linux-installation) instruction from spinalhdl website

```bash
sudo apt-get update
sudo apt-get install openjdk-17-jdk-headless curl git
curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > cs
chmod +x cs
# should find the just installed jdk, agree to cs' questions for adding to your PATH
./cs setup
source ~/.profile
```

Add the coursier environment to `.bashrc`. The coursier environemnt can be found at the end of the `.profile` file. Example:

```bash
# >>> coursier install directory >>>
export PATH="$PATH:/home/feipenghhq/snap/code/187/.local/share/coursier/bin"
# <<< coursier install directory <<<
```

Note: Can't add `source ~/.profile` directly to `.bashrc`, this will create a deadlock issue in oh-my-bash>

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
echo "export NPC_HOME=$PWD/ysyx-npc" >> ~/.bashrc
source ~/.bashrc
```

## ICS setup

### Initiate all the sub-repos

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

## NPC setup and sanity check

### NPC repo setup and ics sanity check

```bash
# Compile cpu-test and bad-apple for npc in ics2023 repo
cd $YSYX/ics2023/am-kernels/tests/cpu-tests
make ARCH=riscv32e-npc
cd $YSYX/ics2023/am-kernels/kernels/bad-apple
make ARCH=riscv32e-npc

# Go to npc repo
cd $YSYX/ysyx-npc

# Setup necessary file from kconfig.
# Disable trace, difftest, and waveform dump. Must disable difftest since it's not fully working
make menuconfig

# Build npc verilator executable
cd sim/ics-pa
make build
make cpu-test
make bad-apple	# Note: bad apple is really slow
```

### ysyxSoC build and sanity check

```bash
cd $YSYX/ysyxSoC

# Pull from the ysyxSoC repo to get the latest update. This is required for `make verilog` to work
# otherwise the comile stage will fail
git pull git@github.com:OSCPU/ysyxSoC.git

# Install mill
curl -L https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/0.12.9/mill -o mill
chmod +x mill

# Replace the mill command in the Makefile to ./mill to point to the local mill command
sed -i 's/mill/\.\/mill/' Makefile

# Initialize ysyxSoC repo and generate verilog
make dev-init
make verilog

# Fix the issue mentioned in Errata.txt

```

Run sanity check in NPC

```bash
cd $YSYX/ysyx-npc/sim/ysyxSoC
make build

cd $YSYX/ics2023/am-ysyx/tests/char-test
make build
make run

# Should print out 'A'
```


## Error Handling

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