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

    method !validate-expectation($type, $msg) {
        $_ = @!expectations.shift // :error('no expectations');
        is "{.key}:{.value}", "$type:$msg", "Expected {.key} '{.value}'";
    }
    method header ($msg) {
        self!validate-expectation('header', $msg);
    }
    method info (Str $msg) {
        self!validate-expectation('info', $msg);
    }
    method prompt (Str $msg = '') {
        self!validate-expectation('prompt', $msg);
    }
}

# vim:set ft=perl6:
