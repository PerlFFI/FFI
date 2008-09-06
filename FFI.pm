package FFI;

use strict;
use Carp;
use vars qw($VERSION @ISA);

require DynaLoader;

@ISA = qw(DynaLoader);
$VERSION = '1.04';

bootstrap FFI $VERSION;

1;
__END__

=head1 NAME

FFI - Perl Foreign Function Interface

=head1 SYNOPSIS

    use FFI;
    $addr = <address of a C function>
    $signature = <function signature>
    $ret = FFI::call($addr, $signature, ...);

    $cb = FFI::callback($signature, sub {...});
    $ret = FFI::call($addr, $signature, $cb->addr, ...);

=head1 DESCRIPTION

This module provides a low-level foreign function interface to Perl. It allows
the calling of any function for which the user can supply an address and
calling signature. Furthermore, it provides a method of encapsulating Perl
subroutines as callback functions whose addresses can be passed to C code.

=head1 FUNCTION SIGNATURES

Function interfaces are defined by I<signatures>. A function's signature is a
string which specifies the function's return type, argument types and calling
convention. The first character of the string is the function's calling
convention. This is one of

    s   The standard calling convention for dynamically linked functions
    c   The calling convention used by C functions

Note that on many platforms, these two calling conventions may be identical.
On the Windows platform, the C<s> code corresponds to the C<stdcall> calling
convention, which is used for most dynamic link libraries.  The C<c> code
corresponds to the C<cdecl> calling convention, which is used for C functions,
such as those in the C runtime library.

The remaining characters of the string are the return type of the function,
followed by the argument types, in left-to-right order. Valid values are based
on the codes used for the L<pack> function, namely

    c	A signed char value.
    C	An unsigned char value.
    s	A signed short value.
    S	An unsigned short value.
    i	A signed integer value.
    I	An unsigned integer value.
    l	A signed long value.
    L	An unsigned long value.
    f	A single-precision float.
    d	A double-precision float.
    p	A pointer.
    v   No value (only valid as a return type).

Note that all of the above codes refer to "native" format values.

The C<p> code as an argument type simply passes the address of the Perl
value's memory to the foreign function. It is the caller's responsibility to
be sure that the called function does not overwrite memory outside that
allocated by Perl.

The C<p> code as a return type treats the returned value as a null-terminated
string, and passes it back to Perl as such. There is currently no support for
functions which return pointers to structures, or to other blocks of memory
which do not contain strings, nor for functions which return memory which the
caller must free.

To pass pointers to strings, use the C<p> code. Perl ensures that strings are
null-terminated for you. To pass pointers to structures, use L<pack>. To pass
an arbitrary block of memory, use something like the following:

    $buf = ' ' x 100;
    # Use $buf via a 'p' parameter as a 100-byte memory block

At the present time, there is no direct support for passing pointers to
'native' types (like int). To work around this, use C<$buf = pack('i', 12);>
to put an integer into a block of memory, then use the C<p> pointer type, and
obtain any returned value using C<$n = unpack('i', $buf);> In the future,
better support may be added (but remember that this is intended as a low-level
interface!)

=head1 EXAMPLES

It is somewhat difficult to provide examples of using this module in
isolation, as it is necessary to (somehow) obtain the address of a function to
call. In general, this task is delegated to higher-level wrapper modules.

However, the standard C<DynaLoader> module returns symbol references via the
C<DynaLoader::dl_find_symbol()> function. While these references are not
documented as being addresses, in practice, they seem to be. Code to obtain
the address of various C library functions can be built around this

    $clib_file = ($^O eq "MSWin32") ? "MSVCRT40.DLL" : "-lc";
    $clib = DynaLoader::dl_findfile($clib_file);
    $strlen = DynaLoader::dl_find_symbol($clib, "strlen");
    $n = FFI::call($strlen, "cIp", $my_string);
    DynaLoader::dl_free_file($clib);

Clearly, code like this needs to be encapsulated in a module of some form...

NOTE: In fact, the DynaLoader interface has problems in ActiveState Perl, and
probably in other binary distributions of Perl. (The issue is related to the
way in which the DynaLoader module is built, and may be addressed in future
versions of Perl). In the interim, the higher-level wrapper module
FFI::Library does not use DynaLoader on Win32 - it uses the (deprecated, but
still available) Win32::LoadLibrary and related calls.

=head1 TODO

=over 4

=item *

Improve support for returning pointers to things other than null-terminated
strings.

=item *

Possibly, improve support for passing pointers to "native" types.

=back

=head1 LICENSE

Substantial portions of the code for this module (the underlying FFI code) are
licensed under the GNU General Public License. Under the terms of that
license, my understanding is that this module has to be distrubuted under that
same license.

My personal preference would be to distribute this module under the same terms
as Perl. However, I understand that this is not possible, given the licensing
of the FFI code.

=head1 STATUS

This is a maintenance release. We will be releasing an updated but
incompatible 2.00 version shortly.

Subversion repository: L<http://svn.openfoundry.org/perlffi/trunk/>

=head1 AUTHOR

Paul Moore, C<< <gustav@morpheus.demon.co.uk> >> is the original author
of L<FFI>.

Mitchell Charity C<< <mcharity@vendian.org> >> and
Reini Urban C<< <RURBAN@cpan.org> >> contributed fixes.

Anatoly Vorobey C<< <avorobey@pobox.com> >> and Gaal Yahas C<<
<gaal@forum2.org> >> are the current maintainers.

=head1 SEE ALSO

L<http://directory.fsf.org/ffcall.html>

Bruno Haible's CLisp Common Lisp implementation, from which the underlying
foreign function interface code was taken.

=cut
