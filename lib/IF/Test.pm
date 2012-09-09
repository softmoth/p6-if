module IF::Test;

use Test;
# Rakudo NYI
#use Test :EXPORT;

our sub report ($passed, $reason, $got, $expected) is export {
    ok $passed, $reason;
    if !$passed {
        my $got_perl      = try { $got.perl };
        my $expected_perl = try { $expected.perl };
        if $got_perl.defined && $expected_perl.defined {
            diag "     got: $got_perl";
            diag "expected: $expected_perl";
        }
    }

}
our sub check ($got, $expected) is export {
    given $expected {
        when Regex { $got ~~ $expected }
        when Code  { $expected.($got) }
        default    { ~$got eq ~$expected }
    }
}

class IF::Test::Out {
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
        report(check($!out, $test), $reason, $!out, $test);
        $!out = '';
    }
}

class IF::Test::In {
    method get () { 'INPUT' }
    method eof () { True }  # Disable input
}

# vim:set ft=perl6:
