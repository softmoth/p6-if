#! /usr/bin/env perl6

role StringifyNameAttrs {
    method Str {
        sub name($attr) { $attr.name.substr(2) }
        sub value($attr) { $attr.get_value(self) }
        sub attrpair($attr) { ":{name $attr}<{value $attr}>" }

        sprintf '%s[%s]', self.^name, ~map &attrpair, self.^attributes;
    }
}

class X::IF is Exception {}

class IF::Event {
    has $.name;
    has %.attrs;

    method Str {
        sprintf '%s[%s]', $.name, ~map {":{.key}<{.value}>"}, %!attrs.pairs;
    }
}

class IF::EventStream {
    has IF::Event @!log;
    has @!listeners;

    method listen(Pair $listener) {
        @!listeners.push: $listener;
        return self;
    }

    method emit($name, *%attrs) {
        my $event = IF::Event.new(:$name, :%attrs);
        @!log.push($event);
        self!propagate($event);
        return self;
    }

    method !propagate(IF::Event $event) {
        # FIXME: make this more efficient
        for @!listeners».kv -> $type, $handler {
            if $event.name ~~ $type { $handler($event); }
        }
    }

    method since($pos = @!log.end) {
        return @!log[$pos .. *];
    }
}

class Game::Crypt {
    has $!events;
    has $!eventPosition = 0;

    submethod BUILD(:$!events) {
        # FIXME: How to do provide type of $!events in 'has' declaration,
        # and have this assignment happen automatically?
        $!events //= IF::EventStream.new;

        $!events.listen('GameBegins' => -> $e {
            my $room := $e.attrs<room>;
            $!events.emit('DescribesRoom', :$room);
        });
    }

    method begin {
        #die "Game already started\n" if @!events;
        $!events.emit('GameBegins', :room<Clearing>);
        return self;
    }

    method current() {
        return $!events.since($!eventPosition);
    }
}

sub MAIN('test') {
    use Test;

    class IF::Test is IF::Event {}

    {
        my IF::EventStream $events .= new;
        $events.emit('Event');
        $events.emit('Test');
        $events.emit('GameBegins', :room<Somewhere>);
        is $events.since(), ['GameBegins[:room<Somewhere>]'], "Logs most recent event";
        is $events.since(1), ['Test[]', 'GameBegins[:room<Somewhere>]'],
            "Logs all events";
    }

    {
        my IF::EventStream $events .= new;
        my %fired;
        sub fired($e) { ++%fired{$e.name}; }
        $events.listen('Test' => {
            fired($^event);
            $events.emit('GameBegins');
        });
        $events.listen('GameBegins' => &fired);
        $events.emit('Test');
        is $events.since(0), ['Test[]', 'GameBegins[]'],
            "Event listeners can generate events";
        is %fired<Test>, 1, "Test fired one listener";
        is %fired<GameBegins>, 1, "GameBegins fired one listener";
    }

    {
        my Game::Crypt $game = Game::Crypt.new.begin;
        ok $game, "A new game is created";
        is $game.current[0], 'GameBegins[:room<Clearing>]',
            "Starts with GameBegins";
        is $game.current[*-1], 'DescribesRoom[:room<Clearing>]',
            "Start of game describes the initial room";
    }

    done;
}

# vim:set ft=perl6:
