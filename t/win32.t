if ($^O ne "MSWin32") {
    print "1..1\n";
    print "ok 1\n";
    exit 0;
}

print "1..12\n";

use Cwd;
use FFI;
use FFI::Library;

$kernel32 = FFI::Library->new("kernel32") or print "not ";
print "ok 1\n";
$user32 = FFI::Library->new("user32") or print "not ";
print "ok 2\n";

$GetCurrentDirectory = $kernel32->function('GetCurrentDirectoryA', 'sIIp')
    or print "not ";
print "ok 3\n";

$GetWindowsDirectory = $kernel32->function('GetWindowsDirectoryA', 'sIpI')
    or print "not ";
print "ok 4\n";

$GetModuleHandle = $kernel32->function('GetModuleHandleA', 'sII')
    or print "not ";
print "ok 5\n";

$GetModuleFileName = $kernel32->function('GetModuleFileNameA', 'sIIpI')
    or print "not ";
print "ok 6\n";

$d = ' ' x 200;
$n = $GetCurrentDirectory->(200, $d);
$d = substr($d, 0, $n);

($cwd = cwd) =~ s#/#\\#g;
$d eq $cwd or print "not ";
print "ok 7\n";

$d = ' ' x 200;
$n = $GetWindowsDirectory->($d, 200);
$d = substr($d, 0, $n);

-d $d or print "not ";
print "ok 8\n";

$h = $GetModuleHandle->(0);
print "not " unless $h;
print "ok 9\n";

$d = ' ' x 200;
$n = $GetModuleFileName->($h, $d, 200);
$d = substr($d, 0, $n);
print "not " unless $d eq $^X;
print "ok 10\n";

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
print "not " unless $callback_ok;
print "ok 11\n";
print "not " unless $window_count > 0;
print "ok 12\n";
