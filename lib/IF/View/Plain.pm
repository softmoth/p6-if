use v6;
use IF::View;

class IF::View::Plain is IF::View {
    my @begYourPardon =
        "Sorry, I didn't catch that.",
        "Come again, please?",
        "Hmmm, I seem to be having a hard time getting that.",
        "How's that again?",
        "Mmmmmh, sorry, I didn't get that."
        ;
    submethod BUILD (:$events!) {
        $events.listen:
            'EOF' => {
                # Safety to prevent infinite loop, in case the quit-on-undef
                # logic fails
                unless $*IN.eof {
                    my $input = prompt("\n> ");
                    $events.emit('command', :$input);
                }
            },
            'quit' => { say "Goodbye!" },
            'exit' => { exit },
            'no-parse' => { print @begYourPardon.pick; },
            ;
    }

    method if-begin (%attrs) {
        say "== %attrs<title> ==";
        if %attrs<about> { say "\n", $^it }
    }
    method enter-room (%attrs) { say "\n== Room: %attrs<room> ==" }
    method describe-room (%attrs) { say "\nDescription of room %attrs<room>" }
}

# vim:set ft=perl6:
