use Test;
BEGIN { plan tests => 5 };

use FFI;
use FFI::Library;

# Load the C and Math libraries
use lib "./t";
use Support;

# Function addresses
$atoi = address($libc, "atoi");
$strlen = address($libc, "strlen");
$pow = address($libm, "pow");

ok(FFI::call($atoi, 'cip', "12"), 12);
ok(FFI::call($atoi, 'cip', "-97"), -97);
ok(FFI::call($pow, 'cddd', 2, 0.5), 2**0.5);
ok(FFI::call($strlen, 'cIp', "Perl"), 4);
ok(1);
