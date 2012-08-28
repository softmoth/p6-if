use v6;
use IF::View;

class IF::View::Std does IF::View {
    method header ($msg) { say "== $msg ==\n"; }
    method info ($msg) { say "$msg\n"; }
    method prompt (Str $msg = '') { prompt "$msg> "; }
}

# vim:set ft=perl6:
