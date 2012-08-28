use IF::Events;
use IF::View;
use IF::View::Null;

class IF::Engine {
    has $!view;
    has $!events;
    # TODO: Move this into IF::Events::Stream?
    has $!event-position = 0;  #- Start of this frame of events

    has $!room;  #- Location of PC

    submethod BUILD(:$!view, :$!events) {
        # FIXME: How to provide type of $!view, $!events, etc. in 'has'
        # declaration, and still allow another instance to override it?
        $!view //= IF::View::Null.new;

        $!events //= IF::Events::Stream.new;
        $!events.listen:
            'if-begins' => -> $e {
                $!room = $e.attrs<room>;
                $!events.emit('describes-room', :$!room);
            },
            'describes-room' => -> $e {
                $!view.info("Describe {$e.attrs<room>}");
            };
    }

    method begin(:$room!) {
        $!events.emit('if-begins', :$room);
    }

    method events() {
        return $!events.log($!event-position);
    }

    method history() {
        return $!events.log;
    }

    method do($str) {
        $!events.emit('describes-room', :$!room);
    }
}

# vim:set ft=perl6:
