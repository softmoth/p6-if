class IF::Events is export {
    my class Event is export {
        has $.name;
        has %.attrs;

        method Str {
            sprintf '%s[%s]', $.name, ~(map {":{.key}<{.value}>"}, %!attrs.sort);
        }
    }

    has Event @!log;
    has %!listeners;


    method listen(*@listeners) {
        push %!listeners{.key}, .value for @listeners;
        return self;
    }

    method emit($name, *%attrs) {
        my Event $event .= new(:$name, :%attrs);
        @!log.push($event);
        self!propagate($event);
        return self;
    }

    method !propagate(Event $event) {
        if %!listeners{$event.name} -> @handlers {
            $_($event) for @handlers;
        }
    }

    method log($pos = 0) {
        return @!log[$pos .. *];
    }

    method last() {
        return self.log(@!log.end)[0];
    }

    # Create a new event with same shorthand as emit() uses
    our sub make-event($name, *%attrs) {
        return Event.new(:$name, :%attrs);
    }
}

# vim:set ft=perl6:
