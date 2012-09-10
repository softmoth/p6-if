class IF::Events is export {
    my class Event is export {
        has $.name;
        has %.attrs;

        method Str {
            sprintf '%s[%s]', $.name, ~(map {":{.key}<{.value}>"}, %!attrs.sort);
        }
    }

    has Event @.log;
    has %!listeners;
    has $!current-event = 0;

    method listen(*@listeners) {
        push %!listeners{.key}, .value for @listeners;
        return self;
    }

    method emit($name, *%attrs) {
        # NB: Rakudo and Niecza .perl don't handle data structures with cycles,
        # and will just loop forever. So avoid using .perl on %attrs, since
        # rooms have circular references
        note "#emit $name {%attrs.Str}" if %*ENV<IF_EVENT_DEBUG_HACK>;
        @!log.push: make-event($name, |%attrs);
        self!propagate();
        return self;
    }

    #| Propagate events to listeners. Listeners may call emit(), and
    #| those subsequent events are processed *after* the current set of
    #| events is done. This ensures that, e.g., when a 'quit' listener
    #| emits an 'exit' event, other 'quit' listeners have a chance to
    #| fire before the 'exit' listener.
    #|
    #| This also lets us identify when all events have been processed
    #| and an outside event trigger is needed to make progress. We
    #| propagate a special 'EOF' event in that case (but don't put it in
    #| the log).
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

        note "#EOF" if %*ENV<IF_EVENT_DEBUG_HACK>;
        call-listeners(Event.new(:name<EOF>));
        self!propagate(True);

        CATCH {
            when 'LAST' {
                # Jump out of event loop completely
                self!reset;
            }
        }
    }

    method !reset () {
        ++$!current-event;
        my @pending = @!log.splice: $!current-event;
        note "# RESET TOSSED EVENTS: @pending[]" if @pending;
    }

    our sub make-event($name, *%attrs) {
        return Event.new(:$name, :%attrs);
    }
}

# vim:set ft=perl6:
