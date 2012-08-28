use Test;
use IF::Engine;
use IF::View::Test;

{
    my IF::View $view = IF::View::Test.new;
    my IF::Engine $engine .= new(:$view);

    $view.expect:
        :if-begin< >,
        :in-room<Saloon>,
        :describe-room<Saloon>,
        :prompt< >;
    $engine.begin(:room<Saloon>);

    $view.expect:
        :describe-room<Saloon>,
        :prompt< >;
    $engine.do('look');

    $view.expect;  # Check there are no remaining expectations
}

done;

# vim:ft=perl6:
