package Text::Quantize;
# ABSTRACT: render a list of numbers as a textual chart
use strict;
use warnings;

sub _next_power_of_2 {
    my $num = int(shift);
    my $sign = 1;

    if ($num == 0) {
        return 0;
    }

    if ($num < 0) {
        $sign = -1;
        $num *= -1;
    }

    my $pow = 1;
    while ($num >= $pow) {
        $pow *= 2;
    }

    return $sign * $pow;
}

1;
