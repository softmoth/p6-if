use v6;
use IF::Game;

use IF::Room;

class TestGame does IF::Game {
    has %.rooms;

    submethod BUILD {
        %!rooms<Saloon> = IF::Room.new: :name<Saloon>, description => q<<
It feels more like a large closet than a room. The walls seem to be made of scraps of packing materials. One dim light hangs from a piece of wire in the ceiling, illuminating nothing, but still causing a distracting glare. On the far end of the room from the door (about six feet away, that is), a two-by-eight plank serves as the bar.

A single card table, surrounded by four mismatched chairs, fills up most of the available room.
>>;
    }
    method title () { 'Dust Bowl' }
    method about () { "Cowboys\nand\nOutlaws" }
    method initial-room () returns IF::Room { %!rooms<Saloon> }
}

sub MAIN () {
    use IF::Events;
    use IF::Model;
    use IF::View::Plain;

    my IF::Events $events .= new;
    my TestGame $game .= new(:$events);
    my IF::Model $model .= new(:$events, :$game);
    my IF::View $view = IF::View::Plain.new(:$events);

    $model.begin;
}

# vim:set ft=perl6:
