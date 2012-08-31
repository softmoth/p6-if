use v6;
use Test;

class TestOut {
    has $!save;
    has $.out = '';

    submethod BUILD (:$!save!) {}

    method print (*@msgs) {
        $!out ~= @msgs.join;
    }
    method say (*@msgs) {
        self.print: $_ for @msgs;
        self.print: "\n";
    }
    method verify ($reason, $test) {
        temp $*OUT = $!save;
        given $test {
            sub report ($bool, $reason, $val) {
                ok $bool, $reason ~ ($bool ?? '' !! ", got '$val'");
            }
            when Regex { report $!out ~~ $test, $reason, $!out; }
            when Code  { report $test.($!out), $reason, $!out; }
            default    { is $!out, $test, $reason; }
        }
        $!out = '';
    }
}

class TestIn {
    method get () { 'INPUT' }
    method eof () { True }  # Disable input
}
