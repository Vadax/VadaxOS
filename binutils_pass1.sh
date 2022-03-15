# https://linuxfromscratch.org/lfs/view/stable/chapter05/binutils-pass1.html

name="binutils"
version="2.38"

echo "$(tput bold)$(tput setaf 4)Bintuils Pass 1 $(tput sgr0)";

# check in binutils has been extracted
if [ ! -d "$VDX/.build/sources/$name-$version" ]; then
	tar -xvf $VDX/.build/sources/$name-$version.tar.xz -C $VDX/.build/sources	
fi

# check if build directory exists
if [ ! -d "$VDX/.build/sources/$name-$version/build" ]; then
	mkdir -v $VDX/.build/sources/$name-$version/build
fi

# check if build stage is "configure"
if [[ -e $VDX/.build/sources/$name-$version/build/.stage.config ]] 
then   
	echo "$(tput setaf 6)Starting configure stage...$(tput sgr0)";


	cd $VDX/.build/sources/$name-$version/build

	../configure --prefix=$VDX/.build/tools \
             	--with-sysroot=$VDX/system \
             	--target=$VDX_TGT   \
             	--disable-nls       \
             	--disable-werror

	# check if configure was succesful
	if [ $? -eq 0 ]; then
   		mv .stage.config .stage.compile
	else
   		echo "$(tput bold)$(tput setaf 1)Error: failed to configure Binutils Pass 1 $(tput sgr0)";
		return 1; # return an error code
	fi



# check if build stage is "make"
elif [[ -e $VDX/.build/sources/$name-$version/build/.stage.compile ]]
then
	echo "$(tput setaf 6)Starting make stage...$(tput sgr0)";

	cd $VDX/.build/sources/$name-$version/build

	make

	# check if make was succesful
	if [ $? -eq 0 ]; then
   		mv .stage.compile .stage.install
	else
   		echo "$(tput bold)$(tput setaf 1)Error: failed to compile Binutils Pass 1 $(tput sgr0)";
		return 1; # return error code
	fi
	


# check if build stage is "make install"
elif [[ -e $VDX/.build/sources/$name-$version/build/.stage.install ]]
then
	echo "$(tput setaf 6)Starting make install stage...$(tput sgr0)";

	cd $VDX/.build/sources/$name-$version/build
	make install 

	# check if make install was succesful
	if [ $? -eq 0 ]; then

   		rm -r .stage.install
	else
   		echo "$(tput bold)$(tput setaf 1)Error: failed to make install Binutils Pass 1 $(tput sgr0)";
		return 1; # return error code
	fi


else
	touch $VDX/.build/sources/$name-$version/build/.stage.config
fi
