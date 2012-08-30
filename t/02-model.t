use Test;
use IF::Events;
use IF::Model;

my &e := &IF::Events::make-event;

{
    my IF::Events $events .= new;
    my IF::Model $model .= new(:$events);
    ok $model, "A new model is created";
    $model.begin(:room<Saloon>);
    is $events.log[0], e('begin', :room<Saloon>),
        "Starts with 'begin' event";
    is $events.log[*-1], e('describe-room', :room<Saloon>),
        "Start of model describes the initial room";

    $model.do('look');

    is $events.log[*-2 .. *], e('describe-room', :room<Saloon>) xx 2,
        "Looking describes the room";
}

done;

# vim:ft=perl6:
