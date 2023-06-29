use strict;
use warnings;
use Test::More;

package MySubstrLeft {
    sub TIESCALAR {
        my ($class) = @_;
        print "TIESCALAR\n";
        return bless {}, $class;
    }

    sub FETCH {
        my ($self) = @_;
        print "FETCH\n";
        return undef;
    }

    sub STORE {
        my ( $self, $val ) = @_;
        print "STORE\n";
    }
}

sub my_substr : lvalue {
    my ( $str, $offset, $length, $replacement ) = @_;
    my @chars = split //, $str;

    if ( scalar @_ == 2 ) {
        my @sub_chars = splice @chars, $offset;
        my $substr    = join '', @sub_chars;
        return $substr;
    }
    elsif ( scalar @_ == 3 ) {
        my @sub_chars = splice @chars, $offset, $length;
        my $substr    = join '', @sub_chars;
        tie my $t, 'MySubstrLeft';
        return $t;
    }
    else {
        my @replacement_chars = split //, $replacement;
        my @sub_chars = splice @chars, $offset, $length, @replacement_chars;
        $_[0] = join '', @chars;
        my $substr = join '', @sub_chars;
        return $substr;
    }
}

subtest 'ステップ3. 左辺値として使う' => sub {
    my $s = 'The black cat climbed the green tree';
    my_substr( $s, 14, 7 ) = 'jumped from';
    is $s, 'The black cat jumped from the green tree', '元の文字列は置き換わる';
};

done_testing;
