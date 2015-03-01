BEGIN {
  unless(eval q{ use 5.008001; 1}) {
    print "Perl 5.008001 or better required\n";
    exit;
  }
}

use 5.008001;
use Config;
use ExtUtils::MakeMaker;
use Cwd;

my $probe = "ffcall-probe";
my @ffcall_opts = find_ffcall();

WriteMakefile(
  'NAME'             => 'FFI',
  'AUTHOR'           => [ 'Graham Ollis <plicease@cpan.org>', 'Paul Moore <gustav@morpheus.demon.co.uk>' ],
  'VERSION_FROM'     => 'lib/FFI.pm',
  'ABSTRACT_FROM'    => 'lib/FFI.pm',
  'LICENSE'          => 'gpl_2',
  'DEFINE'           => ($^O eq "MSWin32" ? '-DWIN32' : ''),
  'MIN_PERL_VERSION' => '5.008001',
  'clean'            => {
    'FILES' => "$probe.* vc*.pdb FFI.obj FFI.o FFI_def.old FFI-*",
  },
  'META_MERGE'       => {
    'meta-spec' => { version => 2 },
    'resources' => {
      'bugtracker' => {
        'web'  => 'https://github.com/plicease/FFI/issues',
      },
      'homepage' => 'https://github.com/plicease/FFI',
      'repository' => {
        'type' => 'git',
        'url'  => 'https://github.com/plicease/FFI.git',
        'web'  => 'https://github.com/plicease/FFI',
      },
     },
  },
  @ffcall_opts,
);

exit 0;

########################################################################

sub find_ffcall {
    my $libs = '-lavcall -lcallback';

    open my $fh, ">", "$probe.c" or die "open: $!";
    print $fh <<'.';
#include <callback.h>

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

    print "$mm->{CC} $libs $probe.c 2> $probe.err\n";
    if (system "$mm->{CC} $probe.c $libs -o $probe.exe 2> $probe.err") {
        print << ".";
*** ffcall probe compilation failed. Do you have the ffcall library (and
    its development files) installed? If not, you can fetch it at:

        http://directory.fsf.org/wiki/Libffcall

    Alternatively, your OS vendor may have made packages available for you.
    See INSTALL for suggested package names.

    The compilation error messages are available at $probe.err .

.
        # According to http://cpantest.grango.org/wiki/CPANAuthorNotes, this
        # is the preferred method of failing when library dependencies are
        # not met, so that CPAN testers do not send spurious error reports.
        exit 0;
    }

    unlink "$probe.$_" for qw(c o exe err);

    return (LIBS => [$libs]);
}
