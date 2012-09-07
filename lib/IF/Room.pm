use v6;

# NB: nowhere is falsey
enum IF::Direction <nowhere east northeast north northwest west southwest south southeast>;

class IF::Room {
    has $.name;
    has $.description;
    has $.exits = {};

    my %opposites =
        east => west,
        northeast => southwest,
        north => south,
        northwest => southeast,
        west => east,
        southwest => northeast,
        south => north,
        southeast => northwest
        ;

    submethod BUILD (:$!name, :$!description) {
        for $!name, $!description {
            $_ .= trim;
            $_ .= subst: rx/ \n\n+ /, "\n\n", :g;
        }
    }

    method Str () {
        "Room<$.name>"
    }

    method connect(IF::Direction $dir, IF::Room $dest, IF::Direction $reverse = %opposites{$dir}) {
        $!exits{$dir} = $dest;
        $dest.connect($reverse, self, nowhere) if $reverse;
    }
}

# vim:set ft=perl6:
