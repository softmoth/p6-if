use Test;
use IF::Events;
use IF::Engine;

my &e := &IF::Events::makeEvent;

{
    my IF::Engine $engine .= new;
    ok $engine, "A new engine is created";
    $engine.begin(:room<Saloon>);
    is $engine.events[0], e('IFBegins', :room<Saloon>),
        "Starts with IFBegins";
    is $engine.events[*-1], e('DescribesRoom', :room<Saloon>),
        "Start of engine describes the initial room";

    $engine.do('look');

    is $engine.events[*-2 .. *], e('DescribesRoom', :room<Saloon>) xx 2,
        "Looking describes the room";
}

done;

# vim:ft=perl6:
