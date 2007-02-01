use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'      => 'FFI',
    'AUTHOR'    => 'Paul Moore <gustav@morpheus.demon.co.uk>',
    'ABSTRACT'  => 'Foreign Function Interface for Perl',
    'VERSION_FROM' => 'FFI.pm',
    'PM'        => { 'FFI.pm' => '$(INST_LIBDIR)/FFI.pm',
                     'Library.pm' => '$(INST_LIBDIR)/FFI/Library.pm',
		   },
    'LIBS'      => ['-lavcall -lcallback'],
    'DEFINE'    => ($^O eq "MSWin32" ? '-DWIN32' : ''),
);
