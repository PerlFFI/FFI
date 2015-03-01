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
use Devel::CheckLib;

check_lib_or_exit(
  lib    => [qw( avcall callback )],
  header => [qw( avcall.h callback.h )],
);

WriteMakefile(
  'NAME'               => 'FFI',
  'AUTHOR'             => [ 'Graham Ollis <plicease@cpan.org>', 'Paul Moore <gustav@morpheus.demon.co.uk>' ],
  'VERSION_FROM'       => 'lib/FFI.pm',
  'ABSTRACT_FROM'      => 'lib/FFI.pm',
  'LICENSE'            => 'gpl_2',
  'DEFINE'             => ($^O eq "MSWin32" ? '-DWIN32' : ''),
  'MIN_PERL_VERSION'   => '5.008001',
  'LIBS'               => ['-lavcall -lcallback'],
  'CONFIGURE_REQUIRES' => {
    'Devel::CheckLib'     => 0,
    'ExtUtils::MakeMaker' => '6.52',
  },
  'clean'              => {
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
);
