#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Text::Quantize;

my $output = Text::Quantize::quantize([map { chomp; $_ } <DATA>], {
    left_label             => 'nanoseconds',
    middle_label           => 'Calls per time bucket',
    right_label            => 'syscalls',
    distribution_width     => 80,
    distribution_character => '=',
});

is_deeply($output, <<'OUT');
 nanoseconds  ---------------------------- Calls per time bucket ----------------------------- syscalls
          -1 |                                                                                 0
           0 |                                                                                 1
           1 |==                                                                               3
           2 |=====                                                                            7
           4 |=========================                                                        32
           8 |===========                                                                      14
          16 |                                                                                 1
          32 |==                                                                               3
         128 |                                                                                 1
         512 |===                                                                              5
        1024 |==============                                                                   18
        2048 |======                                                                           8
        4096 |======                                                                           8
        8192 |                                                                                 0
OUT

done_testing;

__DATA__
758
3306
63
9
6
1082
5
162
1294
10
2
3
7
1367
3655
6
6515
5
4
1245
5
6
3
4
3
3618
2599
7652
1161
7
59
7
1230
8142
5
4
4
957
7816
590
2206
982
1217
6
1407
1340
2
53
2
5
4
4
1422
1
6192
4
4
9
4
8
8
1435
8
6
8
4
4995
7
20
1364
7
2856
1412
11
1211
5
5
6
3
1
1
0
2530
1224
6
3288
1203
9
4
1835
9
2011
14
5688
8
583
6
7061
7
12
8
