#! /usr/bin/env perl6

use IF::Events;
use IF::Model;
use IF::View::Plain;

sub MAIN() {
    my IF::Events $events .= new;
    my IF::Model $model .= new(:$events);
    my IF::View $view = IF::View::Plain.new(:$events);
    $model.begin(:room<Clearing>);
}

# vim:set ft=perl6:
