use IF::Room;

role IF::Game {
    method title () { 'A Game' }
    method about () { '' }
    method initial-room () returns IF::Room { !!! }
}

# vim:set ft=perl6:
