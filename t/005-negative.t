#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Text::Quantize;

my $output = Text::Quantize::quantize([map { chomp; $_ } <DATA>], {
    left_label             => 'microseconds',
    middle_label           => 'Calls per time bucket * -1',
    right_label            => 'syscalls',
    distribution_width     => 80,
    distribution_character => '=',
});

is_deeply($output, <<'OUT');
 microseconds  -------------------------- Calls per time bucket * -1 -------------------------- syscalls
    -16777216 |                                                                                 0
     -8388608 |                                                                                 1
     -4194304 |===                                                                              4
     -2097152 |=======                                                                          9
     -1048576 |                                                                                 1
      -524288 |                                                                                 1
      -262144 |                                                                                 1
       -32768 |                                                                                 1
       -16384 |=                                                                                2
        -8192 |=======                                                                          9
        -4096 |============================                                                     36
        -2048 |==================                                                               23
        -1024 |=====                                                                            7
         -512 |====                                                                             5
         -256 |                                                                                 0
OUT

done_testing;

__DATA__
-2501064
-11148
-5807
-11152
-845161
-5601
-8896014
-6614
-21347
-5092
-4142
-9328
-4741
-1730
-35208
-3226
-1962163
-6407
-7341
-4726
-4914
-2707532
-5404
-14891
-5186
-4526
-7142
-4722
-4055
-3287669
-5096
-4526
-3912
-3668
-3945
-4074
-3645
-4099204
-6543
-5653
-4070
-4029
-4406
-4986324
-6844
-5257156
-4352
-4138
-2335266
-3219862
-8027
-5653
-3945
-3754
-4519
-6158764
-4006
-4113080
-4579
-3995
-4447
-6751453
-3889
-3520767
-4071
-3532
-3629
-3942
-4403
-694
-720
-603
-9045
-8016
-4632
-2984063
-13956
-9849
-3528
-18264
-2502
-7711
-11013
-2269
-1956
-833
-280195
-4741
-6075
-2024
-1794
-927
-13922
-2201
-1357
-5593
-1621
-6577
-1568
-4036