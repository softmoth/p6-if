use v6;
use Test;
use IF::Events;

use lib './t';
use TestGame;

my &e := &IF::Events::make-event;

{
    my IF::Events $events .= new;
    my TestGame $game .= new(:$events);

    ok $game, "A new game is created";

    is $game.initial-room, 'Room<Saloon>', "Initial room";
    is $game.title, 'Dust Bowl', "Title";
    is $game.about, "Cowboys\nand\nOutlaws", "About";

    $game.begin;

    is
        $events.log[0],
        e('begin',
            :room($game.initial-room),
            :about($game.about),
            :title($game.title)),
        "Starts with 'begin' event";
    is $events.log[*-1], e('describe-room', :room($game.initial-room)),
        "Start of game describes the initial room";

    $events.emit('command', :input<look>);
    is $events.log[*-2 .. *], [e('command', :input<look>), e('describe-room', :room($game.initial-room))],
        "Looking describes the room";
}

done;

# vim:ft=perl6:
