class IF::View {
    has $.events;
    has &.do-command;

    submethod BUILD (:$!events!, :&!do-command!) {
        $!events.listen:
            'begin' => { self.if-begin() },
            'enter-room' => { self.in-room(.attrs<room>) },
            'describe-room' => { self.describe-room(.attrs<room>) },
            ;
    }

    method prompt (Str $tag) { !!! }
    method if-begin () { !!! }
    method in-room (Str $tag) { !!! }
    method describe-room (Str $tag) { !!! }
}

# vim:set ft=perl6:
