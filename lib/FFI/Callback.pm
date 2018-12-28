package FFI::Callback;

use strict;
use warnings;

# this class is entirely implemented in XS,
# which is loaded by FFI
require FFI;

1;

=head1 NAME

FFI::Callback - Call Perl from a compiled language

=head1 SYNOPSIS

 use FFI;
 # $cb is an instance of FFI::Callback
 my $cb = FFI::callback(...);

=head1 DESCRIPTION

The callback object allows you to wrap Perl code in a closure and
call it from a compiled language like C.  For details see the 
documentation for the L<FFI> module.

=head1 METHODS

=head2 addr

 my $address = $cb->addr;

Returns the pointer address of the callback which can be called from
C space.

=head1 SEE ALSO

=over 4

=item L<FFI>

=back
