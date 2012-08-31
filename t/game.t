use v6;
use Test;
use IF::Events;

use lib './t';
use TestGame;

{
    my IF::Events $events .= new;
    my TestGame $game .= new(:$events);

    is $game.initial-room, 'Saloon', "Initial room";
    is $game.title, 'Dust Bowl', "Title";
    is $game.about, "Cowboys\nand\nOutlaws\n", "About";
}

done;

# vim:ft=perl6:
