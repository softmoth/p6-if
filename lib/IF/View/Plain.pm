use v6;
use IF::View;

class IF::View::Plain is IF::View {
    submethod BUILD (:$events!) {
        $events.listen:
            'EOF' => {
                unless $*IN.eof {
                    my $input = self.prompt();
                    $events.emit('command', :$input);
                }
            },
            ;
    }
    method prompt (Str $tag = '') { prompt("$tag> ") }
    method if-begin () { say "== Interactive Fiction Game ==\n" }
    method enter-room (Str $tag) { say "== Room: $tag ==\n" }
    method describe-room (Str $tag) { say "Description of room $tag\n" }
}

# vim:set ft=perl6:
