use v6;
use IF::View;

use Test;

class IF::View::Test is IF::View {
    has @!artifacts;

    submethod BUILD (:$events!) {
        # $.events is kept in IF::View, but can't be used on partially constructed
        # object here in submethod BUILD(); so bind it here, too.
        $events.listen:
            'EOF' => {
                self.prompt();
            };
    }

    method prompt (Str $tag = '') {
        @!artifacts.push: 'prompt' => '';
    }
    method if-begin ()              { @!artifacts.push: 'if-begin' => '' }
    method enter-room (Str $tag)       { @!artifacts.push: 'enter-room' => $tag }
    method describe-room (Str $tag) { @!artifacts.push: 'describe-room' => $tag }

    method input(Str $input) {
        self.verify;  # Should be nothing pending when input is made
        $.events.emit('command', :$input);
    }

    method !validate-expectation($type, $tag = '') {
        $_ = @!artifacts.shift // :error('MISSING');
        is "{.key}:{.value}", "$type:$tag", "Expected $type '$tag'";
    }

    method verify(*@expectations) {
        #note "# VERIFY {@!artifacts.perl}";
        for @expectations {
            self!validate-expectation(.key, .value);
        }

        is 'error' => 'UNEXPECTED', "{.key}:{.value}", "Expected {.key} '{.value}'"
            for @!artifacts;
        @!artifacts = ();
    }
}

# vim:set ft=perl6:
