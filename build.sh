#!/bin/sh


: 'Copyright 2022 Vadax

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


# https://linuxfromscratch.org/lfs/view/stable/chapter02/hostreqs.html
# check if all required support programs and librarys are installed
# bison
if [ ! -e /usr/bin/bison ]; then
	sudo apt-get install bison
fi

# yacc
if [ ! -h /usr/bin/yacc ]; then
	sudo apt-get install byacc
fi

# m4
if [ ! -e /usr/bin/m4 ]; then
	sudo apt-get install m4
fi

# texinfo
if [ ! -e /usr/bin/texindex ]; then
	sudo apt-get install texinfo
fi

# tar
if [ ! -e /usr/bin/tar ]; then
	sudo apt-get install tar
fi

# xz
if [ ! -e /usr/bin/xz ]; then
	sudo apt-get install xz-utils
fi

# make
if [ ! -e /usr/bin/make ]; then
	sudo apt-get install make
fi

# sed
if [ ! -e /usr/bin/sed ]; then
	sudo apt-get install sed
fi

# gzip
if [ ! -e /usr/bin/gzip ]; then
	sudo apt-get install gzip
fi

# grep
if [ ! -e /usr/bin/grep ]; then
	sudo apt-get install grep
fi

# python3
if [ ! -e /usr/bin/python3 ]; then
	sudo apt-get install python3-minimal
fi

# patch
if [ ! -e /usr/bin/patch ]; then
	sudo apt-get install patch
fi

# perl
if [ ! -e /usr/bin/perl ]; then
	sudo apt-get install perl-base
fi

# gcc
if [ ! -e /usr/bin/gcc ]; then
	sudo apt-get install gcc libc-dev
fi

# g++
if [ ! -e /usr/bin/g++ ]; then
	sudo apt-get install g++
fi

# find
if [ ! -e /usr/bin/find ]; then
	sudo apt-get install findutils
fi

# diff
if [ ! -e /usr/bin/diff ]; then
	sudo apt-get install diffutils
fi

# binutils
if [ ! -e /usr/bin/c++filt ]; then
	sudo apt-get install binutils
fi

# coreutils
if [ ! -e /usr/bin/cat ]; then
	sudo apt-get install coreutils
fi



# https://linuxfromscratch.org/lfs/view/stable/chapter02/aboutlfs.html
# Check if VDX varable is set 
if [ ! -n "$VDX" ]; then        
	export VDX="/mnt/vdx" 
fi



# https://linuxfromscratch.org/lfs/view/stable/chapter02/mounting.html
# Check if /mnt/vdx exist
if [ ! -d "$VDX" ]; then   
	sudo mkdir -pv $VDX
fi

# Check if /mnt/vdx is mounted to device
if ! mount | grep $VDX > /dev/null; then
	sudo mount /dev/sda1 $VDX
fi



# https://linuxfromscratch.org/lfs/view/stable/chapter03/introduction.html
# ALERT WE SHOULD BE ROOT
# check if $VDX/.build/sources dir exist
if [ ! -d "$VDX/.build/sources" ]; then

	if [ "$EUID" -ne 0 ]; then
  		echo "Login to root to exacute these commands"
	else
		echo "I am root and creating .build/sources"
		mkdir -pv $VDX/.build/sources
		chmod -v a+wt $VDX/.build/sources
	fi 
fi



# https://linuxfromscratch.org/lfs/view/stable/chapter04/creatingminlayout.html
# Note: 1. Need to get rid of sbin and the usr dirs
# check if $VDX/system dir exist
if [ ! -d "$VDX/system" ]; then

	if [ "$EUID" -ne 0 ]; then
  		echo "Login to root to exacute these commands"
	else
		echo "I am root and creating .build/sources"
		mkdir -pv $VDX/{apps,mnt,net,users} $VDX/system/{boot,dev,ect,include,var} $VDX/system/usr/{bin,lib,sbin} $VDX/.build/tools

		for i in bin lib; do
  			ln -sv usr/$i $VDX/system/$i
		done
	fi 
fi



# https://linuxfromscratch.org/lfs/view/stable/chapter04/addinguser.html
# check if VDX user exists
if ! id "vdx" &>/dev/null; then

	if [ "$EUID" -ne 0 ]; then
  		echo "Login to root to exacute these commands"
	else
		groupadd vdx
		useradd -s /bin/bash -g vdx -m -k /dev/null vdx
		passwd vdx
	fi 
fi

# check if root owns the directors in $VDX 
if [ -n "$(find $VDX/system -user "0" -print -prune -o -prune)" ]; then
  
	# copy build.sh to $VDX/.build
	cp -a build.sh $VDX/.build/build.sh

	chown -v vdx $VDX/{system{,/*},apps,mnt,net,users,.build{,/*}}
	case $(uname -m) in
  		x86_64) chown -v vdx $VDX/system/lib64 ;;
	esac
fi



# https://linuxfromscratch.org/lfs/view/stable/chapter04/settingenvironment.html
# ALERT WE SHOULD BE VDX
# set bash profiles
if [ "$(id -u -n)" = "vdx" ]; then

# check if ~/.bash_profile
if [ ! -e ~/.bash_profile ]; then

cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

fi

# check if ~/.bashrc exists
if [ ! -e ~/.bashrc ]; then

cat > ~/.bashrc << "EOF"
set +h
umask 022
VDX=/mnt/vdx
LC_ALL=POSIX
VDX_TGT=$(uname -m)-vdx-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$VDX/.build/tools/bin:$PATH
CONFIG_SITE=$VDX/system/usr/share/config.site
export VDX LC_ALL VDX_TGT PATH CONFIG_SITE
EOF

fi

fi



# ALERT WE SHOULD BE ROOT
# move /etc/bash.bashrc to /etc/bash.bashrc.NOUSE as root
if [ ! -e /etc/bash.bashrc.NOUSE ]; then

	if [ ! "$(id -u -n)" = "root" ]; then
		echo -e "We need to move /etc/bash.bashrc to /etc/bash.bashrc.NOUSE as" 
		echo -e "the root user please login as root and exacute build.sh."
	else
		[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE
	fi
fi



# ALERT WE SHOULD BE VDX
# source ~/.bash_profile
if [ ! "$(id -u -n)" = "vdx" ]; then
	echo -e "Log in as VDX and exacute build.sh"
else
	echo -e "You need to uncomment line 277 if you havent source ~/.bash_profile"
	#source ~/.bash_profile
fi



# download src packages
if [ "$(id -u -n)" = "vdx" ]; then

	if [ ! "$(ls -A $VDX/.build/sources)" ]; then   

		wget https://www.linuxfromscratch.org/lfs/downloads/stable/wget-list
		wget --input-file=wget-list --continue --directory-prefix=$VDX/.build/sources

	fi
fi


# download src packages
if [ "$(id -u -n)" = "vdx" ]; then

	# binutils_pass1
	if [[ -e $VDX/.build/.stage.1 ]] 
	then   
		echo "stage 1";
		source binutils_pass1.sh

		# check if binutils_pass1.sh was succesfull
		if [ $? -eq 0 ]; then
   			mv .stage.1 .stage.2
		else
   			echo "$(tput bold)$(tput setaf 1)Error: binutils_pass1.sh failed $(tput sgr0)";
		fi

	# gcc_pass1
	elif [[ -e $VDX/.build/.stage.2 ]] 
	then
		echo "stage 2"; # for debuging

		source $VDX/.build/gcc_pass1.sh

		# check if gcc_pass1.sh was succesful
		if [ $? -eq 0 ]; then
   			mv .stage.2 .stage.3
		else
   			echo "$(tput bold)$(tput setaf 1)Error: gcc_pass1.sh failed $(tput sgr0)";
		fi

	# stage 3
	elif [[ -e $VDX/.build/.stage.3 ]]
	then
		echo "stage 3";

	elif [[ -e $VDX/.build/.stage.4 ]]
	then
		echo "stage 4";
	else  
		touch .stage.1;
	fi
fi

