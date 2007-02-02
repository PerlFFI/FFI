use ExtUtils::MakeMaker;

use 5.006;
use File::Temp;

our $LIBS = '-lavcall -lcallback';
my $probe = "ffcall-probe";

assert_ffcall();

WriteMakefile(
    'NAME'      => 'FFI',
    'AUTHOR'    => 'Paul Moore <gustav@morpheus.demon.co.uk>',
    'ABSTRACT'  => 'Foreign Function Interface for Perl',
    'VERSION_FROM' => 'FFI.pm',
    'PM'        => { 'FFI.pm' => '$(INST_LIBDIR)/FFI.pm',
                     'Library.pm' => '$(INST_LIBDIR)/FFI/Library.pm',
		   },
    'LIBS'      => [$LIBS],
    'DEFINE'    => ($^O eq "MSWin32" ? '-DWIN32' : ''),
    'clean'     => { FILES => "$probe.*" },
);

exit 0;

########################################################################

sub assert_ffcall {
    open my $fh, ">", "$probe.c" or die "open: $!";
    print $fh <<'.';
#include <avcall.h>
#include <callback.h>
#include <trampoline_r.h>

int
main(int argv, char ** argc) {
    /* this isn't really intended to be run */
    __TR_function cb = alloc_callback(&main, 0);
    free_callback(cb);
}
.
    close $fh or die "close: $!";

    # this is probably not the cleanest way to get the CC. But I want to
    # use EU::MM in the 1.0x line of this module.
    require ExtUtils::MM;
    my $mm = MM->new({NAME => 'FFI'});

    print "$mm->{CC} $LIBS $probe.c 2> $probe.err\n";
    system "$mm->{CC} $LIBS -o $probe.exe $probe.c 2> $probe.err" and die << ".";
*** ffcall probe compilation failed. Do you have the ffcall library (and
    its development files) installed? If not, you can fetch it at:

        http://directory.fsf.org/ffcall.html

    The compilation error messages are available at $probe.err .

.
    
    unlink "$probe.$_" for qw(c o exe err);
}
