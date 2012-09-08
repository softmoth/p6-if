use v6;
use Test;
use IF::Events;
use IF::View::Test;

use lib './t';
use TestGame;

{
    my IF::Events $events .= new;
    my TestGame $game .= new(:$events);
    my IF::View::Test $view .= new(:$events);

    $view.verify;  # View hasn't done anything

    $game.begin;
    $view.verify:
        'if-begin' => 'Dust Bowl',
        'enter-room' => $game.initial-room,
        'describe-room' => $game.initial-room,
        'prompt' => '';

    $view.input('look');
    $view.verify:
        'describe-room' => $game.initial-room,
        'prompt' => '';

    $view.input('abcde');
    $view.verify:
        'huh' => 'abcde',
        'prompt' => '';

    $view.input('quit');
    $view.verify:
        'exit' => '';
}

done;

# vim:ft=perl6:
