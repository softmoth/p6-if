use Test;
use IF::Engine;
use IF::View::Test;

{
    my IF::Engine $game .= new;
    my IF::View $view = IF::View::Test.new(:events($game.events), :do-command({ $game.do($_) }));

    $view.expect:
        :if-begin< >,
        :in-room<Saloon>,
        :describe-room<Saloon>,
        :prompt< >;
    $game.begin(:room<Saloon>);

    $view.expect:
        :describe-room<Saloon>,
        :prompt< >;
    $view.input('look');

    $view.expect;  # Check there are no remaining expectations
}

done;

# vim:ft=perl6:
