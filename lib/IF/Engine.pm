use IF::Events;

class IF::Engine {
    has $!events;
    has $!event-position = 0;

    has $!room;

    submethod BUILD(:$!events) {
        # FIXME: How to do provide type of $!events in 'has' declaration,
        # and have this assignment happen automatically? And still allow
        # another events handler to override it?
        $!events //= IF::Events::Stream.new;

        $!events.listen('if-begins' => -> $e {
            $!room = $e.attrs<room>;
            $!events.emit('describes-room', :$!room);
        });
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
