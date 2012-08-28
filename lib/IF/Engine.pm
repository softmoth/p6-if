use IF::Events;
use IF::View;
use IF::View::Null;

class IF::Engine {
    has $!view;
    has $!events;

    has $!room;  #- Location of PC

    submethod BUILD(:$!view, :$!events) {
        # FIXME: How to provide type of $!view, $!events, etc. in 'has'
        # declaration, and still allow another instance to override it?
        $!view //= IF::View::Null.new;

        $!events //= IF::Events.new;
        $!events.listen:
            'begin' => {
                $!room = .attrs<room>;
                $!view.if-begin();
                $!events.emit('enter-room', :$!room);
            },
            'enter-room' => {
                $!view.in-room(.attrs<room>);
                $!events.emit('describe-room', :room(.attrs<room>));
            },
            'describe-room' => { $!view.describe-room(.attrs<room>); },
            'EOF' => { $!view.prompt(); },
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
