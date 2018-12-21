package FFI::Library;

use strict;
use warnings;
use Carp ();
use constant _is_win => $^O =~ /^(MSWin32|cygwin|msys2?)$/;

# ABSTRACT: Perl Access to Dynamically Loaded Libraries
# VERSION

sub new
{
  my($class, $libname, $flags) = @_;
  Carp::croak('Usage: $lib = FFI::Library->new($filename [, $flags ])')
    unless @_ <= 3;

  $flags ||= 0;

  if(! defined $libname)
  {
    return bless {
      impl => 'null',
    }, $class;
  }
  elsif(ref $libname and int($libname) == int(\$0))
  {
    return $class->_dl_impl(undef, 0);
  }
  elsif(_is_win)
  {
    return $class->_dl_impl($libname, 0);
  }
  elsif(-e $libname)
  {
    return $class->_dl_impl(
      $libname,
      $flags == 0x01 ? FFI::Platypus::Lang::DL::RTLD_GLOBAL() : 0,
    );
  }
  else
  {
    require DynaLoader;
    my $so = DynaLoader::dl_findfile($libname) || $libname;
    my $handle = DynaLoader::dl_load_file($so, $flags || 0);
    return unless $handle;
    return bless {
      impl => 'dynaloader',
      handle => $handle,
    }, $class;
  }
}

sub _dl_impl
{
  my $class = shift;
  require FFI::Platypus::DL;
  my $handle = FFI::Platypus::DL::dlopen(@_);
  return unless defined $handle;
  bless { impl => 'dl', handle => $handle }, $class;
}

sub function
{
  my($self, $name, $sig) = @_;

  my $addr;

  if($self->{impl} eq 'dl')
  {
    $addr = FFI::Platypus::DL::dlsym($self->{handle}, $name);
  }
  elsif($self->{impl} eq 'dynaloader')
  {
    $addr = DynaLoader::dl_find_symbol($self->{handle}, $name);
  }
  elsif($self->{impl} eq 'null')
  {
    $addr = undef;
  }
  else
  {
    Carp::croak("Unknown implementaton: @{[ $self->{impl} ]}");
  }
  
  Carp::croak("Unknown function $name")
    unless defined $addr;

  require FFI;
  sub { FFI::call($addr, $sig, @_) };
}

sub DESTROY
{
  my($self) = @_;

  if($self->{impl} eq 'dl')
  {
    FFI::Platypus::DL::dlclose($self->{handle});
  }
  elsif($self->{impl} eq 'dynaloader')
  {
    DynaLoader::dl_free_file($self->{handle})
      if defined &DynaLoader::dl_free_file;
  }
  elsif($self->{impl} eq 'null')
  {
    # do nothing
  }
  else
  {
    Carp::croak("Unknown implementaton: @{[ $self->{impl} ]}");
  }
}

1;

=head1 SYNOPSIS

 use FFI::Library;
 $lib = FFI::Library->new("mylib");
 $fn = $lib->function("fn", "signature");
 $ret = $fn->(...);

=head1 DESCRIPTION

This module provides access from Perl to functions exported from dynamically
linked libraries. Functions are described by C<signatures>, for details of
which see the L<FFI> module's documentation.

Newer and better maintained FFI modules such as L<FFI::Platypus> provide more
functionality and should probably be considered for new projects.

=head1 CONSTRUCTOR

=head2 new

 my $lib = FFI::Library->new($libname);

Creates an instance of C<FFI::Library>.

=head1 FUNCTIONS

=head2 function

 my $sub = $lib->function($function_name, $signature");

Creates a code-reference like object which you can call.

=head1 EXAMPLES

 $clib_file = ($^O eq "MSWin32") ? "MSVCRT40.DLL" : "-lc";
 $clib = FFI::Library->new($clib_file);
 $strlen = $clib->function("strlen", "cIp");
 $n = $strlen->($my_string);

=head1 SUPPORT

Please open any support tickets with this project's GitHub repository 
here:

L<https://github.com/Perl5-FFI/FFI/issues>

=head1 SEE ALSO

=over 4

=item L<FFI>

Low level interface to ffcall that this module is based on

=item L<FFI::CheckLib>

Portable functions for finding libraries.

=item L<FFI::Platypus>

Platypus is another FFI interface based on libffi.  It has a more
extensive feature set, and libffi has a less restrictive license.

=item L<Win32::API>

An FFI interface for Perl on Microsoft Windows.

=back

=head1 AUTHOR

Paul Moore, C<< <gustav@morpheus.demon.co.uk> >> is the original author
of L<FFI>.

Mitchell Charity C<< <mcharity@vendian.org> >> contributed fixes.

Anatoly Vorobey C<< <avorobey@pobox.com> >> and Gaal Yahas C<<
<gaal@forum2.org> >> are the current maintainers.

Graham Ollis C<< <plicease@cpan.org >> is the current maintainer

=head1 LICENSE

This software is copyright (c) 1999 by Paul Moore.

This is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License

=cut
