package Text::Quantize;
# ABSTRACT: render a list of numbers as a textual chart
use strict;
use warnings;
use List::Util 'sum';

sub bucketize {
    my $elements = shift;
    my $options  = {
        add_endpoints => 1,
        %{ shift(@_) || {} },
    };

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

    # allow user to specify only one of the two endpoints if desired, and figure the other out
    if ($options->{add_endpoints}) {
        unless (defined($options->{minimum}) && defined($options->{maximum})) {
            my ($min, $max) = _endpoints_for(\%buckets);
            $options->{minimum} = $min if !defined($options->{minimum});
            $options->{maximum} = $max if !defined($options->{maximum});
        }

        # force the min and max to exist, but if that endpoint has a value don't blindly overwrite it
        $buckets{ $options->{minimum} } ||= 0;
        $buckets{ $options->{maximum} } ||= 0;
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

sub quantize {
    my $elements = shift;
    my %options  = (
        distribution_width     => 40,
        distribution_character => '@',
        left_label             => 'value',
        middle_label           => 'Distribution',
        right_label            => 'count',
        %{ shift(@_) || {} },
    );

    my $buckets = bucketize($elements, \%options);

    my $distribution_width = $options{distribution_width};
    my $distribution_character = $options{distribution_character};

    my $sum = sum values %$buckets;

    my $left_width = length($options{left_label});
    for my $bucket (keys %$buckets) {
        $left_width = length($bucket)
            if length($bucket) > $left_width;
    }
    $left_width++;

    my $middle_spacer = $distribution_width - length($options{middle_label}) - 2;
    my $middle_left = int($middle_spacer / 2);
    my $middle_right = $middle_spacer - $middle_left;

    my @output = sprintf '%*s  %s %s %s %s',
        $left_width,
        $options{left_label},
        ('-' x $middle_left),
        $options{middle_label},
        ('-' x $middle_right),
        $options{right_label};

    for my $bucket (sort { $a <=> $b } keys %$buckets) {
        my $count = $buckets->{$bucket};
        my $ratio = ($count / $sum);
        my $width = $distribution_width * $ratio;

        push @output, sprintf '%*d |%-*s %d',
            $left_width,
            $bucket,
            $distribution_width,
            ($distribution_character x $width),
            $count;
    }

    return wantarray ? @output : (join "\n", @output)."\n";
}

1;

__END__

=head1 SYNOPSIS

    use Text::Quantize;
    
    print quantize([26, 24, 51, 77, 21]);
    
    __END__
    
     value  ------------- Distribution ------------- count
         8 |                                         0
        16 |@@@@@@@@@@@@@@@@@@@@@@@@                 3
        32 |@@@@@@@@                                 1
        64 |@@@@@@@@                                 1
       128 |                                         0



    use Text::Quantize ();

    print Text::Quantize::quantize([map { chomp; $_ } <DATA>], {
        left_label             => 'microseconds',
        middle_label           => 'Calls per time bucket',
        right_label            => 'syscalls',
        distribution_width     => 80,
        distribution_character => '=',
    });
    
    __END__
    
     microseconds  ---------------------------- Calls per time bucket ----------------------------- syscalls
              256 |                                                                                 0
              512 |====                                                                             5
             1024 |=====                                                                            7
             2048 |==================                                                               23
             4096 |============================                                                     36
             8192 |=======                                                                          9
            16384 |=                                                                                2
            32768 |                                                                                 1
           262144 |                                                                                 1
           524288 |                                                                                 1
          1048576 |                                                                                 1
          2097152 |=======                                                                          9
          4194304 |===                                                                              4
          8388608 |                                                                                 1
         16777216 |                                                                                 0

=cut

