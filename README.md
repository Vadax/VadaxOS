# VadaxOS
VadaxOS is an experimental minimal Linux operating system that features a custom filesystem hierarchy and C++ development environment built around (Clang, Cmake, LLVM, Musl).

## Filesystem Hierarchy Structure

- /apps   "Installation directory for multi-user applications not part of core system (web browser, games, text edtor, ...)"
- /mount  "Temporary mount points for mounting storage devices (usb, ...)"
- /net    "Were differant servers are installed (web, messaging, database, ...)"
- /system "Contains the core operating system and supporting programs and librarys"
- /users  "Contains users home directors"
