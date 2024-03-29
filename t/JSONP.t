# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl JSONP.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

#use lib '/home/acanfora/JSONP/lib';
use strict;
use warnings;

use Test::More;
BEGIN { use_ok('JSONP') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $j = JSONP->new;
isa_ok($j, 'JSONP', '$j');

$j->level1value = 1;

is($j->level1value, 1, 'setting level 1 value by Lvalue');

$j->level1value++;

is($j->level1value, 2, 'use increment ++ operator on Lvalue');

$j->level1node->level2value = 3;

is($j->level1node->level2value, 3, 'setting level 2 value by Lvalue');

$j->level1node->level2value++;

is($j->level1node->level2value, 4, 'use increment on level 2 value by Lvalue');

my $weirdkey = '§ߨ~ nobody+5@nowhere.net 䕨 has 64K €';

$j->this->$weirdkey->that = 64;

is($j->this->$weirdkey->that, 64, 'use exotic chars as keys');

my $numerickey = 100;

$j->that->$numerickey->index = 1000;

is($j->that->$numerickey->index, 1000, 'use numbers as keys');

$j->level1hash = {a => 1, b => 2};

is($j->level1hash->a, 1, 'assign hash to level 1 by Lvalue');

is($j->level1hash->{b}, 2, 'access hash assigned to level 1 by braces, first case');
is($j->{level1hash}->{b}, 2, 'access hash assigned to level 1 by braces, second case');
is($$j{level1hash}->{b}, 2, 'access hash assigned to level 1 by braces, third case');
is($$j{level1hash}{b}, 2, 'access hash assigned to level 1 by braces, fourth case');

$j->{firstlevelnodebybraces}->{secondlevelvalue} = 5;

is($j->firstlevelnodebybraces->secondlevelvalue, 5, 'access with JSONP to second level values set by braces'); 

$j->firstlevelarray = ['a', 'b', 'c'];

is($j->firstlevelarray->[1], 'b', 'assign array to first level node');

$j->firstlevelnode->secondlevelarray = ['a', 'b', 'c'];

is($j->firstlevelnode->secondlevelarray->[2], 'c', 'assign array to second level node');

$j->firstlevelnode->secondlevelnode = {
	a => 1,
	b => {
		d => 2,
	},
	c => [
		'e',
		{f => 3},
		[
			'g',
			4,
			{h => 5},
		]
	]
};

is($j->firstlevelnode->secondlevelnode->a, 1, 'verify assignment of complex data structure to second level node by Lvalue - leaf');
is($j->firstlevelnode->secondlevelnode->b->d, 2, 'verify assignment of complex data structure to second level node by Lvalue - nested leaf');
is($j->firstlevelnode->secondlevelnode->c->[0], 'e', 'verify assignment of complex data structure to second level node by Lvalue - hash of array');
is($j->firstlevelnode->secondlevelnode->c->[1]->f, 3, 'verify assignment of complex data structure to second level node by Lvalue - hash of array of hash');
is($j->firstlevelnode->secondlevelnode->c->[2]->[0], 'g', 'verify assignment of complex data structure to second level node by Lvalue - array of array');
is($j->firstlevelnode->secondlevelnode->c->[2]->[1], 4, 'verify assignment of complex data structure to second level node by Lvalue - array of array, second test');
is($j->firstlevelnode->secondlevelnode->c->[2]->[2]->h, 5, 'verify assignment of complex data structure to second level node by Lvalue - array of array of hash');

$j->firstlevelnode->secondlevelnode->a = {i => 6};

is($j->firstlevelnode->secondlevelnode->a->i, 6, 'replacing leaf deep value with hash and verify new leaf');

$j->firstlevelnode->secondlevelnode->b->d = ['j', {k => 7}];

is($j->firstlevelnode->secondlevelnode->b->d->[0], 'j', 'replace leaf deep value with array and verify new values - first test');
is($j->firstlevelnode->secondlevelnode->b->d->[1]->k, 7, 'replace leaf deep value with array and verify new values - second test');

$j->firstlevelnode->secondlevelnode->b->d->[1]->l(8);

is($j->firstlevelnode->secondlevelnode->b->d->[1]->l, 8, 'set deep leaf with function call notation');

$j->firstlevelnode->secondlevelnode->a = 9;

is($j->firstlevelnode->secondlevelnode->a, 9, 'replacing hash node with leaf value');

$j->firstlevelnode->secondlevelnode->a = ['l', 'm', {n => 'o'}];

is($j->firstlevelnode->secondlevelnode->a->[0], 'l', 'replacing deep leaf value with array - first test');
is($j->firstlevelnode->secondlevelnode->a->[1], 'm', 'replacing deep leaf value with array - second test');
is($j->firstlevelnode->secondlevelnode->a->[2]->n, 'o', 'replacing deep leaf value with array - third test');

$j->firstlevelnode->secondlevelnode->a = 11;

is($j->firstlevelnode->secondlevelnode->a, 11, 'replacing array node with leaf value');

$j->firstlevelnode->secondlevelnode->a({p => 12});

is($j->firstlevelnode->secondlevelnode->a->p, 12, 'replacing leaf deep value with hash by function call notation and verify new leaf');

$j->firstlevelnode->secondlevelnode->a(13);

is($j->firstlevelnode->secondlevelnode->a, 13, 'replacing hash node with leaf value by function call notation and verify new leaf');

$j->firstlevelnode->secondlevelnode->a(['q', {r => 14}]);

is($j->firstlevelnode->secondlevelnode->a->[0], 'q', 'replacing leaf deep value with array by function call notation and verify - first test');
is($j->firstlevelnode->secondlevelnode->a->[1]->r, '14', 'replacing leaf deep value with array by function call notation and verify - second test');


$j->firstlevelnode->secondlevelnode->b->d->[1]->l(8);

$j->raiseError('kapow');

is_deeply($j->errors, ['kapow'], 'call raiseError with a string - result an arrayref - kapow');

$j->raiseError([qw/zonk bam/], 404);

is_deeply($j->errors, ['kapow', 'zonk', 'bam'], 'call raiseError with an arrayref - result an arrayref - kapow, zonk, bam');
is($j->{_status_code}, 404, 'call raiseError with two arguments, check that status code was set - result string - 404');

my $jss = JSONP->new({
	firstkey => 5,
	secondkey => [1, 2, 3],
	thirdkey => {
		nested => \1
	},
});

my $jss2 = JSONP->new({
	secondkey => [1, 2, 3],
	thirdkey => {
		nested => \1
	},
	firstkey => 5,
});

my $jss3 = JSONP->new({
	secondkey => [1, 2, 3],
	thirdkey => {
		nested => \1,
		another => undef,
	},
	firstkey => 5,
});

my $dst = {
	thirdkey => {
		nested => \1
	},
	secondkey => [1, 2, 3],
	firstkey => 5,
};

my $dsf = {
	secondkey => [1, 2, 3],
	thirdkey => {
		nested => \1
	},
	firstkey => 5,
	_hidden => 'something'
};

my $jsont = '{
	"thirdkey": {"nested": true},
	"firstkey": 5,
	"secondkey": [1, 2, 3]
}';

my $jsonf = '{
	"thirdkey": {"nested": true},
	"firstkey": 5,
	"secondkey": [1, 2, 3, 4]
}';

ok($jss eq $jss2, 'checking eq operator overloading between JSONP objects');
ok($jss ne $jss3, 'checking ne operator overloading between JSONP objects');
ok($jss eq $dst, 'checking eq operator overloading between JSONP object and Perl data structure');
ok($jss ne $dsf, 'checking ne operator overloading between JSONP object and Perl data structure');
ok($jss eq $jsont, 'checking eq operator overloading between JSONP object and JSON string');
ok($jss ne $jsonf, 'checking ne operator overloading between JSONP object and JSON string');
isnt($jss eq '', 1, 'checking eq operator overloading between JSONP object and void string');
ok($jss ne '', 'checking ne operator overloading between JSONP object and void string');
isnt($jss eq undef, 1, 'checking eq operator overloading between JSONP object and undef');
ok($jss ne undef, 'checking ne operator overloading between JSONP object and undef');

isa_ok($jss, 'JSONP', '$jss');

done_testing();
