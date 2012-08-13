use IF::Events;

class IF::Engine {
    has $!events;
    has $!eventPosition = 0;

    has $!room;

    submethod BUILD(:$!events) {
        # FIXME: How to do provide type of $!events in 'has' declaration,
        # and have this assignment happen automatically? And still allow
        # another events handler to override it?
        $!events //= IF::Events::Stream.new;

        $!events.listen('IFBegins' => -> $e {
            $!room = $e.attrs<room>;
            $!events.emit('DescribesRoom', :$!room);
        });
    }

    method begin(:$room!) {
        $!events.emit('IFBegins', :$room);
    }

    method events() {
        return $!events.log($!eventPosition);
    }

    method history() {
        return $!events.log;
    }

    method do($str) {
        $!events.emit('DescribesRoom', :$!room);
    }
}

# vim:set ft=perl6:
