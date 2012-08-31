use v6;
use IF::View;

class IF::View::Plain is IF::View {
    submethod BUILD (:$events!) {
        $events.listen:
            'EOF' => {
                # Safety to prevent infinite loop, in case the quit-on-undef
                # logic fails
                unless $*IN.eof {
                    my $input = prompt("> ");
                    $events.emit('command', :$input);
                }
            },
            'quit' => { say "Goodbye!" },
            'exit' => { exit },
            'no-parse' => { say "Sorry, I didn't catch that." },
            ;
    }

    method if-begin () { say "== Interactive Fiction Game ==\n" }
    method enter-room (Str $tag) { say "== Room: $tag ==\n" }
    method describe-room (Str $tag) { say "Description of room $tag\n" }
}

# vim:set ft=perl6:
