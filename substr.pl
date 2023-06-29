use strict;
use warnings;
use Test::More;

subtest 'ステップ1. 部分文字列の取り出し' => sub {
    my $s = 'The black cat climbed the green tree';

    my $color = substr $s, 4, 5;
    is $color, 'black';

    my $middle = substr $s, 4, -11;
    is $middle, 'black cat climbed the';

    my $end = substr $s, 14;
    is $end, 'climbed the green tree';

    my $tail = substr $s, -4;
    is $tail, 'tree';

    my $z = substr $s, -4, 2;
    is $z, 'tr';
};

subtest 'ステップ2. 一部を置き換え' => sub {
    my $s = 'The black cat climbed the green tree';
    my $z = substr $s, 14, 7, 'jumped from';
    is $s, 'The black cat jumped from the green tree', '元の文字列は置き換わる';
    is $z, 'climbed'                                 , '置き換えられた文字列が返る';
};

subtest 'ステップ3. 左辺値として使う' => sub {
    my $s = 'The black cat climbed the green tree';
    substr($s, 14, 7) = 'jumped from';
    is $s, 'The black cat jumped from the green tree', '元の文字列は置き換わる';
};

subtest 'ステップ4. 魔法の弾丸' => sub {
    my $x = '1234';
    for (substr $x, 1, 2) {
        is $_, '23';

        $_ = 'a';
        is $x, '1a4';

        $_ = 'xyz';
        is $x, '1xyz4';

        $x = '56789';
        $_ = 'pq';
        is $x, '5pq9';
    }

    my $y = '1234';
    for (substr($y, -3, 2)) {
        $_ = 'a';
        is $y, '1a4';

        $y = 'abcdefg';
        is $_, 'f';
    }
};

done_testing;
