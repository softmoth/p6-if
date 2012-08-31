use Test;
use IF::Events;
use IF::Model;
use IF::View::Test;

{
    my IF::Events $events .= new;
    my IF::Model $model .= new(:$events);
    my IF::View $view = IF::View::Test.new(:$events);

    $view.verify;  # View hasn't done anything

    $model.begin(:room<Saloon>);
    $view.verify:
        'if-begin' => '',
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
