use strict;
use warnings;
use Test::More;

sub my_substr {
    my ( $string, $offset, $length, $replacement ) = @_;
    my @chars = split //, $string;

    if ( scalar @_ == 2 ) {
        my @sub_chars = splice @chars, $offset;
        return join '', @sub_chars;
    }
    elsif ( scalar @_ == 3 ) {
        my @sub_chars = splice @chars, $offset, $length;
        return join '', @sub_chars;
    }
    else {
        my @replacement_chars = split //, $replacement;
        my @sub_chars = splice @chars, $offset, $length, @replacement_chars;
        $_[0] = join '', @chars;
        return join '', @sub_chars;
    }
}

subtest 'ステップ1. 部分文字列を取り出し' => sub {
    my $s = 'The black cat climbed the green tree';

    my $color = my_substr $s, 4, 5;
    is $color, 'black';

    my $middle = my_substr $s, 4, -11;
    is $middle, 'black cat climbed the';

    my $end = my_substr $s, 14;
    is $end, 'climbed the green tree';

    my $tail = my_substr $s, -4;
    is $tail, 'tree';

    my $z = my_substr $s, -4, 2;
    is $z, 'tr';
};

subtest 'ステップ2. 一部を置き換え' => sub {
    my $s = 'The black cat climbed the green tree';
    my $z = my_substr $s, 14, 7, 'jumped from';
    is $s, 'The black cat jumped from the green tree', '元の文字列は置き換わる';
    is $z, 'climbed',                                  '置き換えられた文字列が返る';
};

done_testing;
