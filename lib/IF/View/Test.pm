use v6;
use IF::View;

use Test;

class IF::View::Test does IF::View {
    has @!expectations;

    method expect(*%exp) {
        # Report un-matched expectations as failures
        ok False, "Expected {.key} '{.value}'" for @!expectations;

        @!expectations = %exp;
    }

    method !validate-expectation($type, $tag) {
        $_ = @!expectations.shift // :error('no expectations');
        is "{.key}:{.value}", "$type:$tag", "Expected {.key} '{.value}'";
    }

    method prompt (Str $tag = '') { self!validate-expectation('prompt', $tag) }
    method if-begin () { self!validate-expectation('if-begin', '') }
    method in-room (Str $tag) { self!validate-expectation('in-room', $tag) }
    method describe-room (Str $tag) { self!validate-expectation('describe-room', $tag) }
}

# vim:set ft=perl6:
