use strict;
use warnings;
use Test::More;

package MySubstrLeft {
    sub TIESCALAR {
        my ($class, $string_ref, $offset, $length) = @_;

        my $string = $$string_ref;
        $offset = $offset < 0 ? length($string) + $offset          : $offset;
        $length = $length > 0 ? $length + $offset - length($string): $length;

        return bless {
            string_ref => $string_ref,
            offset     => $offset,
            length     => $length,
        }, $class;
    }

    sub FETCH {
        my ($self) = @_;

        my @chars = split //, $self->{string_ref}->$*;
        my @sub_chars = splice @chars, $self->{offset}, $self->{length};

        return join '', @sub_chars;
    }

    sub STORE {
        my ($self, $replacement) = @_;

        my @chars = split //, $self->{string_ref}->$*;
        my @replacement_chars = split //, $replacement;
        splice @chars, $self->{offset}, $self->{length}, @replacement_chars;

        $self->{string_ref}->$* = join '', @chars;
    }
}

sub my_substr : lvalue {
    my ($str, $offset, $length, $replacement) = @_;
    my @chars = split //, $str;

    if (scalar @_ == 2) {
        my @sub_chars = splice @chars, $offset;
        my $substr = join '', @sub_chars;
        return $substr
    } elsif (scalar @_ == 3) {
        tie my $substr, 'MySubstrLeft', \$_[0], $offset, $length;
        return $substr;
    } else {
        my @replacement_chars = split //, $replacement;
        my @sub_chars = splice @chars, $offset, $length, @replacement_chars;
        $_[0] = join '', @chars;
        my $substr = join '', @sub_chars;
        return $substr
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
    is $z, 'climbed'                                 , '置き換えられた文字列が返る';
};

subtest 'ステップ3. 左辺値として使う' => sub {
    my $s = 'The black cat climbed the green tree';
    my_substr($s, 14, 7) = 'jumped from';
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
