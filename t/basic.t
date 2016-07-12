use strict;
use warnings;
use Test::More;
use FFI;
use FFI::Library;

# Load the C and Math libraries
use lib "./t";
use Support;

our $libc;
our $libm;

# Function addresses
my $atoi = address($libc, "atoi");
my $strlen = address($libc, "strlen");
my $pow = address($libm, "pow");

is FFI::call($atoi, 'cip', "12"),         12, 'atoi(12)';
is FFI::call($atoi, 'cip', "-97"),       -97, 'atoi(-97)';
is FFI::call($pow, 'cddd', 2, 0.5),   2**0.5, 'pow(2,0.5)';
is FFI::call($strlen, 'cIp', "Perl"),      4, 'strlen("Perl")';

sub callback1
{
  return $_[0] + $_[1];
}

my $callback1 = FFI::callback("ciii", \&callback1);
is FFI::call($callback1->addr, "ciii", 1,2), 3, 'callback1(1,2) = 3';

sub callback2
{
  my($address, $a, $b) = @_;
  return FFI::call($address, "ciii", $a, $b);
}

my $callback2 = FFI::callback("ciLii", \&callback2);
is FFI::call($callback2->addr, "ciLii", $callback1->addr, 3, 4), 7, 'callback2(\&callback1, 3,4) = 7';

done_testing;
