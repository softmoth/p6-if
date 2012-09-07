use v6;
use Test;
use IF::Events;
use IF::Room;

my $room = IF::Room.new: :name<ROOM>, :description('Description of room ROOM');

{
    use IF::View::Test;

    my IF::Events $events .= new;
    my IF::View $view = IF::View::Test.new(:$events);

    $view.verify;  # View hasn't done anything

    $events.emit('begin', :title<TITLE>, :about<ABOUT>);
    $events.emit('quit');
    $events.emit('no-parse', :input<INPUT>);
    $events.emit('enter-room', :room($room));
    $events.emit('describe-room', :room($room));

    $view.verify:
        'if-begin' => 'TITLE', 'prompt' => '',
        'prompt' => '',  # 'quit' doesn't do anything in View::Test
        'huh' => 'INPUT', 'prompt' => '',
        'enter-room' => ~$room, 'prompt' => '',
        'describe-room' => ~$room, 'prompt' => '',
        ;
}


{
    use IF::Test;
    use IF::View::Plain;

    temp $*IN  = TestIn.new;
    temp $*OUT = TestOut.new(:save($*OUT));

    my IF::Events $events .= new;
    my IF::View::Plain $view .= new(:$events);

    $events.emit('begin', :title<TITLE>, :about<ABOUT>);
    $*OUT.verify('Begin', "== TITLE ==\n\nABOUT\n");
    $events.emit('quit');
    $*OUT.verify('Quit', "Goodbye!\n");
    $events.emit('no-parse', :input<INPUT>);
    $*OUT.verify('Unparsable', rx/ ^ <upper> \N+ <[.?!]> $ /);
    $events.emit('enter-room', :room($room));
    $*OUT.verify('Enter room', "\n== ROOM ==\n");
    $events.emit('describe-room', :room($room));
    $*OUT.verify('Describe room', "\nDescription of room ROOM\n");
}

done;

# vim:ft=perl6:
