use Test;

use IF::Events;

my &e := &IF::Events::makeEvent;

class IF::Test is IF::Event {}

{
    is e('Test', :num<100>, :foo<bar>),
       e('Test', :foo<bar>, :num<100>),
       "Event attributes can be listed in any order";
}

{
    my IF::Events::Stream $events .= new;
    $events.emit('Event');
    $events.emit('Test', :num<100>, :foo<bar>);
    $events.emit('GameBegins', :room<Somewhere>);

    is $events.last(), e('GameBegins', :room<Somewhere>),
        "Logs most recent event";

    is $events.log(1), [
            e('Test', :foo<bar>, :num<100>),
            e('GameBegins', :room<Somewhere>)
        ], "Logs all events";
}

{
    my IF::Events::Stream $events .= new;

    my %fired;
    sub fired($e) { ++%fired{$e.name}; }

    $events.listen('Test' => {
        fired($^event);
        $events.emit('GameBegins');
    });

    $events.listen('GameBegins' => &fired);

    $events.emit('Test');
    is $events.log(), [e('Test'), e('GameBegins')],
        "Event listeners can generate events";
    is %fired<Test>, 1, "Test fired one listener";
    is %fired<GameBegins>, 1, "GameBegins fired one listener";
}

done;
