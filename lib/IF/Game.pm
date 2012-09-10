use v6;
use IF::Events;
use IF::Room;

class IF::Game {
    has $!events;
    has $!room;  #- Location of PC

    submethod BUILD(:$!events!) {
        $!events.listen:
            'command' => { self!do(.attrs<input>); },
            'begin' => {
                $!events.emit('enter-room', :room(.attrs<room>));
            },
            'enter-room' => {
                $!room = .attrs<room>;
                $!events.emit('describe-room', :$!room);
            },
            'quit' => { $!events.emit('exit') },
            ;
    }

    method title () { 'A Game' }
    method about () { '' }
    method initial-room () returns IF::Room { !!! }

    method begin() {
        $!events.emit: 'begin',
            :room($.initial-room),
            :title($.title),
            :about($.about),
            ;
    }

    method !do($str is copy) {
        $str //= 'quit';
        $str .= trim;
        given $str {
            when '' {}
            when / ^ ['go' \s+]? (<{ join '|', IF::Room.directions }>) $ / {
                $!events.emit('enter-room', :room($!room.exits{$0}));
            }
            when 'look' { $!events.emit('describe-room', :$!room); }
            when 'quit' { $!events.emit('quit'); }
            default { $!events.emit('no-parse', :input($str)) }
        }
    }
}

# vim:set ft=perl6:
