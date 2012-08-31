use v6;
use IF::View;

use Test;

class IF::View::Test is IF::View {
    has @!artifacts;

    submethod BUILD (:$events!) {
        # $.events is kept in IF::View, but can't be used on partially constructed
        # object here in submethod BUILD(); so bind it here, too.
        $events.listen:
            'EOF' => { @!artifacts.push: 'prompt' => '' },
            'exit' => {
                @!artifacts.push: 'exit' => '';
                die "LAST";
            },
            'no-parse' => { @!artifacts.push: 'huh' => .attrs<input>; },
            ;
    }

    method input(Str $input) {
        self.verify;  # Should be nothing pending when input is made
        $.events.emit('command', :$input);
    }

    method verify(*@expectations) {
        #note "# VERIFY {@!artifacts.perl}";
        for @expectations {
            my $a = @!artifacts.shift // :error('MISSING');
            is "{$a.key}:{$a.value}", "{.key}:{.value}", "Expected {.key} '{.value}'";
        }

        is 'error' => 'UNEXPECTED', "{.key}:{.value}", "Expected {.key} '{.value}'"
            for @!artifacts;
        @!artifacts = ();
    }

    method if-begin (%attrs) { @!artifacts.push: 'if-begin' => %attrs<title> }
    method enter-room (%attrs) { @!artifacts.push: 'enter-room' => %attrs<room> }
    method describe-room (%attrs) { @!artifacts.push: 'describe-room' => %attrs<room> }
}

# vim:set ft=perl6:
