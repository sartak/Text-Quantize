package Text::Quantize;
# ABSTRACT: render a list of numbers as a textual chart
use strict;
use warnings;

sub bucketize {
    my $elements = shift;

    my %buckets;
    for my $element (@$elements) {
        my $bucket;

        if ($element == 0) {
            $bucket = 0;
        }
        elsif ($element < 0) {
            $bucket = -1 * (2 ** int(log(-$element) / log(2)));
        }
        else {
            $bucket = 2 ** int(log($element) / log(2));
        }

        $buckets{$bucket}++;
    }

    return \%buckets;
}

1;
