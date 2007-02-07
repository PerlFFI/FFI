This directory contains headers and binary files compiled from ffcall-1.10
for building FFI.pm on 32-bit Windows environments.

ffcall is Copyrighted by Bruno Haible <haible@ilog.fr> and is licensed
under the GNU General Public License, Version 2 or later. See the COPYING
file in the top level FFI directory for the full text of the license.

ffcall can be obtained at the following URL:

    http://directory.fsf.org/ffcall.html

ffcall consists of four individual libraries, of which FFI.pm uses two,
through FFI.xs: avcall and callback. Their header files and pre-built
library files are included here. There are two sets of library files:
*.a files for gcc, and *.lib files for the Microsoft compiler cl.exe.
Which compiler is used when building XS modules such as FFI.xs usually
depends on which compiler was used to build the Perl installation
itself, and is normally arranged automatically by the MakeMaker
during 'perl Makefile.PL'.

We have tested the supplied header and library files in three
environments:

* ActivePerl 817
* Perl-5.8.8 built from scratch with MSVC
* Strawberry Perl, a binary distribution that uses MinGW/MSYS and
  GCC to build Perl.

Strawberry Perl is available from:

    http://vanillaperl.com/


ffcall build options with MSYS
------------------------------

If you merely wish to use one of these FFI.pm on one of these
platforms, you do not need to read this section.

To build ffcall for use with Strawberry Perl, you actually need
some additional development packages. We installed the "MSYS DTK"
from here:

    http://www.mingw.org/download.shtml

This gave us a shell in which we could run configure, which we did thus:

    ./configure CFLAGS=-O2

This overwrites the distribution's default "-g -O2" which bloated the
libraries with debugging information.

