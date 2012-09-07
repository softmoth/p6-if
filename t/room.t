use v6;
use Test;

use IF::Room;

my $r1 = IF::Room.new: :name('Room One'), description => q〈
Line 1
Line 2


Line 3

Line 4
Line 5
〉;

my $r2 = IF::Room.new: :name('Room Two'), description => q〈
Description of Room Two here.
〉;

$r1.connect(south, $r2);

is $r1.name, 'Room One', "Name";
is $r1.description, "Line 1\nLine 2\n\nLine 3\n\nLine 4\nLine 5", "Description";

is $r1.exits<south>, $r2, "Connect rooms from A to B";
is $r2.exits<north>, $r1, "Connect rooms from B to A";

done;

# vim:set ft=perl6:
