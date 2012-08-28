use v6;
use IF::View;

class IF::View::Null is IF::View {
    method prompt (Str $tag = '') {}
    method if-begin () {}
    method in-room (Str $tag) {}
    method describe-room (Str $tag) {}
}

# vim:set ft=perl6:
