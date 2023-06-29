use strict;
use warnings;
use Test::More;

sub my_substr {
    my ( $string, $offset, $length ) = @_;
    my @chars = split //, $string;

    if ( scalar @_ == 2 ) {
        my @sub_chars = splice @chars, $offset;
        return join '', @sub_chars;
    }
    else {
        my @sub_chars = splice @chars, $offset, $length;
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

done_testing;
