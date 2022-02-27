# VadaxOS
VadaxOS is an experimental minimal Linux operating system that features a custom filesystem hierarchy and C++ development environment built around (clang, cmake, git, linux, llvm, musl, ninja, toybox, zsh).


### Problems we are solveing

#### Freedom to Learn, Create and Experiment in a safe, friendly, and supportive environment.

#### Minimal Core Linux Based OS for C & C++ development.
Today's modern POSIX operating systems have become massively bloated, and often when all we need is to run a webserver we end up installing tens of thousands of unrelated files just to do so. 

#### Create a Custom Filesystem Hierarchy Standard

```
/apps			<- multi-user applications /opt /usr/bin / /usr/local/bin ...
/mnt			<- temp mounted filesystem	/mnt /media /proc 
/net			<- web,email,chat servers run
/system			<- the new /root 
	/bin		<- /bin
	/boot		<- /boot
	/dev		<- /dev
	/etc		<- /etc
	/include	<- kinda like /usr/include but instead for system sdk /include 
	/libs		<- /lib /lib64
/users
```

#### Licensing problems caused by viral open-source licenses.
