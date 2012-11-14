#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Text::Quantize;

my $output = quantize([26, 24, 51, 77, 21], {
    add_endpoints => 0,
});

is_deeply($output, <<'OUT');
 value  ------------- Distribution ------------- count
    16 |@@@@@@@@@@@@@@@@@@@@@@@@                 3
    32 |@@@@@@@@                                 1
    64 |@@@@@@@@                                 1
OUT

$output = quantize([26, 24, 51, 77, 21], {
    minimum       => 0,
    maximum       => 1024,
    add_endpoints => 0,
});

is_deeply($output, <<'OUT');
 value  ------------- Distribution ------------- count
    16 |@@@@@@@@@@@@@@@@@@@@@@@@                 3
    32 |@@@@@@@@                                 1
    64 |@@@@@@@@                                 1
OUT

done_testing;

