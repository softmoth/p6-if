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

        %!rooms<Hill> = IF::Room.new: :name<Hill>, description => q〈
A flat, broad hill interrupts the dense-ish forest here. Only grass and
small bushes grow on the hill.
A small brook runs through the forest.
〉;

        %!rooms<Clearing>.connect('east', %!rooms<Hill>);

    }

    method title () { 'Crypt' }
    method about () {
        # Rakudo heredoc NYI
        join "\n",
            "You've heard there's supposed to be an ancient hidden crypt in these",
            "woods. One containing a priceless treasure. Well, there's only one way",
            "to find out...",
            "",
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
