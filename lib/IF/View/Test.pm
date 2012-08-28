use v6;
use IF::View;

use Test;

class IF::View::Test is IF::View {
    has @!expectations;

    submethod BUILD (:$events!) {
        # $.events is kept in IF::View, but can't be used on partially constructed
        # object here in submethod BUILD(); so bind it here, too.
        $events.listen:
            'EOF' => {
                self.prompt();
            };
    }

    method expect(*%exp) {
        # Report un-matched expectations as failures
        my %commands = classify {.key eq 'command'}, @!expectations;
        ok False, "Expected {.key} '{.value}'" for %commands<False> // ();

        @!expectations = @(%commands<True> // ()), %exp;
    }

    method !validate-expectation($type, $tag = '') {
        $_ = @!expectations.shift // :error('no expectations');
        is "{.key}:{.value}", "$type:$tag", "Expected {.key} '{.value}'";
    }

    method prompt (Str $tag = '') {
        self!validate-expectation('prompt', $tag);
        @!expectations.push('command' => '');
    }
    method if-begin () { self!validate-expectation('if-begin') }
    method in-room (Str $tag) { self!validate-expectation('in-room', $tag) }
    method describe-room (Str $tag) { self!validate-expectation('describe-room', $tag) }

    method input(Str $command) {
        self!validate-expectation('command');
        &.do-command.($command);
    }
}

# vim:set ft=perl6:
