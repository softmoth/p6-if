#! /usr/bin/env perl6

use v6;
use IF::Events;
use IF::Room;
use IF::Game;
use IF::View::Plain;

class Crypt is IF::Game {
    has $!events;
    has %.rooms;

    submethod BUILD (:$!events!) {
        %!rooms<Clearing> = IF::Room.new: :name('Clearing'), description => q〈
The forest road stops here, and the gaps between the trees widen into a
patch of un-forest. The sky above is clear apart from a few harmless clouds.
〉;
    }

    method title () { 'Crypt' }
    method about () {
        join "\n",
            "Story and gameplay from Carl Mäsak´s crypt:",
            "  https://github.com/masak/crypt",
            "Copyright 2012, Tim Smith <tim.dolores@gmail.com>",
            ;
    }

    method initial-room () { %!rooms<Clearing> }
}

sub MAIN() {
    my IF::Events $events .= new;
    my Crypt $game .= new(:$events);
    my IF::View $view = IF::View::Plain.new(:$events);

    $game.begin;
}

# vim:set ft=perl6:
