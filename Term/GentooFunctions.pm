

package Term::GentooFunctions;

use strict;
use Exporter;
use Term::Size;
use Term::ANSIColor qw(:constants);
use Term::ANSIScreen qw(:cursor);

our $VERSION = "0.98";
our @EXPORT_OK = qw(einfo eerror ewarn ebegin eend eindent eoutdent);
our %EXPORT_TAGS = (all=>[@EXPORT_OK]);

use base qw(Exporter);

our $indent  = 0;
our $maxdent = 10;

1;

sub eindent  { my $i = int shift; $i=1 unless $i>1; $indent += $i; $indent = $maxdent if $indent > $maxdent }
sub eoutdent { my $i = int shift; $i=1 unless $i>1; $indent -= $i; $indent =        0 if $indent <        0 }

sub wash {
    my $msg = shift;
       $msg =~ s/[\r\n]//sg;
       $msg =~ s/^\s+//s;
       $msg =~ s/\s+$//s;

    return ("  " x $indent) . $msg;
}

sub einfo {
    my $msg = &wash(shift);

    print " ", BOLD, GREEN, "* ", RESET, "$msg\n";
}

sub eerror {
    my $msg = &wash(shift);

    print " ", BOLD, RED, "* ", RESET, "$msg\n";
}

sub ewarn {
    my $msg = &wash(shift);

    print " ", BOLD, YELLOW, "* ", RESET, "$msg\n";
}

sub ebegin {
    &einfo(@_);
}

sub eend {
    my $res = (int @_>0 ? shift : $_);
    my ($columns, $rows) = Term::Size::chars *STDOUT{IO};

    print up(1), right($columns - 7), BOLD, BLUE, "[ ", 
        ($res ?  GREEN."ok" : RED."!!"), 
        BLUE, " ]", RESET, "\n";

    $res;
}

__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

    Term::GentooFunctions - provides gentoo's einfo, ewarn, eerror, ebegin and eend.

=head1 SYNOPSIS

    use Term::GentooFunctions qw(:all)

    einfo "this is kinda neat...";

    ebegin "I hope this works...";
     ....
    eend $truefalse; # the result is backwards of gentoo; ie, 0 is bad, 1 is good.

=head1 prints

einfo, ewarn, and error show informative lines

=head1 ebegin and eend

ebegin and eend show the beginning and ends of things.

Additionally, eend returns the result passed in for handy returns at the bottom of functions...

    sub eg {
        eend 0; # eg now returns a false!!  Huzzah!
    }

Lastly, eend will use $_ if it is not passed any arguments.

=head1 indents

you can also use eindent and eoutdent to show trees of things happening:

einfo "something"
eindent 
einfo "something else" # indented
eoutdent
einfo "something else (again)" # un-dented

=head1 AUTHOR

Please contact me with ANY suggestions, no matter how pedantic.

Jettero Heller <japh@voltar-confed.org>

=head1 COPYRIGHT

GPL!  I included a gpl.txt for your reading enjoyment.

Though, additionally, I will say that I'll be tickled if you were to
include this package in any commercial endeavor.  Also, any thoughts to
the effect that using this module will somehow make your commercial
package GPL should be washed away.

I hereby release you from any such silly conditions.

This package and any modifications you make to it must remain GPL.  Any
programs you (or your company) write shall remain yours (and under
whatever copyright you choose) even if you use this package's intended
and/or exported interfaces in them.

=head1 SEE ALSO

Term::Size, Term::ANSIColor, Term::ANSIScreen
