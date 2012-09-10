use v6;


class IF::Room {
    my @directions = <east northeast north northwest west southwest south southeast>;
    our subset IF::Direction of Str where any(@directions);

    has $.name;
    has $.description;
    has $.exits = {};

    my %opposites =
        :east<west>,
        :northeast<southwest>,
        :north<south>,
        :northwest<southeast>,
        ;
    %opposites.push: %opposites.invert;

    submethod BUILD (:$!name, :$!description) {
        for $!name, $!description {
            $_ .= trim;
            $_ .= subst: rx/ \n\n+ /, "\n\n", :g;
        }
    }

    method Str () {
        "Room<$.name>"
    }

    method directions () { @directions }

    method connect1(IF::Direction $dir, IF::Room $dest) {
        $!exits{$dir} = $dest;
    }

    method connect(IF::Direction $dir, IF::Room $dest, IF::Direction $reverse = %opposites{$dir}) {
        $.connect1($dir, $dest);
        $dest.connect1($reverse, self);
    }
}

# vim:set ft=perl6:
