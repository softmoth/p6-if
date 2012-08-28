use Test;

use IF::Events;

my &e := &IF::Events::make-event;

{
    is e('test', :num<100>, :foo<bar>),
       e('test', :foo<bar>, :num<100>),
       "Event attributes can be listed in any order";
}

{
    my IF::Events $events .= new;
    $events.emit('event');
    $events.emit('test', :num<100>, :foo<bar>);
    $events.emit('some-event', :what<Something>);

    is $events.last(), e('some-event', :what<Something>),
        "Logs most recent event";

    is $events.log(1), [
            e('test', :foo<bar>, :num<100>),
            e('some-event', :what<Something>)
        ], "Logs all events";
}

{
    my IF::Events $events .= new;

    my %fired;
    sub fired($e) { ++%fired{$e.name}; }

    $events.listen:
        'test' => {
            fired($^event);
            $events.emit('another-event');
        },
        'another-event' => &fired,
        # Two separate 'test' listeners, will be counted twice
        'test' => &fired,
        'EOF' => {
            fired($^e);
        };

    $events.emit('test');
    is $events.log(), [e('test'), e('another-event')],
        "Event listeners can generate events";
    is %fired<test>, 2, "test fired two listeners";
    is %fired<another-event>, 1, "another-event fired one listener";
    is %fired<EOF>, 1, "EOF fired one listener";
}

{
    my IF::Events $events .= new;

    my %fired;
    sub fired($e) { ++%fired{$e.name}; }

    $events.listen:
        'test' => &fired,
        'EOF' => {
            fired($_);
            die "Recursion test" if %fired{.name} > 5;
            $events.emit('test') if %fired{.name} < 5;
        };

    lives_ok { $events.emit('begin') }, "Conditional emit from EOF listener stops recursion";
    is %fired<test>, 4, "test fired correct number of times";
    is %fired<EOF>, 5, "EOF fired correct number of times";
}
done;

# vim:set ft=perl6:
