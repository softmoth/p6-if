class IF::View {
    has $.events;

    submethod BUILD (:$!events!) {
        $!events.listen:
            'begin' => { self.if-begin() },
            'enter-room' => { self.enter-room(.attrs<room>) },
            'describe-room' => { self.describe-room(.attrs<room>) },
            ;
    }

    method if-begin () { !!! }
    method enter-room (Str $tag) { !!! }
    method describe-room (Str $tag) { !!! }
}

# vim:set ft=perl6:
