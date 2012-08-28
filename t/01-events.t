use Test;

use IF::Events;

my &e := &IF::Events::make-event;

class IF::Test is IF::Event {}

{
    is e('test', :num<100>, :foo<bar>),
       e('test', :foo<bar>, :num<100>),
       "Event attributes can be listed in any order";
}

{
    my IF::Events::Stream $events .= new;
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
    my IF::Events::Stream $events .= new;

    my %fired;
    sub fired($e) { ++%fired{$e.name}; }

    $events.listen('test' => {
        fired($^event);
        $events.emit('another-event');
    });

    $events.listen('another-event' => &fired);

    $events.emit('test');
    is $events.log(), [e('test'), e('another-event')],
        "Event listeners can generate events";
    is %fired<test>, 1, "test fired one listener";
    is %fired<another-event>, 1, "another-event fired one listener";
}

done;

# vim:set ft=perl6:
