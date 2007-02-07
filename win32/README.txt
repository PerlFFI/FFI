This directory contains headers and binary files compiled from ffcall-1.10
for building FFI.pm on 32-bit Windows environments.

ffcall is Copyrighted by Bruno Haible <haible@ilog.fr> and is licensed
under the GNU General Public License, Version 2 or later. See the COPYING
file in the top level FFI directory for the full text of the license.

ffcall can be obtained at the following URL:

    http://directory.fsf.org/ffcall.html

ffcall consists of four individual libraries of which FFI.pm uses (through
FFI.xs) two: avcall and callback. Their header files and pre-built library
files are included here. There are two sets of library files: *.a files
for gcc, and *.lib files for the Microsoft compiler cl.exe. Which compiler
is used when building XS modules such as FFI.xs usually depends on which
compiler was used to build the Perl installation itself, and is normally
arranged automatically by the MakeMaker during 'perl Makefile.PL'.

We have tested the supplied header and library files in two environments:
Perl-5.8.8 built from scratch with MSVC, and Strawberry Perl, a binary
distribution that uses gcc to build Perl. Strawberry Perl is available from

    http://vanillaperl.com/

When creating libraries with GCC, configure was run thus: 

    ./configure CFLAGS=-O2

to overwrite the distribution's default "-g -O2" which bloated the libraries
with debugging information.

