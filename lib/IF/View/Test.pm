use v6;
use IF::View;

use Test;
use IF::Test;

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
        $.events.emit('command', :$input);
    }

    method verify-all(*@expectations) {
        #note "# VERIFY-ALL {@!artifacts.perl}";
        for @expectations {
            my $a = @!artifacts.shift // :error('MISSING');
            is "{$a.key}:{$a.value}", "{.key}:{.value}", "Expected {.key} '{.value}'";
        }

        is 'error' => 'UNEXPECTED', "{.key}:{.value}", "Expected {.key} '{.value}'"
            for @!artifacts;
        @!artifacts = ();
    }

    # Expectations need to be in order, but just skip over non-matching
    # artifacts silently
    method verify(*@expectations) {
        my @passed;
        my @working;
        while @expectations.shift -> $e {
            if @!artifacts.shift -> $a {
                push @working, $a;
                redo unless $a.key eq $e.key and check($a.value, $e.value);

                ok True, "Expected {$e.key} '{$e.value}'";
                @passed.push: @working;
                @working = ();
                next;
            }

            report False, "Verify", {:@passed, :@working}, @expectations.unshift($e);
            last;
        }

        @!artifacts = ();
    }

    method if-begin (%attrs) { @!artifacts.push: 'if-begin' => %attrs<title> }
    method enter-room (%attrs) { @!artifacts.push: 'enter-room' => %attrs<room> }
    method describe-room (%attrs) { @!artifacts.push: 'describe-room' => %attrs<room> }
}

# vim:set ft=perl6:
