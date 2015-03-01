#perl -w

use Test::More;

if ($^O ne "MSWin32" and $^O ne "cygwin") {
    plan skip_all => 'Windows specific tests';
} else {
    plan tests => 12;
}

use Cwd;
use FFI;
use FFI::Library;

ok $kernel32 = FFI::Library->new("kernel32");
ok $user32   = FFI::Library->new("user32");

ok $GetCurrentDirectory = $kernel32->function('GetCurrentDirectoryA', 'sIIp');
ok $GetWindowsDirectory = $kernel32->function('GetWindowsDirectoryA', 'sIpI');
ok $GetModuleHandle     = $kernel32->function('GetModuleHandleA', 'sII');
ok $GetModuleFileName   = $kernel32->function('GetModuleFileNameA', 'sIIpI');

$d = ' ' x 200;
$n = $GetCurrentDirectory->(200, $d);
$d = substr($d, 0, $n);

($cwd = cwd) =~ s#/#\\#g;
$cwd = Win32::GetCwd() if $^O eq "cygwin";
is $d, $cwd;

$d = ' ' x 200;
$n = $GetWindowsDirectory->($d, 200);
$d = substr($d, 0, $n);

ok -d $d;

ok $h = $GetModuleHandle->(0);

$d = ' ' x 200;
$n = $GetModuleFileName->($h, $d, 200);
$d = substr($d, 0, $n);
$exp = $^O eq "MSWin32" ? $^X : Cygwin::posix_to_win_path($^X);
is $d, $exp;

$EnumWindows = $user32->function("EnumWindows", 'sIII');

$window_count = 0;
$callback_ok = 1;

# Callback
$cb = FFI::callback('sIII', sub {
    my ($hwnd, $lparam) = @_;
    $callback_ok = 0 unless $lparam == 12;
    ++$window_count;
    1;
});

$EnumWindows->($cb->addr(), 12);
ok $callback_ok;
ok $window_count > 0;
