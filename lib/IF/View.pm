class IF::View {
    has $.events;

    submethod BUILD (:$!events!) {
        $!events.listen:
            'begin' => { self.if-begin(.attrs) },
            'enter-room' => { self.enter-room(.attrs) },
            'describe-room' => { self.describe-room(.attrs) },
            ;
    }

    method if-begin (%attrs) { !!! }
    method enter-room (%attrs) { !!! }
    method describe-room (%attrs) { !!! }
}

# vim:set ft=perl6:
