######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..5\n"; }
END {print "not ok 1\n" unless $loaded;}
use FFI;
use FFI::Library;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Load the C and Math libraries
use lib "./t";
use Support;

# Function addresses
$atoi = address($libc, "atoi");
$strlen = address($libc, "strlen");
$pow = address($libm, "pow");

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

my $n = 2;

sub ok {
    my ($e1, $e2) = @_;
    print "not " unless $e1 == $e2;
    print "ok ", $n++, " # $e1 == $e2\n";
}

ok 12, FFI::call($atoi, 'cip', "12");
ok -97, FFI::call($atoi, 'cip', "-97");
ok 2**0.5, FFI::call($pow, 'cddd', 2, 0.5);
ok 4, FFI::call($strlen, 'cIp', "Perl");
