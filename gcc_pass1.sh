# https://linuxfromscratch.org/lfs/view/stable/chapter05/gcc-pass1.html

pkg="gcc-11.2.0"
mpfr="mpfr-4.1.0"
gmp="gmp-6.2.1"
mpc="mpc-1.2.1"

echo "$(tput bold)$(tput setaf 4)GCC Pass 1 $(tput sgr0)";

# check in binutils has been extracted
if [ ! -d "$VDX/.build/sources/$pkg" ]; then
	tar -xvf $VDX/.build/sources/$pkg.tar.xz -C $VDX/.build/sources	
fi

# check if build directory exists
if [ ! -d "$VDX/.build/sources/$pkg/build" ]; then
	mkdir -v $VDX/.build/sources/$pkg/build
fi

# check if build stage is "configure"
if [[ -e $VDX/.build/sources/$pkg/build/.stage.config ]] 
then   
	echo "$(tput setaf 6)Starting configure stage...$(tput sgr0)";

	cd $VDX/.build/sources/$pkg

	tar -xf ../$mpfr.tar.xz
	mv -v $mpfr mpfr
	tar -xf ../$gmp.tar.xz
	mv -v $gmp gmp
	tar -xf ../$mpc.tar.gz
	mv -v $mpc mpc

	case $(uname -m) in
  	x86_64)
    		sed -e '/m64=/s/lib64/lib/' \
        	-i.orig gcc/config/i386/t-linux64
 	;;
	esac

	cd $VDX/.build/sources/$pkg/build

	../configure                  \
    	--target=$VDX_TGT         \
    	--prefix=$VDX/.build/tools       \
    	--with-glibc-version=2.35 \
    	--with-sysroot=$VDX/system       \
    	--with-newlib             \
    	--without-headers         \
    	--enable-initfini-array   \
    	--disable-nls             \
    	--disable-shared          \
    	--disable-multilib        \
    	--disable-decimal-float   \
    	--disable-threads         \
    	--disable-libatomic       \
    	--disable-libgomp         \
    	--disable-libquadmath     \
    	--disable-libssp          \
    	--disable-libvtv          \
    	--disable-libstdcxx       \
    	--enable-languages=c,c++

	# check if configure was succesful
	if [ $? -eq 0 ]; then
   		mv .stage.config .stage.compile
	else
   		echo "$(tput bold)$(tput setaf 1)Error: failed to configure GCC Pass 1 $(tput sgr0)";
		return 1; # return an error code
	fi



# check if build stage is "make"
elif [[ -e $VDX/.build/sources/$pkg/build/.stage.compile ]]
then
	echo "$(tput setaf 6)Starting make stage...$(tput sgr0)";

	cd $VDX/.build/sources/$pkg/build

	make

	# check if make was succesful
	if [ $? -eq 0 ]; then
   		mv .stage.compile .stage.install
	else
   		echo "$(tput bold)$(tput setaf 1)Error: failed to compile GCC Pass 1 $(tput sgr0)";
		return 1; # return error code
	fi
	




# check if build stage is "make install"
elif [[ -e $VDX/.build/sources/$pkg/build/.stage.install ]]
then
	echo "$(tput setaf 6)Starting make install stage...$(tput sgr0)";

	cd $VDX/.build/sources/$pkg/build
	make install 

	# check if make install was succesful
	if [ $? -eq 0 ]; then

		cd ..
		cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  		`dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.

   		rm -r .stage.install
	else
   		echo "$(tput bold)$(tput setaf 1)Error: failed to make install GCC Pass 1 $(tput sgr0)";
		return 1; # return error code
	fi


else
	touch $VDX/.build/sources/$pkg/build/.stage.config
fi
