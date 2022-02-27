: 'Copyright 22022 Steven Starr

Redistribution and use in source and binary forms, with or without modification, are permitted provided 
that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and 
the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and 
the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or 
promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR 
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.'

#!/usr/bin/zsh

# Create VADAXOS directory and set the VDX enviroment varable to point to it.
mkdir $PWD/VadaxOS
export VDX="$PWD/VadaxOS"

# Create VadaxOS filesystem hiearchey
mkdir -pv $VDX/{apps,mnt,net} $VDX/system/{bin,boot,dev,ect,include,libs} $VDX/system/build/{sources,tools}

#for i in bin lib; do
#    ln -sv usr/$i $VDX/system/$i
#done

# Create vdx user and set password
groupadd vdx_user
useradd -s /bin/bash -g vdx_user -m -k /dev/null vdx_user
passwd vdx_user

# Change VadaxOS directory permissions to vdx_user
chown -v vdx_user $VDX/{system{,/*}}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac

# Login to vdx_user account
su - vdx_user

# Latest packages src as of 2/26/2022 
SRC[]="https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/clang-13.0.1.src.tar.xz"          # C Compiler
SRC[]="https://cmake.org/files/v3.22/cmake-3.22.2.tar.gz"                                                      # C & C++ build system
SRC[]="https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/compiler-rt-13.0.1.src.tar.xz"    # 
SRC[]="https://github.com/tianocore/edk2/archive/refs/tags/edk2-stable202202.tar.gz"
SRC[]="https://www.kernel.org/pub/software/scm/git/git-2.35.1.tar.gz"                                          # Version Control System
SRC[]="https://github.com/libuv/libuv/archive/refs/tags/v1.43.0.tar.gz"                                        # Asynchronous I/O based on event loops.
SRC[]="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.16.11.tar.xz"                                      # Operating System Kernel
SRC[]="https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/llvm-13.0.1.src.tar.xz"           # C++ Compiler and Toolchain
SRC[]="https://musl.libc.org/releases/musl-1.2.2.tar.gz"                                                       # Standard C Library
SRC[]="https://github.com/ninja-build/ninja/archive/refs/tags/v1.10.2.tar.gz"                                  # 
SRC[]="https://cfhcable.dl.sourceforge.net/project/refind/0.13.2/refind-src-0.13.2.tar.gz"                     # UEFI Bootmanager & Loader             
SRC[]="https://github.com/landley/toybox/archive/refs/tags/0.8.6.tar.gz"
SRC[]="https://www.zsh.org/pub/zsh-5.8.1.tar.xz"								# Z Shell


# 


# Bownload src packages to src/ dir
for i in "${SRC[@]}"
do
   wget "$i" -P src/
done
