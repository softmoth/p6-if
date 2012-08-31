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
            'quit' => { $!events.emit('exit') },
            ;
    }

    method begin(:$room!) {
        $!events.emit('begin', :$room);
    }

    method do($str is copy) {
        $str //= 'quit';
        given $str {
            when 'look' { $!events.emit('describe-room', :$!room); }
            when 'quit' { $!events.emit('quit'); }
            default { $!events.emit('no-parse', :input($str)) }
        }
    }
}

# vim:set ft=perl6:
