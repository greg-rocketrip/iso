https://packages.debian.org/source/sid/iso-codes

Instructions:
- Create a directory where this data will live (I use `~/data`)
- Extract contents of bootstrap.zip to ~/data/iso
- `cd ~/data/iso` and `make csv`

Requires an internet connection to install.

The Makefile is designed for GNU Make (`gmake` on some systems); it should 
work on macOS/OSX because the system-provided Make is GNU Make, despite being 
a BSD-based system.
