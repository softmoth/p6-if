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
    has $!current-event = 0;

    method listen(*@listeners) {
        push %!listeners{.key}, .value for @listeners;
        return self;
    }

    method emit($name, *%attrs) {
        note "#emit $name {%attrs.perl}";
        @!log.push: Event.new(:$name, :%attrs);
        self!propagate();
        return self;
    }

    #| Propagate events to listeners. Since listeners may call emit(),
    #| we ensure that those subsequent events are processed *after* the
    #| current set of events is done. This also lets us identify when
    #| all events have been processed and an outside event trigger is
    #| needed to make progress. We propagate a special 'EOF' event in
    #| that case (but don't put it in the log).
    method !propagate ($recursive = False) {
        #note "# ", Backtrace.new;  # Examine if we're recursing or not
        sub call-listeners (Event $event) {
            #note "# CALL $event on %!listeners{}";
            if %!listeners{$event.name} -> @handlers {
                #note "# .....Have {+@handlers} handlers";
                $_.($event) for @handlers;
            }
        }

        #note "#\t$!current-event -> @!log[]";
        return unless $!current-event == @!log.end or $recursive;
        while $!current-event <= @!log.end {
            my $next = +@!log;
            call-listeners($_) for @!log[$!current-event .. *];
            $!current-event = $next;
        }

        die "IF::Events error, propagate ended with cur = $!current-event, log at {+@!log}"
            unless $!current-event == +@!log;

        return if $recursive;

        note "#EOF";
        call-listeners(Event.new(:name<EOF>));
        self!propagate(True);
    }

    method log ($pos = 0) {
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
