use Test;
use IF::Events;
use IF::Engine;

my &e := &IF::Events::make-event;

{
    my IF::Engine $engine .= new;
    ok $engine, "A new engine is created";
    $engine.begin(:room<Saloon>);
    is $engine.history[0], e('begin', :room<Saloon>),
        "Starts with 'begin' event";
    is $engine.history[*-1], e('describe-room', :room<Saloon>),
        "Start of engine describes the initial room";

    $engine.do('look');

    is $engine.history[*-2 .. *], e('describe-room', :room<Saloon>) xx 2,
        "Looking describes the room";
}

done;

# vim:ft=perl6:
