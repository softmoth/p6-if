use IF::Events;

class IF::Model {
    has $!events;
    has $!room;  #- Location of PC

    submethod BUILD(:$!events!) {
        $!events.listen:
            'command' => { self.do(.attrs<input>); },
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

    method do($str) {
        $!events.emit('describe-room', :$!room);
    }
}

# vim:set ft=perl6:
