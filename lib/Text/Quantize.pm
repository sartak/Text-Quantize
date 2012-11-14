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

sub _endpoints_for {
    my $buckets = shift;
    my ($min_endpoint, $max_endpoint);

    my @sorted_buckets = (sort { $a <=> $b } keys %$buckets);
    my $min = $sorted_buckets[0];
    my $max = $sorted_buckets[-1];

    if ($min == 0) {
        $min_endpoint = -1;
    }
    elsif ($min == 1) {
        $min_endpoint = 0;
    }
    elsif ($min < 0) {
        $min_endpoint = -1 * (2 ** (int(log(-$min) / log(2)) + 1));
    }
    else {
        $min_endpoint = 2 ** (int(log($min) / log(2)) - 1);
    }

    if ($max == 0) {
        $max_endpoint = 1;
    }
    elsif ($max == -1) {
        $max_endpoint = 0;
    }
    elsif ($max < 0) {
        $max_endpoint = -1 * (2 ** (int(log(-$max) / log(2)) - 1));
    }
    else {
        $max_endpoint = 2 ** (int(log($max) / log(2)) + 1);
    }

    return ($min_endpoint, $max_endpoint);
}

1;
