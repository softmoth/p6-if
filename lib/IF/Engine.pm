use IF::Events;
use IF::View;
use IF::View::Null;

class IF::Engine {
    has $.events;

    has $!room;  #- Location of PC

    submethod BUILD() {
        $!events = IF::Events.new;
        $!events.listen:
            'begin' => {
                $!room = .attrs<room>;
                $!events.emit('enter-room', :$!room);
            },
            'enter-room' => {
                $!events.emit('describe-room', :room(.attrs<room>));
            },
            ;
    }

    method begin(:$room!) {
        $!events.emit('begin', :$room);
    }

    method history() {
        return $!events.log;
    }

    method do($str) {
        $!events.emit('describe-room', :$!room);
    }
}

# vim:set ft=perl6:
