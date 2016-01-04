package DDG::Goodie::PercentError;
# ABSTRACT: find the percent error given accepted and experimental values

use strict;
use DDG::Goodie;

triggers start => "percent error", "% error", "%err", "%error", "percenterror", "percent err", "%-error";

zci answer_type => "percent_error";
zci is_cached => 1;

primary_example_queries 'percent-error 34.5 35';
secondary_example_queries '%err 41 43', '%-error 2.88 2.82';
description 'find the percent error given accepted and experimental values';
name 'PercentError';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PercentError.pm';
category 'calculations';
topics 'math';
attribution twitter => ['crazedpsyc', 'Michael Smith'],
            cpan    => ['CRZEDPSYC', 'Michael Smith'],
            github  => ["https://github.com/Mailkov", "Melchiorre Alastra"];

handle remainder => sub {
    my $length = length($_);

    my ( $acc, $exp ) = split /\s*[\s;,]\s*/, $_;
    return unless $acc =~ /^-?\d+?(?:\.\d+|)$/ && $exp =~ /^-?\d+?(?:\.\d+|)$/;

    my $diff = abs $acc - $exp;
    my $per = abs ($diff/$acc);
    my $err = $per*100;
    
    return "Accepted: $acc Experimental: $exp Error: $err%",
    structured_answer => {
        id => 'percent_error',
        name => 'Answer',
        data => {
            title => "Error: $err%",
            subtitle => "Accepted: $acc Experimental: $exp",
        },
        templates => {
            group => 'text',
        }
    };
};

1;
