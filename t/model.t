use v6;
use Test;
use IF::Events;
use IF::Model;

use lib './t';
use TestGame;

my &e := &IF::Events::make-event;

{
    my IF::Events $events .= new;
    my TestGame $game .= new;
    my IF::Model $model .= new(:$events, :$game);

    ok $model, "A new model is created";

    $model.begin;
    is
        $events.log[0],
        e('begin',
            :room($game.initial-room),
            :about($game.about),
            :title($game.title)),
        "Starts with 'begin' event";
    is $events.log[*-1], e('describe-room', :room($game.initial-room)),
        "Start of model describes the initial room";

    $model.do('look');
    is $events.log[*-2 .. *], e('describe-room', :room($game.initial-room)) xx 2,
        "Looking describes the room";
}

done;

# vim:ft=perl6:
