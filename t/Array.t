use Test::More;

use strict;
use warnings;

use JSONP;

my $j = JSONP->new();

$j->array = [qw/one two three/];

is($j->array->serialize, "[\"one\",\"two\",\"three\"]", "serialize a simple array");

$j->array = [{ a => "b" }, { c => "d" }, { e => "f" }];

is($j->array->serialize, "[{\"a\":\"b\"},{\"c\":\"d\"},{\"e\":\"f\"}]", "serialize an array of hashes" );

done_testing(2);

1;

