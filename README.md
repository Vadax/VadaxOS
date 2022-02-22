# VadaxOS
VadaxOS is an experimental minimal Linux operating system that features a custom filesystem hierarchy and C++ development environment built around (Clang, Cmake, LLVM, Musl).


### Problems we are solveing

#### Freedom to Learn, Create and Experiment in a safe, friendly, and supportive environment.

#### Minimal Core Linux Based OS for C & C++ development.
Today's modern POSIX operating systems have become massively bloated, and often when all we need is to run a webserver we end up installing tens of thousands of unrelated files just to do so. 

#### Create a Custom Filesystem Hierarchy Standard

- /apps   "Installation directory for multi-user applications not part of core system (web browser, games, text editor, ...))"
- /mount  "Temporary mount points for mounting storage devices (USB, ...)"
- /net    "Were different servers are installed (web, messaging, database, ...)"
- /system "Contains the core operating system and supporting programs and libraries"
- /users  "Contains users home directors"

#### Licensing problems caused by viral open-source licenses.
