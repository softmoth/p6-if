use Test;
use IF::Engine;
use IF::View::Test;

{
    my IF::View $view = IF::View::Test.new;
    my IF::Engine $engine .= new(:$view);
    $view.expect(:info('Describe Saloon'));
    $engine.begin(:room<Saloon>);

    $view.expect(:info('Describe Saloon'));
    $engine.do('look');
}

done;

# vim:ft=perl6:
