package FFI::Library;

use strict;
use Carp;
use vars qw($VERSION);
use FFI;

$VERSION = '1.04';

if ($^O eq 'MSWin32') {
    require Win32;
}
else {
    require DynaLoader;
}

sub new {
    my $class = shift;
    my $libname = shift;
    scalar(@_) <= 1
        or croak 'Usage: $lib = new FFI::Library($filename [, $flags])';
    my $lib;
    if ($^O eq 'MSWin32') {
        $lib = Win32::LoadLibrary($libname) or return undef;
    }
    else {
        my $so = $libname;
        -e $so or $so = DynaLoader::dl_findfile($libname) || $libname;
        $lib = DynaLoader::dl_load_file($so, @_)
            or return undef;
    }
    bless \$lib, $class;
}

sub DESTROY {
    if ($^O eq 'MSWin32') {
        Win32::FreeLibrary(${$_[0]});
    }
    else {
        DynaLoader::dl_free_file(${$_[0]})
            if defined (&DynaLoader::dl_free_file);
    }
}

sub function {
    my $self = shift;
    my $name = shift;
    my $sig = shift;
    my $addr;
    if ($^O eq 'MSWin32') {
        $addr = Win32::GetProcAddress(${$self}, $name);
    }
    else {
        $addr = DynaLoader::dl_find_symbol(${$self}, $name);
    }
    croak "Unknown function $name" unless defined $addr;

    sub { FFI::call($addr, $sig, @_); }
}

1;
__END__

=head1 NAME

FFI::Library - Perl Access to Dynamically Loaded Libraries

=head1 SYNOPSIS

    use FFI::Library;
    $lib = FFI::Library->new("mylib");
    $fn = $lib->function("fn", "signature");
    $ret = $fn->(...);

=head1 DESCRIPTION

This module provides access from Perl to functions exported from dynamically
linked libraries. Functions are described by C<signatures>, for details of
which see the L<FFI> module's documentation.

=head1 EXAMPLES

    $clib_file = ($^O eq "MSWin32") ? "MSVCRT40.DLL" : "-lc";
    $clib = FFI::Library->new($clib_file);
    $strlen = $clib->function("strlen", "cIp");
    $n = $strlen->($my_string);

=head1 TODO

=head1 LICENSE

This module can be distributed under the same terms as Perl. However, as it
depends on the L<FFI> module, please note the licensing terms for the FFI
code.

=head1 STATUS

This is a maintenance release. We will be releasing an updated but
incompatible 2.00 version shortly.

=head1 AUTHOR

Paul Moore, C<< <gustav@morpheus.demon.co.uk> >> is the original author
of L<FFI>.

Mitchell Charity C<< <mcharity@vendian.org> >> contributed fixes.

Anatoly Vorobey C<< <avorobey@pobox.com> >> and Gaal Yahas C<<
<gaal@forum2.org> >> are the current maintainers.

=head1 SEE ALSO

The L<FFI> module.

=cut
