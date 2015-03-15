package DDG::Goodie::RIPEMD;
# ABSTRACT: Computes the RIPEMD family of cryptographic hash functions. 

use strict;
use DDG::Goodie;
use Crypt::Digest::RIPEMD128;
use Crypt::Digest::RIPEMD160;
use Crypt::Digest::RIPEMD256;
use Crypt::Digest::RIPEMD320;

zci answer_type => "ripemd";
zci is_cached   => 1;

name "RIPEMD";
description "RIPEMD hash algorithms";
primary_example_queries "RIPEMD this", 
                        "RIPEMD-256 that";
secondary_example_queries "ripemd-320 this string", 
                          "ripemd-128 hash of string", 
                          "ripemd320 secret",
                          "ripemdsum message";
category "calculations";
topics "cryptography";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/RIPEMD.pm";
attribution github => ["rafacas", "Rafa Casado"],
            twitter => "rafacas";

triggers query => qr/^
    ripemd\-?(?<ver>128|160|256|320|)?(?:sum|)\s*
    (?<enc>hex|base64|)\s+
    (?<str>.*)
    $/ix;

handle query => sub {
    my $ver = $+{'ver'}    || 160;    # RIPEMD-160 is the most common version in the family
    my $enc = lc $+{'enc'} || 'hex';
    my $str = $+{'str'}    || '';

    $str =~ s/^hash\s+(.*\S+)/$1/;    # Remove 'hash' in queries like 'ripemd hash this'
    $str =~ s/^of\s+(.*\S+)/$1/;      # Remove 'of' in queries like 'ripemd hash of this'
    $str =~ s/^\"(.*)\"$/$1/;         # remove quotes (e.g. ripemd256 "this string")
    return unless $str;

    $enc =~ s/base64/b64/;            # the suffix for the base64 functions is b64 (ex: ripemd160_b64)

    my $func_name = 'Crypt::Digest::RIPEMD' . $ver . '::ripemd' . $ver . '_' . $enc;
    my $func      = \&$func_name;

    my $out = $func->($str);

    return $out,
      structured_answer => {
        input     => [html_enc($str)],
        operation => 'RIPEMD-' . $ver . ' ' . $enc . ' hash',
        result    => $out
      };

};

1;
