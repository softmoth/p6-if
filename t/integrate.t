use v6;
use Test;
use IF::Events;
use IF::Model;
use IF::View::Test;

use lib './t';
use TestGame;

{
    my IF::Events $events .= new;
    my TestGame $game .= new;
    my IF::View::Test $view .= new(:$events);
    my IF::Model $model .= new(:$events, :$game);

    $view.verify;  # View hasn't done anything

    $model.begin;
    $view.verify:
        'if-begin' => 'Dust Bowl',
        'enter-room' => 'Saloon',
        'describe-room' => 'Saloon',
        'prompt' => '';

    $view.input('look');
    $view.verify:
        'describe-room' => 'Saloon',
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
