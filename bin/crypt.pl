#! /usr/bin/env perl6

use IF::View::Std;
use IF::Engine;

sub MAIN() {
    my $game = IF::Engine.new;
    my $view = IF::View::Std.new(:events($game.events), :do-command({$game.do($_)}));
    $game.begin(:room<Clearing>);
}

# vim:set ft=perl6:
