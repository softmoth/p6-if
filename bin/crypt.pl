#! /usr/bin/env perl6

use v6;
use IF::Events;
use IF::Game;
use IF::Model;
use IF::View::Plain;

class Crypt does IF::Game {
    has $!events;

    submethod BUILD (:$!events!) {}

    method title () { 'Crypt' }
    method about () {
        [~]
            "Story and gameplay from Carl Mäsak´s crypt:\n",
            "  https://github.com/masak/crypt\n",
            "Copyright 2012, Tim Smith <tim.dolores@gmail.com>\n",
            ;
    }

    method initial-room () { 'Clearing' }
}

sub MAIN() {
    my IF::Events $events .= new;
    my Crypt $game .= new(:$events);
    my IF::Model $model .= new(:$events, :$game);
    my IF::View $view = IF::View::Plain.new(:$events);

    $model.begin;
}

# vim:set ft=perl6:
