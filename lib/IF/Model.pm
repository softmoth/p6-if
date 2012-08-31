use v6;
use IF::Events;

class IF::Model {
    has $!events;
    has $!game;
    has $!room;  #- Location of PC

    submethod BUILD(:$!events!, :$!game!) {
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

    method begin() {
        $!events.emit: 'begin',
            :room($!game.initial-room),
            :title($!game.title),
            :about($!game.about),
            ;
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
