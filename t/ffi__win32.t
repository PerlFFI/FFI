use strict;
use warnings;
use Test::More;
use Cwd;
use FFI;
use FFI::CheckLib qw( find_lib_or_die );
use FFI::Library;

plan skip_all => 'Test requires Windows'
  unless $^O =~ /^(MSWin32|cygwin)$/;

my $lib = FFI::Library->new(find_lib_or_die( lib => "test", libpath => "t/ffi/_build" ));

my $fill_my_string = $lib->function('fill_my_string', 'sIIp');

my $buffer = ' ' x 20;
is($fill_my_string->(20, $buffer), 20);
           # 12345678901234567890
is($buffer, "The quick brown fox\0");

$buffer = ' ' x 500;
is($fill_my_string->(500, $buffer), 45);
$buffer = substr($buffer, 0, 45);
is($buffer, "The quick brown fox jumps over the lazy dog.\0");

done_testing;
