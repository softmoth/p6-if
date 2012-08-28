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
            # Check that emitting from 'EOF' listener doesn't trigger
            # an infinite loop
            $events.emit('test');
        };

    $events.emit('test');
    is $events.log(), [(e('test'), e('another-event')) xx 2],
        "Event listeners can generate events";
    is %fired<test>, 4, "test fired two listeners";
    is %fired<another-event>, 2, "another-event fired one listener";
    is %fired<EOF>, 1, "EOF fired one listener";
}

done;

# vim:set ft=perl6:
