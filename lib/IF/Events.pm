
class IF::Event is export {
    has $.name;
    has %.attrs;

    method Str {
        sprintf '%s[%s]', $.name, ~(map {":{.key}<{.value}>"}, %!attrs.sort);
    }
}

class IF::Events::Stream is export {
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

module IF::Events {
    # Create a new event with same shorthand as emit() uses
    our sub makeEvent($name, *%attrs) {
        return IF::Event.new(:$name, :%attrs);
    }
}
