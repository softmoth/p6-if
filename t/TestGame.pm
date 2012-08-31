use v6;
use IF::Game;

class TestGame does IF::Game {
    method title () { 'Dust Bowl' }
    method about () { "Cowboys\nand\nOutlaws\n" }
    method initial-room () { 'Saloon' }
}
