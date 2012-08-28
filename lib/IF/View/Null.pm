use v6;
use IF::View;

class IF::View::Null does IF::View {
    method header ($msg) { }
    method info ($msg) { }
    method prompt (Str $msg = '') { }
}

# vim:set ft=perl6:
