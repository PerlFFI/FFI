use strict;
use warnings;
use Test::More;
use FFI;
use FFI::CheckLib qw( find_lib_or_die );
use FFI::Library;

my $lib = FFI::Library->new(find_lib_or_die( lib => "test", libpath => "t/ffi/_build" ));

sub callback1
{
  return $_[0] + $_[1];
}

my $callback1  = FFI::callback("ciii", \&callback1);
my $call_adder = $lib->function("call_adder", 'cioii');

is($call_adder->($callback1->addr, 1,2), 3, 'call_addr->($address,1,2) = 3');

done_testing;
