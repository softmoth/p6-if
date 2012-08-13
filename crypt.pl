#! /usr/bin/env perl6

class X::IF is Exception {}

class IF::Event {
    has $.name;
    has %.attrs;

    method Str {
        sprintf '%s[%s]', $.name, ~(map {":{.key}<{.value}>"}, %!attrs.sort);
    }
}

class IF::EventStream {
    has IF::Event @!log;
    has %!listeners;

    method listen(Pair $listener) {
        %!listeners{$listener.key} = $listener.value;
        return self;
    }

    method emit($name, *%attrs) {
        my $event = IF::Event.new(:$name, :%attrs);
        @!log.push($event);
        self!propagate($event);
        return self;
    }

    method !propagate(IF::Event $event) {
        if %!listeners{$event.name} -> $handler {
            $handler($event);
        }
    }

    method log($pos = 0) {
        return @!log[$pos .. *];
    }

    method last() {
        return self.log(@!log.end)[0];
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

        # Kick off the game!
        $!events.emit('GameBegins', :room<Clearing>);
    }

    method events() {
        return $!events.log($!eventPosition);
    }

    method history() {
        return $!events.log;
    }

    method do($str) {
        $!events.emit('DescribesRoom', :room<Clearing>);
    }
}

sub MAIN('test') {
    use Test;

    # Create a new event with same shorthand as emit() uses
    sub e($name, *%attrs) {
        return IF::Event.new(:$name, :%attrs);
    }

    class IF::Test is IF::Event {}

    {
        is e('Test', :num<100>, :foo<bar>),
           e('Test', :foo<bar>, :num<100>),
           "Event attributes can be listed in any order";
    }

    {
        my IF::EventStream $events .= new;
        $events.emit('Event');
        $events.emit('Test', :num<100>, :foo<bar>);
        $events.emit('GameBegins', :room<Somewhere>);

        is $events.last(), e('GameBegins', :room<Somewhere>),
            "Logs most recent event";

        is $events.log(1), [
                e('Test', :foo<bar>, :num<100>),
                e('GameBegins', :room<Somewhere>)
            ], "Logs all events";
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
        is $events.log(), [e('Test'), e('GameBegins')],
            "Event listeners can generate events";
        is %fired<Test>, 1, "Test fired one listener";
        is %fired<GameBegins>, 1, "GameBegins fired one listener";
    }

    {
        my Game::Crypt $game .= new;
        ok $game, "A new game is created";
        is $game.events[0], e('GameBegins', :room<Clearing>),
            "Starts with GameBegins";
        is $game.events[*-1], e('DescribesRoom', :room<Clearing>),
            "Start of game describes the initial room";

        $game.do('look');

        is $game.events[*-2 .. *], e('DescribesRoom', :room<Clearing>) xx 2,
            "Looking describes the room";
    }

    done;
}

# vim:set ft=perl6:
